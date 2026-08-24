#' Diagnose or Assert Age Groups
#'
#' @description
#' `age_diagnose()` reports whether age group labels
#' meet conditions.
#'
#' `age_assert()` throws an error if conditions are not met.
#'
#' Conditions include:
#'
#' - Not overlapping
#' - Not having gaps
#' - Having totals, NAs, or zeros
#' - Having open age groups
#' - Valid for an abridged life table
#'
#' When `labels` is a factor, these functions check **levels**,
#' including unused levels. Use [age_diagnose_values()] or
#' [age_assert_values()] to check only observed values (useful
#' with grouped data) while still returning the original factor
#' from `age_assert_values()`.
#'
#' @section Abridged and complete life tables:
#'
#' - An abridged life table uses age groups `"0"`
#'   and `"1-4"`, followed by 5-year age groups `"5-9"`, `"10-14"`, ...
#' - A complete life table uses single-year age groups
#'   `"0"`, `"1"`, `"2"`, ...
#' - Both types of life table usually have an open age group
#'   such as `"85+"` or `"100+"`.
#'
#' @inheritParams age_lower
#' @param no_overlap Check that no age groups overlap.
#' Default is `FALSE` (don't check).
#' @param no_gap Check that all ages between the
#' youngest and oldest age groups are included.
#' Default is `FALSE` (don't check).
#' @param no_total Check that there is no total category.
#' Default is `FALSE` (don't check).
#' @param no_na Check that there is no `NA` category.
#' Default is `FALSE` (don't check).
#' @param has_zero Check that at least one
#' age group has a lower limit of zero.
#' Default is `FALSE` (don't check).
#' @param has_open_right Check that at least one age
#' group is open on the right (has no upper limit).
#' Default is `FALSE` (don't check).
#' @param valid_life Check that all labels are
#' valid for an abridged life table.
#' Default is `FALSE` (don't check).
#'
#' @return
#' - `age_diagnose()` and `age_diagnose_values()` return a list with
#'   a logical flag called `ok` and a [tibble][tibble::tibble()]
#'   called `details`.
#' - `age_assert()` and `age_assert_values()` return `labels`
#'   invisibly, or raise an error.
#'
#' @seealso
#' - [age_diagnose_values()] Check observed values only
#' - [period_diagnose()] Period equivalent of `age_diagnose()`
#' - [cohort_diagnose()] Cohort equivalent of `age_diagnose()`
#'
#' @examples
#' lab <- age_labels_life()
#' lab
#'
#' ## get info on everything
#' age_diagnose(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE,
#'   no_total = TRUE,
#'   no_na = TRUE,
#'   has_zero = TRUE,
#'   has_open_right = TRUE,
#'   valid_life = TRUE
#' )
#'
#' ## throw error if overlap or gap
#' age_assert(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE
#' )
#'
#' ## factor with unused overlapping level
#' fac <- factor("0-4", levels = c("0-4", "3-7"))
#' age_diagnose(fac, no_overlap = TRUE)$ok
#' age_diagnose_values(fac, no_overlap = TRUE)$ok
#' @export

# When length(labels) == 0, checks on overlap, gaps, totals, NA, and life-table
# validity are vacuously satisfied. Checks that require at
# least one interval (has_*) fail.
age_diagnose <- function(labels,
                      no_overlap = FALSE,
                      no_gap = FALSE,
                      no_total = FALSE,
                      no_na = FALSE,
                      has_zero = FALSE,
                      has_open_right = FALSE,
                      valid_life = FALSE,
                      interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_diagnose(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail,
    on = "levels",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life
  )
}

#' @rdname age_diagnose
#' @export
age_assert <- function(labels,
                       no_overlap = FALSE,
                       no_gap = FALSE,
                       no_total = FALSE,
                       no_na = FALSE,
                       has_zero = FALSE,
                       has_open_right = FALSE,
                       valid_life = FALSE,
                       interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail,
    on = "levels",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life
  )
}

#' @rdname age_diagnose
#' @export
age_diagnose_values <- function(labels,
                                no_overlap = FALSE,
                                no_gap = FALSE,
                                no_total = FALSE,
                                no_na = FALSE,
                                has_zero = FALSE,
                                has_open_right = FALSE,
                                valid_life = FALSE,
                                interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_diagnose(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail,
    on = "values",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life
  )
}

#' @rdname age_diagnose
#' @export
age_assert_values <- function(labels,
                              no_overlap = FALSE,
                              no_gap = FALSE,
                              no_total = FALSE,
                              no_na = FALSE,
                              has_zero = FALSE,
                              has_open_right = FALSE,
                              valid_life = FALSE,
                              interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail,
    on = "values",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life
  )
}
