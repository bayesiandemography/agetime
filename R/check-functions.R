        


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
      val_check <- get(paste("is_", nm))
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
