
#' Check or Make Assertions About Periods
#'
#' Collect information on period labels (`period_check()`),
#' or throw an error if period labels do not
#' conform to expectations (`period_assert`).
#'
#' @inheritParams period_lower
#' @param no_overlap No periods overlap
#' @param no_gap The periods span the entire
#' range from the lower limit of the earliest period
#' to the upper limit of the latest period
#' @param no_total No "Total" label
#' @param no_na No NA label
#'
#' @return A list (`period_check()`) or `x` invisibly (`period_assert()`).
#'
#' @seealso
#' [age_check()] Age equivalent of `period_check()`
#' [cohort_check()] Cohort equivalent of `period_check()`
#'
#' @examples
#' lab <- period_labels_five(lower_first = 2020,
#'                           lower_last = 2030)
#' lab
#'
#' ## get info on everything
#' period_check(x = lab,
#'              no_overlap = TRUE,
#'              no_gap = TRUE,
#'              no_total = TRUE,
#'              no_na = TRUE)
#'
#' ## throw error if gaps
#' period_assert(x = lab, no_gap = TRUE)
#'
#' lab_gap <- lab[c(1, 3)]
#' ## throw error if no gaps
#' period_assert(lab_gap, no_gap = FALSE)
#' @export

# When length(x) == 0, checks on overlap, gaps, totals, and NA are vacuously
# satisfied (observed = TRUE).
period_check <- function(x,
                         no_overlap = NA,
                         no_gap = NA,
                         no_total = NA,
                         no_na = NA,
                         x_one = c("lower", "upper"),
                         x_multi = c("include", "exclude"),
                         x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_check(x = x,
              label_type = "period",
              x_one = x_one,
              x_multi = x_multi,
              x_fail = x_fail,
              no_overlap = no_overlap,
              no_gap = no_gap,
              no_total = no_total,
              no_na = no_na,
              include_zero = NA,
              include_open = NA,
              valid_life = NA)
}

#' @rdname period_check
#' @export
period_assert <- function(x,
                          no_overlap = NA,
                          no_gap = NA,
                          no_total = NA,
                          no_na = NA,
                          x_one = c("lower", "upper"),
                          x_multi = c("include", "exclude"),
                          x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_assert(x = x,
               label_type = "period",
               x_one = x_one,
               x_multi = x_multi,
               x_fail = x_fail,
               no_overlap = no_overlap,
               no_gap = no_gap,
               no_total = no_total,
               no_na = no_na,
               include_zero = NA,
               include_open = NA,
               valid_life = NA)
}

