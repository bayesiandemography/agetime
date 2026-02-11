
check_breaks <- function(breaks) {
  check_incr_nonneg_integers(x = breaks,
                             nm_x = "breaks",
                             min_length = 2L)
}
  


check_incr_nonneg_integers <- function(x, nm_x, min_length) {
  eps <- 1e-8
  if (length(x) < min_length)
    cli::cli_abort(c("{.arg {nm_x}} has length {.val {length(x)}}.",
                     i = "{.arg {nm_x}} must have length >= {min_length}."))
  if (!is.numeric(x))
    cli::cli_abort(c("{.arg {nm_x}} is non-numeric.",
                     i = "{.arg {nm_x}} has class {.cls {class(x)}}."))
  n_na <- sum(is.na(x))
  if (n_na > 0L)
    cli::cli_abort("{.arg {nm_x}} has {cli::qty(n_na)} NA{?s}.")
  is_integerish <- abs(x - round(x)) < eps
  i_not_integerish <- match(FALSE, is_integerish, nomatch = 0L)
  if (i_not_integerish > 0L)
    cli::cli_abort(c("{.arg {nm_x}} has non-integer value.",
                     "Value: {.val {x[[i_not_integerish]]}}."))
  n_neg <- sum(x < 0L)
  if (n_neg > 0L)
    cli::cli_abort("{.arg {nm_x}} has negative {cli::qty(n_na)} value{?s}.")
  is_non_incr <- diff(x) <= 0L
  i_non_incr <- match(TRUE, is_non_incr, nomatch = 0L)
  if (i_non_incr > 0L) {
    x_non <- x[c(i_non_incr, i_non_incr + 1L)]
    cli::cli_abort(c("{.arg {nm_x}} non-increasing.",
                     i = "Non-increasing values: {.val {x_non}}."))
  }
  invisible(TRUE)
}
    


check_m_contains <- function(m_contains, type) {
  int_name <- switch(type,
                     age = "age group",
                     cohort = "cohort",
                     period = "period")
  labels_old <- colnames(m_contains)
  colsum <- colSums(m_contains)
  is_not_fit <- colsum != 1L
  if (any(is_not_fit)) {
    labels_not_fit <- labels_old[is_not_fit]
    cli::cli_abort(paste("Old label{?s} {.val {labels_not_fit}}",
                         "does not map on to new label set."))
  }
  invisible(TRUE)
}
  

  


check_flag <- function(x, nm_x) {
  if (length(x) != 1L)
    cli::cli_abort(c("{.arg {nm_x}} does not have length 1.",
                     i = "{.arg {nm_x}} has length {.val {length(x)}}."))
  if (is.na(x))
    cli::cli_abort("{.arg {nm_x}} is {.val {NA}}.")
  if (!(x %in% c(TRUE, FALSE, 1L, 0L)))
    cli::cli_abort(c("{.arg {nm_x}} is not {.val {TRUE}} or {.val {FALSE}}.",
                     "{.arg {nm_x}} equals {.val {x}}."))
  invisible(TRUE)
}



## ## NO_TESTS
## #' Check that Argument is a Vector or Factor
## #'
## #' @param x Argument
## #' @param nm_x Name of argument
## #'
## #' @returns TRUE, invisibly
## #'
## #' @noRd
## check_vector_or_factor <- function(x, nm_x) {
##     if (!is.vector(x) && !is.factor(x))
##         cli::cli_abort(c("{.arg {nm_x}} is not a vector or factor.",
##                          i = "{.arg {nm_x}} has class {.cls {class(x)}}."))
##     invisible(TRUE)
## }


## #' Check that New Type Less Detailed than Old Type

## check_type_less_detailed_age <- function(type_new, type_old) {
##     is_more_detailed <- ((type_new == "single" && (type_old == "five"))
##         || (type_new == "single" && (type_old == "ten"))
##         || (type_new == "single" && (type_old == "lifetable"))
##         || ((type_new == "five") && (type_old == "ten"))
##         || ((type_new == "lifetable") && (type_old == "five"))
##         || ((type_new == "lifetable") && (type_old == "ten")))
##     if (is_more_detailed)
##         cli::cli_abort(c("New type is more detailed than old type.",
##                          i = "New type: {.val {type_new}}.",
##                          i = "Old type: {.val {type_old}}."))
##     invisible(TRUE)
## }

    
check_is_integerish <- function(x) {
  tol <- 1e-8
  x <- as.double(x)
  is_ok <- is.na(x) | is.infinite(x) | (abs(x - round(x)) <= tol)
  i_not_ok <- match(FALSE, is_ok, nomatch = 0L)
  if (i_not_ok > 0L) {
    x_not_ok <- x[[i_not_ok]]
    cli::cli_abort("Internal error: value {.val {x_not_ok}} is not integerish.")
  }
  invisible(TRUE)
}





check_mapping_constraints <- function(m_mapping,
                                      x_complete,
                                      y_complete,
                                      x_unique,
                                      y_unique,
                                      check) {
  rowsum <- rowSums(m_mapping, na.rm = TRUE)
  colsum <- colSums(m_mapping, na.rm = TRUE)
  is_x_complete <- all(rowsum > 0L)
  is_y_complete <- all(colsum > 0L)
  is_x_unique <- all(rowsum %in% c(0L, 1L))
  is_y_unique <- all(colsum %in% c(0L, 1L))
  for (nm in c("x_complete", "y_complete", "x_unique", "y_unique")) {
    val_constr <- get(nm)
    if (!is.null(val_constr)) {
      if (!(val_constr %in% c(TRUE, FALSE)))
        cli::cli_abort(c("{.arg {nm}} is {.val {val_constr}}.",
                         i = paste("{.arg {nm}} must be {.val {NULL}},",
                                   "{.val {TRUE}}, or {.val {FALSE}}.")))
      val_check <- get(paste0("is_", nm))
      if (!identical(val_constr, val_check)) {
        msg <- "Constraint {.code {nm} = {val_constr}} not satisfied."
        if (check == "error")
          cli::cli_abort(msg)
        else
          cli::cli_warn(msg)
      }
    }
  }
  invisible(TRUE)
}

check_x_lt_y <- function(x, y, nm_x, nm_y) {
  if (x >= y)
    cli::cli_abort(c("{.arg {nm_x}} must be less than {.arg {nm_y}}.",
                     i = "{.arg {nm_x}}: {.val {x}}.",
                     i = "{.arg {nm_y}}: {.val {y}}."))
  invisible(TRUE)
}
