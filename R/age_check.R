
#' Check or Make Assertions About Age Groups
#'
#' @inheritParams age_lower
#' @param no_overlap No age groups overlap
#' @param no_gap The age groups span the entire
#' range from the lower limit of the youngest age
#' group to the upper limit of the oldest age group
#' @param no_total No "Total" age group
#' @param no_na No NA age group
#' @param include_zero One or more age groups
#' have a lower limit of zero.
#' @param include_open One or more age groups
#' has no upper limit. 
#'
#' @returns
#' - `age_check()` returns a list with
#'   components `ok` (a logical flag)
#'   and `details` (a data frame). `ok` is `TRUE`
#'   if all assertions are satisfied, and `FALSE`
#'   otherwise.
#' - `age_assert()` returns `x` invisibly,
#'   or throws an error.
#'
#' @export
age_check <- function(x,
                      no_overlap = NA,
                      no_gap = NA,
                      no_total = NA,
                      no_na = NA,
                      include_zero = NA,
                      include_open = NA,
                      invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  invalid <- match.arg(invalid)
  intervals <- intervals(labels = x,
                         type = "age",
                         invalid = invalid)
  val_no_overlap <- age_check_no_overlap(intervals = intervals,
                                         asserted = no_overlap)
  val_no_gap <- age_check_no_gap(intervals = intervals,
                                 asserted = no_gap)
  val_no_total <- age_check_no_total(intervals = intervals,
                                     asserted = no_total)
  val_no_na <- age_check_no_na(intervals = intervals,
                               asserted = no_na)
  val_include_zero <- age_check_include_zero(intervals = intervals,
                                             asserted = include_zero)
  val_include_open <- age_check_include_open(intervals = intervals,
                                             asserted = include_open)
  details <- vctrs::vec_rbind(val_no_overlap,
                              val_no_gap,
                              val_no_total,
                              val_no_na,
                              val_include_zero,
                              val_include_open)
  ok_individual <- make_ok_individual(details)
  ok <- all(ok_individual)
  list(ok = ok,
       details = details)
}


make_ok_individual <- function(details) {
  asserted <- details$asserted
  observed <- details$observed
  is.na(asserted) | (asserted == observed)
}

## TODO - expand this
throw_assert_error <- function(val) {
  if (!val$ok)
    cli::cli_abort("Check failed")
}

#' @rdname age_check
#' @export
age_assert <- function(x,
                       no_overlap = NA,
                       no_gap = NA,
                       no_total = NA,
                       no_na = NA,
                       include_zero = NA,
                       include_open = NA,
                       invalid = c("error", "warn", "silent")) {
  invalid <- match.arg(invalid)
  val <- age_check(x = x,
                   no_overlap = no_overlap,
                   no_gap = no_gap,
                   no_total = no_total,
                   no_na = no_na,
                   include_zero = include_zero,
                   include_open = include_open,
                   invalid = invalid)
  throw_assert_error(val)
  invisible(x)
}


## TODO - HANDLE ZERO-ROW CASES

age_check_no_overlap <- function(intervals, asserted) {
  m <- get_m(intervals)
  is_total <- get_is_total(intervals)
  m_overlap <- does_m1_overlap_m2(m1 = m, m2 = m)
  m_overlap[is_total, ] <- TRUE
  m_overlap[, is_total] <- TRUE
  m_overlap[row(m_overlap) >= col(m_overlap)] <- FALSE
  observed <- !any(m_overlap, na.rm = TRUE)
  if (is.na(asserted))
    comment <- "No test done"
  else if (asserted == observed)
    comment <- "Passed"
  else if (asserted && !observed) {
    labels_unique <- get_labels_unique(intervals)
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    i_overlap <- match(TRUE, m_overlap)
    i1 <- row(m_overlap)[[i_overlap]]
    i2 <- col(m_overlap)[[i_overlap]]
    lab1 <- labels_unique[[match(i1, i_xun_to_xunu)]]
    lab2 <- labels_unique[[match(i2, i_xun_to_xunu)]]
    comment <- sprintf("Example of overlap: '%s' and '%s'",
                       lab1, lab2)
  }
  else ## !asserted && observed
    comment <- "No intervals overlap"
  tibble::tibble_row(check = "no_overlap",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}
 
age_check_no_gap <- function(intervals, asserted) {
  is_total <- get_is_total(intervals)
  if (any(is_total)) {
    observed <- TRUE
  }
  else {
    m <- get_m(intervals)
    ord <- order(m[, 1L], m[, 2L])
    m <- m[ord, , drop = FALSE]
    lower <- m[, 1L]
    upper <- m[, 2L]
    uppermax <- cummax(upper)
    n <- length(upper)
    is_gap <- !is.na(lower[-1L]) & (lower[-1L] > uppermax[-n])
    observed <- !any(is_gap)
  }
  if (is.na(asserted))
    comment <- "No test done"
  else if (asserted == observed)
    comment <- "Passed"
  else if (asserted && !observed) {
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    labels_unique <- get_labels_unique(intervals)
    i_gap <- match(TRUE, is_gap)
    i_xunu <- ord[[i_gap + 1L]]
    i_xu <- match(i_xunu, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example: gap below '%s'", lab)
  }
  else ## !asserted && observed
    comment <- "No gaps between intervals"
  tibble::tibble_row(check = "no_gap",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}


age_check_no_total <- function(intervals, asserted) {
  is_total <- get_is_total(intervals)
  observed <- !any(is_total)
  if (is.na(asserted))
    comment <- "No test done"
  else if (asserted == observed)
    comment <- "Passed"
  else if (asserted && !observed) {
    labels_unique <- get_labels_unique(intervals)
    i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
    i_total <- match(TRUE, is_total)
    i_xu <- match(i_total, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example: '%s'", lab)
  }
  else ## !asserted && observed
    comment <- "No 'Total' age groups"
  tibble::tibble_row(check = "no_total",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}


age_check_no_na <- function(intervals, asserted) {
  is_na <- get_is_na(intervals)
  observed <- !any(is_na)
  if (is.na(asserted))
    comment <- "No test done"
  else if (asserted == observed)
    comment <- "Passed"
  else if (asserted && !observed) {
    comment <- "Labels include NA."
  }
  else ## !asserted && observed
    comment <- "No NA labels"
  tibble::tibble_row(check = "no_na",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}


age_check_include_zero <- function(intervals, asserted) {
  m <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  lower <- m[, 1L]
  observed <- any(lower == 0, na.rm = TRUE)
  if (is.na(asserted))
    comment <- "No test done"
  else if (asserted == observed)
    comment <- "Passed"
  else if (asserted && !observed) {
    i_min <- which.min(lower)
    i_xu <- match(i_min, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Lowest interval: '%s'", lab)
  }
  else { ## !asserted && observed
    i_zero <- match(0, lower)
    i_xu <- match(i_zero, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example: '%s'", lab)
  }
  tibble::tibble_row(check = "include_zero",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}

age_check_include_open <- function(intervals, asserted) {
  m <- get_m(intervals)
  labels_unique <- get_labels_unique(intervals)
  i_xun_to_xunu <- get_i_xun_to_xunu(intervals)
  upper <- m[, 2L]
  observed <- any(is.infinite(upper))
  if (is.na(asserted))
    comment <- "No test done"
  else if (asserted == observed)
    comment <- "Passed"
  else if (asserted && !observed) {
    i_max <- which.max(upper)
    i_xu <- match(i_max, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Highest interval: '%s'", lab)
  }
  else { ## !asserted && observed
    i_open <- match(TRUE, is.infinite(upper))
    i_xu <- match(i_open, i_xun_to_xunu)
    lab <- labels_unique[[i_xu]]
    comment <- sprintf("Example: '%s'", lab)
  }
  tibble::tibble_row(check = "include_open",
                     asserted = asserted,
                     observed = observed,
                     comment = comment)
}  




