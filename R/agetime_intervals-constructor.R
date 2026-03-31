
## constructor ----------------------------------------------------------------

intervals <- function(labels,
                      label_type,
                      parse_one,
                      parse_multi,
                      parse_fail) {
  label_type <- match.arg(label_type, choices = c("age", "cohort", "period"))
  if (label_type == "age") {
    labels_normalizers <- make_labels_normalizers_age()
    label_parsers <- make_label_parsers_age()
  }
  else if (label_type == "cohort") {
    labels_normalizers <- make_labels_normalizers_cohort()
    label_parsers <- make_label_parsers_cohort(parse_one = parse_one,
                                               parse_multi = parse_multi)
  }
  else {
    labels_normalizers <- make_labels_normalizers_period()
    label_parsers <- make_label_parsers_period(parse_one = parse_one,
                                               parse_multi = parse_multi)
  }
  ans <- intervals_inner(labels = labels,
                         labels_normalizers = labels_normalizers,
                         label_parsers = label_parsers,
                         label_type = label_type,
                         parse_fail = parse_fail)
  ans
}
  

intervals_inner <- function(labels,
                            labels_normalizers,
                            label_parsers,
                            label_type,
                            parse_fail) {
  if (is.factor(labels))
    labels_unique <- levels(labels)
  else
    labels_unique <- unique(labels)
  labels_unique_norm <- normalize_labels(labels = labels_unique,
                                         labels_normalizers = labels_normalizers)
  labels_unique_norm_unique <- unique(labels_unique_norm)
  i_x_to_xu <- match(labels, labels_unique)
  i_xun_to_xunu <- match(labels_unique_norm, labels_unique_norm_unique)
  i <- i_xun_to_xunu[i_x_to_xu]
  m <- vapply(labels_unique_norm_unique,
              FUN = parse_label,
              FUN.VALUE = c(NA_real_, NA_real_),
              label_parsers = label_parsers,
              parse_fail = parse_fail)
  m <- t(m)
  ans <- list(labels_unique = labels_unique,
              labels_unique_norm_unique = labels_unique_norm_unique,
              m = m,
              i = i,
              i_x_to_xu = i_x_to_xu,
              i_xun_to_xunu = i_xun_to_xunu)
  class <- "agetime_intervals"
  class <- c(paste(class, label_type, sep = "_"), class)
  class(ans) <- class
  ans
}

## validator ------------------------------------------------------------------

#' Validate 'agetime_intervals' Object
#'
#' @param object Object of class 'agetime_intervals'
#'
#' @returns TRUE
#'
#' @noRd
validate_agetime_interval <- function(object, label_type) {
  labels_unique <- get_labels_unique(object)
  m <- get_m(object)
  i <- get_i(object)
  i_x_to_xu <- get_i_x_to_xu(object)
  i_xun_to_xunu <- get_i_xun_to_xunu(object)
  check_labels_unique(labels_unique)
  check_m(m)
  check_index(index = i,
              nm_index = "i")
  check_index(index = i_x_to_xu,
              nm_index = "i_x_to_xu")
  check_index(index = i_xun_to_xunu,
              nm_index = "i_xun_to_xunu")
  check_i_and_m(i = i,
                m = m)
  check_i_x_to_xu_and_labels_unique(i_x_to_xu = i_x_to_xu,
                                    labels_unique = labels_unique)
  if (label_type == "age")
    check_m_age(m)
  else if (label_type == "cohort")
    check_m_cohort(m)
  else
    check_m_period(m)
  invisible(TRUE)
}


check_i_x_to_xu_and_labels_unique <- function(i_x_to_xu, labels_unique) {
  if (any(i_x_to_xu > length(labels_unique)))
    cli::cli_abort(paste("Internal error: {.arg i_x_to_xu} has value(s)",
                         "greater than length(labels_unique)."))
  invisible(TRUE)
}

check_i_xun_to_xunu_and_m <- function(i_xun_to_xunu, m) {
  if (any(i_xun_to_xunu > nrow(m)))
    cli::cli_abort(paste("Internal error: {.arg i_xun_to_xunu} has",
                         "value(s) greater than nrow(m)."))
  invisible(TRUE)
}
  
check_i_and_m <- function(i, m) {
  if (any(i > nrow(m)))
    cli::cli_abort("Internal error: {.arg i} has value(s) greater than nrow(m).")
  invisible(TRUE)
}

check_labels_unique <- function(labels_unique) {
  if (!is.character(labels_unique))
    cli::cli_abort("Internal error: {.arg labels_unique} is not a character vector.")
  if (anyDuplicated(labels_unique))
    cli::cli_abort("Internal error: {.arg labels_unique} has duplicates.")
  invisible(TRUE)
}

check_index <- function(index, nm_index) {
  if (!is.integer(index) || !is.null(dim(index)))
    cli::cli_abort("Internal error: {.arg {nm_index}} is not an integer vector.")
  if (anyNA(index))
    cli::cli_abort("Internal error: {.arg {nm_index}} has NA(s).")
  if (any(index < 1L))
    cli::cli_abort("Internal error: {.arg {nm_index}} has element(s) less than 1.")
  invisible(TRUE)
}


check_m <- function(m) {
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
  m_non_na <- m[!is.na(lower), , drop = FALSE]
  if (anyDuplicated(m_non_na, MARGIN = 1L))
    cli::cli_abort("Internal error: 'm' has duplicated rows.")
  invisible(TRUE)
}

check_m_age <- function(m) {
  lower <- m[, 1L]
  if (any(!is.na(lower) & !(lower >= 0)))
    cli::cli_abort("Internal error: 'lower' has negative value(s).")
  invisible(TRUE)
}

check_m_cohort <- function(m) {
  upper <- m[, 2L]
  if (any(is.infinite(upper)))
    cli::cli_abort("Internal error: 'upper' has Inf.")
  invisible(TRUE)
}

check_m_period <- function(m) {
  lower <- m[, 1L]
  upper <- m[, 2L]
  if (any(is.infinite(lower)))
    cli::cli_abort("Internal error: 'lower' has -Inf.")
  if (any(is.infinite(upper)))
    cli::cli_abort("Internal error: 'upper' has Inf.")
  invisible(TRUE)
}
