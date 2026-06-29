#' Check or Make Assertions About Age Groups
#'
#' Collect information on age group labels (`age_check()`),
#' or throw an error if age group labels do not
#' conform to expectations (`age_assert`).
#'
#' @inheritParams age_lower
#' @param no_overlap No age groups overlap.
#' @param no_gap Age groups span entire
#' range from lower limit of youngest age
#' group to upper limit of oldest age group.
#' @param no_total No "Total" age group.
#' @param no_na No NA age group.
#' @param include_zero One or more age groups
#' have a lower limit of zero.
#' @param include_open One or more age groups
#' has no upper limit.
#' @param valid_life All labels valid for
#' (abridged) life table.
#' @return For `age_check()`, a list with logical `ok` and data frame
#' `details`; for `age_assert()`, `labels` invisibly or an error.
#'
#' @seealso
#' - [period_check()] Period equivalent of `age_check()`
#' - [cohort_check()] Cohort equivalent of `age_check()`
#'
#' @examples
#' lab <- age_labels_life()
#' lab
#'
#' ## get info on everything
#' age_check(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE,
#'   no_total = TRUE,
#'   no_na = TRUE,
#'   include_zero = TRUE,
#'   include_open = TRUE,
#'   valid_life = TRUE
#' )
#'
#' ## throw error if gaps
#' age_assert(labels = lab, no_gap = TRUE)
#'
#' lab_gap <- lab[c(1, 3)]
#' ## throw error if no gaps
#' age_assert(labels = lab_gap, no_gap = FALSE)
#' @export

# When length(labels) == 0, checks on overlap, gaps, totals, NA, and life-table
# validity are vacuously satisfied (observed = TRUE). Checks that require at
# least one interval (include_*) fail (observed = FALSE).
age_check <- function(labels,
                      no_overlap = NA,
                      no_gap = NA,
                      no_total = NA,
                      no_na = NA,
                      include_zero = NA,
                      include_open = NA,
                      valid_life = NA,
                      interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_check(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_range = "exclude",
    interpret_fail = interpret_fail,
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    include_zero = include_zero,
    include_open = include_open,
    valid_life = valid_life
  )
}

#' @rdname age_check
#' @export
age_assert <- function(labels,
                       no_overlap = NA,
                       no_gap = NA,
                       no_total = NA,
                       no_na = NA,
                       include_zero = NA,
                       include_open = NA,
                       valid_life = NA,
                       interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_range = "exclude",
    interpret_fail = interpret_fail,
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    include_zero = include_zero,
    include_open = include_open,
    valid_life = valid_life
  )
}
