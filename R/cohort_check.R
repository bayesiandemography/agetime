#' Check or Make Assertions About Cohorts
#'
#' Collect information on cohort labels (`cohort_check()`),
#' or throw an error if cohort labels do not
#' conform to expectations (`cohort_assert`).
#'
#' @inheritParams cohort_lower
#' @param no_overlap No cohorts overlap.
#' @param no_gap The cohorts span the entire
#' range from the lower limit of the earliest cohort
#' to the upper limit of the latest cohort.
#' @param no_total No "Total" label.
#' @param no_na No NA label.
#' @param include_open One or more cohorts
#' has no lower limit.
#' @return For `cohort_check()`, a list with logical `ok` and data frame
#' `details`; for `cohort_assert()`, `labels` invisibly or an error.
#'
#' @seealso
#' - [age_check()] Age equivalent of `cohort_check()`
#' - [period_check()] Period equivalent of `cohort_check()`
#'
#' @examples
#' lab <- cohort_labels_five(
#'   lower_first = 2020,
#'   lower_last = 2030
#' )
#' lab
#'
#' ## get info on everything
#' cohort_check(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE,
#'   no_total = TRUE,
#'   no_na = TRUE,
#'   include_open = TRUE
#' )
#'
#' ## throw error if gaps
#' cohort_assert(labels = lab, no_gap = TRUE)
#'
#' lab_gap <- lab[c(1, 3)]
#' ## throw error if no gaps
#' cohort_assert(lab_gap, no_gap = FALSE)
#' @export

# When length(labels) == 0, checks on overlap, gaps, totals,
# and NA are vacuously
# satisfied (observed = TRUE). include_open fails (observed = FALSE).
cohort_check <- function(labels,
                         no_overlap = NA,
                         no_gap = NA,
                         no_total = NA,
                         no_na = NA,
                         include_open = NA,
                         interpret_single = c("lower", "upper"),
                         interpret_range = c("include", "exclude"),
                         interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_check(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail,
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    include_zero = NA,
    include_open = include_open,
    valid_life = NA
  )
}

#' @rdname cohort_check
#' @export
cohort_assert <- function(labels,
                          no_overlap = NA,
                          no_gap = NA,
                          no_total = NA,
                          no_na = NA,
                          include_open = NA,
                          interpret_single = c("lower", "upper"),
                          interpret_range = c("include", "exclude"),
                          interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail,
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    include_zero = NA,
    include_open = include_open,
    valid_life = NA
  )
}
