
## constructor functions ------------------------------------------------------

#' Create Object from Subclass "agetime_interval_age"
#'
#' @param m Matrix with 2 columns
#' @param i Integer vector
#' @param validate Whether to validate object
#'
#' @returns An object of class "agetime_interval_age"
#'
#' @noRd
new_agetime_interval_age <- function(m, i, validate = TRUE) {
  if (validate)
    validate_agetime_interval_age(m = m, i = i)
  m <- unname(m)
  ans <- list(m = m, i = i)
  class(ans) <- c("agetime_interval_age", "agetime_interval")
  ans
}

#' Create Object from Subclass "agetime_interval_cohort"
#'
#' @param Matrix with 2 columns
#' @param i Integer vector
#' @param validate Whether to validate object
#'
#' @returns An object of class "agetime_interval_cohort"
#'
#' @noRd
new_agetime_interval_cohort <- function(m, i, validate = TRUE) {
  if (validate)
    validate_agetime_interval_cohort(m = m, i = i)
  m <- unname(m)
  ans <- list(m = m, i = i)
  class(ans) <- c("agetime_interval_cohort", "agetime_interval")
  ans
  m
}

#' Create Object from Subclass "agetime_interval_period"
#'
#' @param Matrix with 2 columns
#' @param i Integer vector
#' @param validate Whether to validate object
#'
#' @returns An object of class "agetime_interval_period"
#'
#' @noRd
new_agetime_interval_period <- function(m, i, validate = TRUE) {
  if (validate)
    validate_agetime_interval_period(m = m, i = i)
  m <- unname(m)
  ans <- list(m = m, i = i)
  class(ans) <- c("agetime_interval_period", "agetime_interval")
  ans
}


## validation functions -------------------------------------------------------

#' Validate Object from Virtual Superclass 'agetime_interval'
#'
#' Internal validator for `agetime_interval` objects.
#'
#' @param m A 2-column numeric matrix with columns "lower", "upper".
#' Values must be "integerish" but stored as double.
#' +/-Inf are allowed at superclass level.
#' NA is allowed only in paired rows:
#' lower is NA iff upper is NA. Rows must be unique.
#' @param i An integer vector indexing rows of 'm'.
#'
#' @param x Object from class
#'
#' @returns TRUE
#'
#' @noRd
validate_agetime_interval <- function(m, i) {
  ## check m
  if (!is.matrix(m) || ncol(m) != 2L)
    cli::cli_abort("Internal error: {.arg m} not a 2-column matrix.")
  if (!is.numeric(m))
    cli::cli_abort("Internal error: {.arg m} not numeric.")
  lower <- m[, 1L]
  upper <- m[, 2L]
  is_na_lower <- is.na(lower)
  is_na_upper <- is.na(upper)
  if (any(xor(is_na_lower, is_na_upper)))
    cli::cli_abort("Internal error: 'lower' can be NA iff 'upper' is NA.")
  check_is_integerish(m)
  if (any(!is.na(lower) & !(upper > lower)))
    cli::cli_abort("Internal error: 'upper' <= 'lower'.")
  if (anyDuplicated(m, MARGIN = 1L))
    cli::cli_abort("Internal error: 'm' has duplicated rows.")
  ## check i
  if (!is.integer(i) || !is.null(dim(i)))
    cli::cli_abort("Internal error: {.arg i} is not an integer vector.")
  if (anyNA(i))
    cli::cli_abort("Internal error: {.arg i} has NA(s).")
  if (any(i < 1L))
    cli::cli_abort("Internal error: {.arg i} has element(s) less than 1.")
  ## check m and i
  if (any(i > nrow(m)))
    cli::cli_abort("Internal error: {.arg i} has value(s) greater than nrow(m).")
  ## return
  invisible(TRUE)
}


#' Validate Object from Subclass 'agetime_interval_age'
#'
#' @param m A numeric matrix with two columns
#' @param i An integer vector indexing rows of 'm'
#'
#' @returns An object of class "agetime_interval_age"
#'
#' @noRd
validate_agetime_interval_age <- function(m, i) {
  validate_agetime_interval(m = m, i = i)
  lower <- m[, 1L]
  if (any(!is.na(lower) & !(lower >= 0)))
    cli::cli_abort("Internal error: 'lower' has negative value(s).")
  invisible(TRUE)
}

#' Validate Object from Subclass 'agetime_interval_cohort'
#'
#' @param m A numeric matrix with two columns
#' @param i An integer vector indexing rows of 'm'
#'
#' @returns An object of class "agetime_interval_cohort"
#'
#' @noRd
validate_agetime_interval_cohort <- function(m, i) {
  validate_agetime_interval(m = m, i = i)
  upper <- m[, 2L]
  if (any(is.infinite(upper)))
    cli::cli_abort("Internal error: 'upper' has Inf.")
  invisible(TRUE)
}

#' Validate Object from Subclass 'agetime_interval_period'
#'
#' @param m A numeric matrix with two columns
#' @param i An integer vector indexing rows of 'm'
#'
#' @returns An object of class "agetime_interval_period"
#'
#' @noRd
validate_agetime_interval_period <- function(m, i) {
  validate_agetime_interval(m = m, i = i)
  lower <- m[, 1L]
  upper <- m[, 2L]
  if (any(is.infinite(lower)))
    cli::cli_abort("Internal error: 'lower' has -Inf.")
  if (any(is.infinite(upper)))
    cli::cli_abort("Internal error: 'upper' has Inf.")
  invisible(TRUE)
}
