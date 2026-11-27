## Message inventory for an R package.
##
## Source: bayesiandemography/bdtools, dev/messages/inventory.R
## last-updated: 2026-11-27 (S3 methods as entry points)
## Copied into each package's dev/messages/. Do not edit the copy:
## change the source, then copy it again. Package-specific settings go
## in dev/messages/config.R (see "Settings").
##
## Run from the package root:
##   Rscript dev/messages/inventory.R
##
## Writes dev/messages/inventory.csv (one row per message bullet), and
## prints a summary and any breaches of the conventions (global
## CLAUDE.md, "Message wording"; listed in dev/messages/README.md).
## tests/testthat/test-messages.R runs the same checks.
##
## Based on agetime's dev/messages/inventory.R (2026-11-25).


## Settings ------------------------------------------------------------------

## Functions that signal conditions. 'arg' is the argument holding the
## message.
SIGNALS <- data.frame(
  fun = c("abort_msg", "warn_msg", "inform_msg",
          "cli_abort", "cli_warn", "cli_inform", "abort", "warn", "inform",
          "stop", "warning", "message"),
  signal = c("abort", "warn", "inform",
             "cli_abort", "cli_warn", "cli_inform", "rlang_abort", "rlang_warn",
             "rlang_inform", "base_stop", "base_warning", "base_message"),
  arg = c("message", "message", "message",
          "message", "message", "message", "message", "message", "message",
          "...", "...", "...")
)

## The signalling wrappers themselves (standalone-messages.R), whose cli
## calls are not messages.
WRAPPERS <- c("abort_msg", "warn_msg", "inform_msg")

## Files not inventoried: standalone copies, whose messages are checked
## in bdtools itself.
SKIP_FILES <- "^import-standalone-"

PATH_R <- "R"
PATH_OUT <- file.path("dev", "messages", "inventory.csv")
PATH_CONFIG <- file.path("dev", "messages", "config.R")

## Package-specific settings. dev/messages/config.R, if present, is
## sourced here, and may:
## - add rows to SIGNALS, for functions that store message text to be
##   signalled later (signal "stored"; e.g. agetime's x_label_fail(),
##   with arg "msg");
## - change SKIP_FILES.
if (file.exists(PATH_CONFIG))
  sys.source(PATH_CONFIG, envir = environment())

## Name of the package, from DESCRIPTION.
package_name <- function() {
  unname(read.dcf("DESCRIPTION", fields = "Package")[1L, 1L])
}


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
## assigned to that variable in the same function, recursively. Only
## assignments before the line where the variable is used count, and
## assignments with no text ('problem <- NULL') are skipped.
##
## An assignment that does not refer to the variable starts a version of
## the message; when there are several ('if (...) x <- "a" else
## x <- "b"'), 'alternative' numbers them. An assignment that refers to
## the variable ('msg <- c(msg, x = ...)') adds bullets to the version
## before it. Approximate: it does not follow control flow, so appends
## in 'if'/'else' branches are listed one after the other.
resolve_bullets <- function(bullets, file, fun, assigns, line, seen = character()) {
  rows <- lapply(seq_len(nrow(bullets)), function(j) {
    b <- bullets[j, ]
    b$line <- line
    b$via <- NA_character_
    b$alternative <- NA_integer_
    sym <- sub("^<(.*)>$", "\\1", b$text)
    is_var <- !b$literal && !is.na(b$text) && grepl("^<[A-Za-z._][A-Za-z0-9._]*>$", b$text)
    if (!is_var) return(b)
    if (sym %in% seen) return(NULL)
    a <- assigns[assigns$file == file & assigns$fun %in% fun &
                   assigns$sym == sym & assigns$line <= line, ]
    values <- a[a$kind == "value", ]
    values <- values[!vapply(values$value, is_empty_value, TRUE), ]
    values <- values[order(values$line), ]
    if (!nrow(values)) return(b)
    types <- a[a$kind == "type", ]
    is_append <- vapply(values$value, function(v) sym %in% all.names(v), TRUE)
    ## each version: a starting assignment and the appends that follow it
    version <- cumsum(!is_append)
    if (!any(!is_append)) version[] <- 1L
    n_version <- max(version)
    out <- lapply(seq_len(nrow(values)), function(k) {
      vb <- message_bullets(values$value[[k]])
      vb <- resolve_bullets(vb, file, fun, assigns, values$line[[k]], c(seen, sym))
      if (is.null(vb) || !nrow(vb)) return(NULL)
      if (nrow(types)) vb$type[vb$type == ""] <- types$value[[1L]]
      if (nzchar(b$type)) vb$type[vb$type == ""] <- b$type
      vb$via[is.na(vb$via)] <- sym
      v <- version[[k]]
      if (n_version > 1L) vb$alternative[is.na(vb$alternative)] <- v
      vb
    })
    do.call(rbind, out)
  })
  do.call(rbind, rows)
}

## An assigned value with no message text: NULL, character(), character(0).
is_empty_value <- function(value) {
  is.null(value) ||
    (is.call(value) && identical(value[[1L]], as.name("character")) &&
       (length(value) == 1L || identical(value[[2L]], 0) ||
          identical(value[[2L]], 0L)))
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

## For each package function, the entry points that can reach it, via
## an approximate call graph (codetools::findGlobals()). Entry points
## are exported functions and registered S3 methods (which users reach
## through generics).
exported_reach <- function() {
  ns <- asNamespace(package_name())
  nms <- ls(ns, all.names = TRUE)
  is_fn <- vapply(nms, function(nm) is.function(get(nm, envir = ns)), TRUE)
  nms <- nms[is_fn]
  calls <- lapply(nms, function(nm) {
    g <- codetools::findGlobals(get(nm, envir = ns), merge = TRUE)
    intersect(g, nms)
  })
  names(calls) <- nms
  methods <- getNamespaceInfo(ns, "S3methods")[, 3L]
  exports <- sort(union(getNamespaceExports(ns), intersect(methods, nms)))
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
  files <- files[!grepl(SKIP_FILES, basename(files))]
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
      bullet = NA_integer_,
      alternative = bullets$alternative,
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
  ans <- number_bullets(ans)
  rownames(ans) <- NULL
  attr(ans, "n_resignal") <- n_resignal
  ans
}

## Number alternatives within each message (none when the message has
## only one version), and bullets within each alternative. Bullets shared
## by all alternatives take their numbers from the first.
number_bullets <- function(inv) {
  site <- paste(inv$file, inv$line)
  inv$bullet <- NA_integer_
  for (idx in split(seq_len(nrow(inv)), factor(site, levels = unique(site)))) {
    alt <- inv$alternative[idx]
    alts <- unique(alt[!is.na(alt)])
    if (length(alts) <= 1L) {
      inv$alternative[idx] <- NA_integer_
      inv$bullet[idx] <- seq_along(idx)
      next
    }
    alt <- match(alt, alts)
    inv$alternative[idx] <- alt
    bullet <- rep(NA_integer_, length(idx))
    for (a in seq_along(alts)) {
      sel <- which(is.na(alt) | alt == a)
      num <- seq_along(sel)
      own <- !is.na(alt[sel])
      bullet[sel[own]] <- num[own]
      fill <- !own & is.na(bullet[sel])
      bullet[sel[fill]] <- num[fill]
    }
    inv$bullet[idx] <- bullet
  }
  inv
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
  cat("Bullets in functions no entry point reaches:",
      sum(inv$n_exported == 0L), "\n")
  invisible(inv)
}


## Checks --------------------------------------------------------------------

## Conventions that can be tested mechanically (dev/messages/README.md).
## Returns one row per violation (empty when all pass).

## Imperative openings of advice: hints and advice should be questions.
ADVICE_START <- paste0("^(Use|Supply|Set|Add|Remove|Rename|Select|Give|",
                       "Write|Recode|Or|To|If) ")

check_inventory <- function(inv) {
  text <- ifelse(is.na(inv$text), "", inv$text)
  readable <- !inv$built_elsewhere
  is_header <- inv$type == ""
  ## a bullet that is a single interpolation, such as "{group}", has no
  ## wording of its own
  is_template_only <- grepl("^[{].*[}]$", text)
  is_signal_site <- inv$bullet == 1L
  rules <- list(
    hint_not_interface = inv$type == "i" & readable & !inv$looks_like_hint,
    interface_not_hint = inv$type == "*" & inv$looks_like_hint,
    must_header = is_header & grepl("\\bmust\\b", text),
    header_semicolon = is_header & grepl(";", text, fixed = TRUE),
    advice_not_question = inv$type %in% c("i", "*") &
      grepl(ADVICE_START, text) & !grepl("[?]$", text),
    wording = grepl("Don't know|Cannot|Unable to|Internal error", text),
    bullet_ending = readable & !is_template_only & !grepl("[.?]$", text),
    base_signal = is_signal_site & startsWith(inv$signal, "base_"),
    direct_signal = is_signal_site &
      grepl("^(cli|rlang)_", inv$signal),
    no_call = is_signal_site & inv$signal %in% c("abort", "warn") &
      !inv$has_call & !inv$internal
  )
  ans <- lapply(names(rules), function(nm) {
    i <- which(rules[[nm]])
    data.frame(check = rep(nm, length(i)),
               inv[i, c("file", "line", "text_line", "type", "text")])
  })
  ans <- do.call(rbind, ans)
  rownames(ans) <- NULL
  ans
}

print_checks <- function(fails) {
  cat("\nChecks:", if (nrow(fails)) paste(nrow(fails), "violations") else "all pass",
      "\n")
  if (nrow(fails)) {
    out <- sprintf("  [%s] %s:%d (%s) %s", fails$check, fails$file,
                   fails$text_line,
                   ifelse(fails$type == "", "header", fails$type), fails$text)
    writeLines(out)
  }
  invisible(fails)
}


## Run -----------------------------------------------------------------------

if (sys.nframe() == 0L) {
  if (!file.exists("DESCRIPTION") || !dir.exists(PATH_R))
    stop("Run from the package root.")
  pkgload::load_all(".", quiet = TRUE, export_all = FALSE)
  inv <- build_inventory()
  utils::write.csv(inv, PATH_OUT, row.names = FALSE, na = "")
  summarise_inventory(inv)
  print_checks(check_inventory(inv))
  cat("\nWrote", PATH_OUT, "\n")
}
