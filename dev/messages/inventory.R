## Message inventory for agetime.
##
## Run from the package root:
##   Rscript dev/messages/inventory.R
##
## Writes dev/messages/inventory.csv (one row per message bullet) and
## prints a summary. See dev/messages.md for the design.


## Settings ------------------------------------------------------------------

## Functions that signal conditions, or store message text for later
## signalling. 'arg' is the argument holding the message.
SIGNALS <- data.frame(
  fun = c("abort_msg", "warn_msg", "inform_msg",
          "cli_abort", "cli_warn", "cli_inform", "abort", "warn", "inform",
          "stop", "warning", "message", "x_label_fail"),
  signal = c("abort", "warn", "inform",
             "cli_abort", "cli_warn", "cli_inform", "rlang_abort", "rlang_warn",
             "rlang_inform", "base_stop", "base_warning", "base_message",
             "stored"),
  arg = c("message", "message", "message",
          "message", "message", "message", "message", "message", "message",
          "...", "...", "...", "msg")
)

## The signalling wrappers themselves, whose cli calls are not messages.
WRAPPERS <- c("abort_msg", "warn_msg", "inform_msg")

PATH_R <- "R"
PATH_OUT <- file.path("dev", "messages", "inventory.csv")


## Parsing -------------------------------------------------------------------

## Find signalling calls in one file. Returns one row per call, with
## the call itself (as a list column), its first line, and the name of
## the enclosing top-level function.
find_signal_calls <- function(file) {
  exprs <- parse(file, keep.source = TRUE)
  pd <- utils::getParseData(exprs, includeText = TRUE)
  is_fun <- pd$token == "SYMBOL_FUNCTION_CALL" & pd$text %in% SIGNALS$fun
  ids_fun <- pd$id[is_fun]
  rows <- lapply(ids_fun, function(id) {
    id_name <- pd$parent[pd$id == id]
    id_call <- pd$parent[pd$id == id_name]
    ## a package prefix ('cli::') sits inside the name expression
    pkg <- pd$text[pd$parent == id_name & pd$token == "SYMBOL_PACKAGE"]
    text <- utils::getParseText(pd, id_call)
    call <- str2lang(text)
    line <- pd$line1[pd$id == id_call]
    data.frame(file = basename(file),
               line = line,
               fun = enclosing_fun(pd, line),
               called = pd$text[pd$id == id],
               pkg = if (length(pkg)) pkg else NA_character_,
               call = I(list(call)))
  })
  do.call(rbind, rows)
}

## Assignments in one file, for following messages built in local
## variables. Returns one row per assignment 'sym <- value', with the
## enclosing function, line, and value; and assignments
## 'names(sym) <- rep("x", ...)', which set bullet types.
find_assignments <- function(file) {
  exprs <- parse(file, keep.source = TRUE)
  pd <- utils::getParseData(exprs, includeText = TRUE)
  ids <- pd$parent[pd$token %in% c("LEFT_ASSIGN", "EQ_ASSIGN")]
  rows <- lapply(ids, function(id) {
    expr <- tryCatch(str2lang(utils::getParseText(pd, id)),
                     error = function(e) NULL)
    if (!is.call(expr) || length(expr) != 3L) return(NULL)
    lhs <- expr[[2L]]
    rhs <- expr[[3L]]
    line <- pd$line1[pd$id == id]
    fun <- enclosing_fun(pd, line)
    if (is.name(lhs)) {
      return(data.frame(file = basename(file), fun = fun, line = line,
                        sym = as.character(lhs), kind = "value",
                        value = I(list(rhs))))
    }
    is_names <- is.call(lhs) && identical(lhs[[1L]], as.name("names")) &&
      is.name(lhs[[2L]]) && is.call(rhs) && identical(rhs[[1L]], as.name("rep")) &&
      is.character(rhs[[2L]])
    if (is_names) {
      return(data.frame(file = basename(file), fun = fun, line = line,
                        sym = as.character(lhs[[2L]]), kind = "type",
                        value = I(list(rhs[[2L]]))))
    }
    NULL
  })
  do.call(rbind, rows)
}

## Replace bullets read as a variable ('<sym>') with the values
## assigned to that variable in the same function, recursively.
## Self-references ('msg <- c(msg, ...)') are dropped.
resolve_bullets <- function(bullets, file, fun, assigns, line, seen = character()) {
  rows <- lapply(seq_len(nrow(bullets)), function(j) {
    b <- bullets[j, ]
    b$line <- line
    b$via <- NA_character_
    sym <- sub("^<(.*)>$", "\\1", b$text)
    is_var <- !b$literal && !is.na(b$text) && grepl("^<[A-Za-z._][A-Za-z0-9._]*>$", b$text)
    if (!is_var) return(b)
    if (sym %in% seen) return(NULL)
    ## only assignments before the line where the variable is used
    a <- assigns[assigns$file == file & assigns$fun %in% fun &
                   assigns$sym == sym & assigns$line <= line, ]
    values <- a[a$kind == "value", ]
    if (!nrow(values)) return(b)
    types <- a[a$kind == "type", ]
    out <- lapply(seq_len(nrow(values)), function(k) {
      vb <- message_bullets(values$value[[k]])
      vb <- resolve_bullets(vb, file, fun, assigns, values$line[[k]], c(seen, sym))
      if (is.null(vb) || !nrow(vb)) return(NULL)
      if (nrow(types)) vb$type[vb$type == ""] <- types$value[[1L]]
      if (nzchar(b$type)) vb$type[vb$type == ""] <- b$type
      vb$via[is.na(vb$via)] <- sym
      vb
    })
    do.call(rbind, out)
  })
  do.call(rbind, rows)
}

## Name of the top-level function containing 'line', or NA.
enclosing_fun <- function(pd, line) {
  top <- pd[pd$parent == 0 & pd$token == "expr", ]
  i <- which(top$line1 <= line & top$line2 >= line)
  if (length(i) != 1L) return(NA_character_)
  expr <- str2lang(top$text[[i]])
  is_assign <- is.call(expr) && as.character(expr[[1L]]) %in% c("<-", "=") &&
    is.call(expr[[3L]]) && identical(expr[[3L]][[1L]], as.name("function"))
  if (is_assign) as.character(expr[[2L]]) else NA_character_
}

## The message argument of a signalling call: the argument named
## 'arg', or else the first unnamed argument.
message_arg <- function(call, arg) {
  args <- as.list(call)[-1L]
  nms <- names(args)
  if (is.null(nms)) nms <- rep("", length(args))
  if (arg != "..." && arg %in% nms) return(args[[arg]])
  unnamed <- args[nms == ""]
  if (length(unnamed)) unnamed[[1L]] else NULL
}

## Split a message into bullets. Returns a data frame with 'type',
## 'text' and 'literal' (whether the text was read from a string).
message_bullets <- function(msg) {
  if (is.null(msg)) {
    return(data.frame(type = "", text = NA_character_, literal = FALSE))
  }
  if (is.call(msg) && identical(msg[[1L]], as.name("c"))) {
    parts <- as.list(msg)[-1L]
    nms <- names(parts)
    if (is.null(nms)) nms <- rep("", length(parts))
    rows <- lapply(seq_along(parts), function(i) {
      b <- message_bullets(parts[[i]])
      if (nzchar(nms[[i]])) b$type <- nms[[i]]
      b
    })
    return(do.call(rbind, rows))
  }
  if (is.character(msg)) {
    return(data.frame(type = "", text = msg, literal = TRUE))
  }
  if (is.call(msg) && as.character(msg[[1L]])[[length(as.character(msg[[1L]]))]] == "format_inline") {
    return(message_bullets(msg[[2L]]))
  }
  if (is.call(msg) && as.character(msg[[1L]])[[1L]] %in% c("paste0", "paste")) {
    ## literal pieces kept; other pieces shown as {expression}
    pieces <- as.list(msg)[-1L]
    nms <- names(pieces)
    if (is.null(nms)) nms <- rep("", length(pieces))
    pieces <- pieces[!nms %in% c("sep", "collapse")]
    is_lit <- vapply(pieces, is.character, TRUE)
    text <- vapply(pieces, function(p)
      if (is.character(p)) p else paste0("{", deparse1(p), "}"), "")
    sep <- if (identical(msg[[1L]], as.name("paste"))) " " else ""
    return(data.frame(type = "", text = paste(text, collapse = sep),
                      literal = any(is_lit)))
  }
  data.frame(type = "", text = paste0("<", deparse1(msg), ">"), literal = FALSE)
}

## Is this a re-signal of a caught condition, e.g. stop(cnd) inside a
## handler? Base signal whose only argument is a bare symbol.
is_resignal <- function(call, called) {
  args <- as.list(call)[-1L]
  called %in% c("stop", "warning", "message") &&
    length(args) == 1L && is.name(args[[1L]])
}


## Hints ---------------------------------------------------------------------

## Does the text name an argument by a literal name ({.arg width}),
## rather than via a variable ({.arg {x_arg}}), which holds the
## caller's name for its own argument?
names_literal_arg <- function(text) {
  !is.na(text) & grepl("\\{\\.arg [A-Za-z._]", text)
}

## Heuristic: a bullet other than the header that names a function
## ({.fn ...}), an argument by its literal name, or code ({.code ...}).
## Hints are exactly the
## 'i' bullets; this flags possible misclassifications.
looks_like_hint <- function(text, type) {
  type != "" & (names_literal_arg(text) |
                  (!is.na(text) & (grepl("{.fn ", text, fixed = TRUE) |
                                     grepl("{.code ", text, fixed = TRUE))))
}

## Internal errors: conditions that should never reach users, signalled
## with `.internal = TRUE`.
is_internal <- function(call) {
  isTRUE(as.list(call)$.internal)
}


## Reach from exported functions ---------------------------------------------

## For each package function, the exported functions that can reach
## it, via an approximate call graph (codetools::findGlobals()).
exported_reach <- function() {
  ns <- asNamespace("agetime")
  nms <- ls(ns, all.names = TRUE)
  is_fn <- vapply(nms, function(nm) is.function(get(nm, envir = ns)), TRUE)
  nms <- nms[is_fn]
  calls <- lapply(nms, function(nm) {
    g <- codetools::findGlobals(get(nm, envir = ns), merge = TRUE)
    intersect(g, nms)
  })
  names(calls) <- nms
  exports <- sort(getNamespaceExports(ns))
  reach <- stats::setNames(vector("list", length(nms)), nms)
  for (ex in exports) {
    seen <- character()
    todo <- ex
    while (length(todo)) {
      nm <- todo[[1L]]
      todo <- todo[-1L]
      if (nm %in% seen) next
      seen <- c(seen, nm)
      todo <- c(todo, setdiff(calls[[nm]], seen))
    }
    for (nm in seen) reach[[nm]] <- c(reach[[nm]], ex)
  }
  reach
}


## Build ---------------------------------------------------------------------

build_inventory <- function() {
  files <- sort(list.files(PATH_R, pattern = "[.][Rr]$", full.names = TRUE))
  calls <- do.call(rbind, lapply(files, find_signal_calls))
  is_re <- mapply(is_resignal, calls$call, calls$called)
  n_resignal <- sum(is_re)
  calls <- calls[!is_re & !calls$fun %in% WRAPPERS, ]
  assigns <- do.call(rbind, lapply(files, find_assignments))
  reach <- exported_reach()
  rows <- lapply(seq_len(nrow(calls)), function(k) {
    call <- calls$call[[k]]
    spec <- SIGNALS[SIGNALS$fun == calls$called[[k]], ]
    msg <- message_arg(call, spec$arg)
    fun <- calls$fun[[k]]
    bullets <- resolve_bullets(message_bullets(msg), calls$file[[k]], fun,
                               assigns, calls$line[[k]])
    exported <- if (is.na(fun)) character() else sort(unique(reach[[fun]]))
    data.frame(
      file = calls$file[[k]],
      line = calls$line[[k]],
      fun = fun,
      text_line = bullets$line,
      via = bullets$via,
      signal = spec$signal,
      bullet = seq_len(nrow(bullets)),
      type = bullets$type,
      text = bullets$text,
      hint = bullets$type == "i",
      looks_like_hint = looks_like_hint(bullets$text, bullets$type),
      literal_arg = names_literal_arg(bullets$text),
      internal = is_internal(call),
      built_elsewhere = !bullets$literal,
      has_call = "call" %in% names(as.list(call)),
      n_exported = length(exported),
      exported = paste(exported, collapse = "; ")
    )
  })
  ans <- do.call(rbind, rows)
  ## text from a variable assigned once and signalled at several sites:
  ## list it once, at the first site
  is_dup <- !is.na(ans$via) &
    duplicated(ans[c("file", "signal", "text_line", "type", "text")])
  ans <- ans[!is_dup, ]
  ans$bullet <- stats::ave(seq_len(nrow(ans)), ans$file, ans$line,
                           FUN = seq_along)
  rownames(ans) <- NULL
  attr(ans, "n_resignal") <- n_resignal
  ans
}

summarise_inventory <- function(inv) {
  sites <- unique(inv[c("file", "line", "signal", "has_call", "internal")])
  cat("Message inventory\n")
  cat("  sites:            ", nrow(sites), "\n")
  cat("  bullets:          ", nrow(inv), "\n")
  cat("  re-signals skipped:", attr(inv, "n_resignal"), "\n")
  cat("\nSites by signal\n")
  print(table(sites$signal))
  cat("\nBullets by type\n")
  print(table(ifelse(inv$type == "", "(header)", inv$type)))
  cat("\nHints (i bullets):", sum(inv$hint), "\n")
  cat("Non-hints that look like hints:", sum(!inv$hint & inv$looks_like_hint), "\n")
  cat("Hints that do not look like hints:", sum(inv$hint & !inv$looks_like_hint), "\n")
  cat("Literal argument names:", sum(inv$literal_arg), "\n")
  cat("Internal errors (sites):", sum(sites$internal), "\n")
  cat("Built elsewhere:  ", sum(inv$built_elsewhere), "\n")
  is_signal <- sites$signal %in% c("abort", "warn", "cli_abort", "cli_warn",
                                   "rlang_abort", "rlang_warn")
  cat("Sites without call =, other than internal errors:",
      sum(is_signal & !sites$has_call & !sites$internal), "\n")
  cat("Bullets in functions no export reaches:",
      sum(inv$n_exported == 0L), "\n")
  invisible(inv)
}


## Run -----------------------------------------------------------------------

if (sys.nframe() == 0L) {
  if (!file.exists("DESCRIPTION") || !dir.exists(PATH_R))
    stop("Run from the package root.")
  pkgload::load_all(".", quiet = TRUE, export_all = FALSE)
  inv <- build_inventory()
  utils::write.csv(inv, PATH_OUT, row.names = FALSE, na = "")
  summarise_inventory(inv)
  cat("\nWrote", PATH_OUT, "\n")
}
