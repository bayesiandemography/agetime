#' Check or Make Assertions About Periods
#'
#' Collect information on period labels (`period_check()`),
#' or throw an error if period labels do not
#' conform to expectations (`period_assert`).
#'
#' @inheritParams period_lower
#' @param no_overlap No periods overlap.
#' @param no_gap The periods span the entire
#' range from the lower limit of the earliest period
#' to the upper limit of the latest period.
#' @param no_total No "Total" label.
#' @param no_na No NA label.
#' @return For `period_check()`, a list with logical `ok` and data frame
#' `details`; for `period_assert()`, `labels` invisibly or an error.
#'
#' @seealso
#' - [age_check()] Age equivalent of `period_check()`
#' - [cohort_check()] Cohort equivalent of `period_check()`
#'
#' @examples
#' lab <- period_labels_five(
#'   lower_first = 2020,
#'   lower_last = 2030
#' )
#' lab
#'
#' ## get info on everything
#' period_check(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE,
#'   no_total = TRUE,
#'   no_na = TRUE
#' )
#'
#' ## throw error if gaps
#' period_assert(labels = lab, no_gap = TRUE)
#'
#' lab_gap <- lab[c(1, 3)]
#' ## throw error if no gaps
#' period_assert(lab_gap, no_gap = FALSE)
#' @export

# When length(labels) == 0, checks on overlap, gaps, totals,
# and NA are vacuously
# satisfied (observed = TRUE).
period_check <- function(labels,
                         no_overlap = NA,
                         no_gap = NA,
                         no_total = NA,
                         no_na = NA,
                         interpret_single = c("lower", "upper"),
                         interpret_multi = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_check(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    include_zero = NA,
    include_open = NA,
    valid_life = NA
  )
}

#' @rdname period_check
#' @export
period_assert <- function(labels,
                          no_overlap = NA,
                          no_gap = NA,
                          no_total = NA,
                          no_na = NA,
                          interpret_single = c("lower", "upper"),
                          interpret_multi = c("include", "exclude"),
                          interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    include_zero = NA,
    include_open = NA,
    valid_life = NA
  )
}
