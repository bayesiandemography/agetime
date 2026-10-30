#' Diagnostics and Assertions for Age Groups
#'
#' @description
#' Check whether age group labels meet conditions.
#' The `diagnose` functions report on each condition, and the
#' `assert` functions throw an error if a condition is not met.
#'
#' - `age_diagnose_levels()` and `age_assert_levels()` check the
#'   levels of a factor, including unused levels.
#' - `age_diagnose_values()` and `age_assert_values()` check the
#'   elements of `labels`, treating each element as a separate age group.
#'
#' Conditions include:
#'
#' - Not overlapping
#' - Not having gaps
#' - Not having totals or NAs
#' - Having, or not having, open age groups
#' - Having an age group that starts at zero
#' - Only including age groups used by an abridged life table
#'
#' @section Abridged and complete life tables:
#'
#' - An abridged life table uses age groups `"0"`
#'   and `"1-4"`, followed by 5-year age groups such as `"5-9"` and `"10-14"`.
#' - A complete life table uses single-year age groups such as `"0"`, `"1"`, and `"2"`.
#' - Both types of life table usually have an open age group
#'   such as `"85+"` or `"100+"`.
#'
#' @inheritParams age_lower
#' @param no_overlap Check that no age groups overlap.
#' Different labels that describe the same interval,
#' such as `"0"` and `"infant"`, count as overlapping.
#' Default is `FALSE` (don't check).
#' @param no_gap Check that all ages between the
#' youngest and oldest age groups are included.
#' Default is `FALSE` (don't check).
#' @param no_total Check that there is no total category.
#' Default is `FALSE` (don't check).
#' @param no_na Check that there is no `NA` category.
#' Default is `FALSE` (don't check).
#' @param no_open_right Check that no age group
#' is open on the right (has no upper limit).
#' Default is `FALSE` (don't check).
#' @param has_open_right Check that at least one age
#' group is open on the right (has no upper limit).
#' Default is `FALSE` (don't check).
#' @param has_zero Check that at least one
#' age group has a lower limit of zero.
#' Default is `FALSE` (don't check).
#' @param valid_life Check that all labels are
#' valid for an abridged life table.
#' Default is `FALSE` (don't check).
#'
#' @return
#' - `age_diagnose_levels()` and `age_diagnose_values()` return a list with
#'   a logical flag called `ok` and a [tibble][tibble::tibble()]
#'   called `details`.
#' - `age_assert_levels()` and `age_assert_values()` return `labels`
#'   invisibly, or raise an error.
#'
#' @seealso
#' - [period_diagnose_levels()] Period equivalent of `age_diagnose_levels()`
#' - [cohort_diagnose_levels()] Cohort equivalent of `age_diagnose_levels()`
#'
#' @examples
#' lab <- age_labels_life()
#' lab
#'
#' ## get info on everything
#' age_diagnose_values(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE,
#'   no_total = TRUE,
#'   no_na = TRUE,
#'   has_open_right = TRUE,
#'   has_zero = TRUE,
#'   valid_life = TRUE
#' )
#'
#' ## throw error if overlap or gap
#' age_assert_values(
#'   labels = lab,
#'   no_overlap = TRUE,
#'   no_gap = TRUE
#' )
#'
#' ## repeated labels count as overlapping...
#' df <- data.frame(
#'   age = c("0-4", "5-9", "0-4", "5-9"),
#'   sex = c("F", "F", "M", "M")
#' )
#' age_diagnose_values(df$age, no_overlap = TRUE)
#'
#' ## ...so check within groups
#' library(dplyr, warn.conflicts = FALSE)
#' df |>
#'   group_by(sex) |>
#'   mutate(age = age_assert_values(age, no_overlap = TRUE))
#'
#' ## factor with unused level
#' fac <- factor(
#'   x = "0-4",
#'   levels = c("0-4", "3-7")
#' )
#' fac
#' age_diagnose_levels(fac, no_overlap = TRUE)
#' age_diagnose_values(fac, no_overlap = TRUE)
#' @export

# When length(labels) == 0, checks on overlap, gaps, totals, NA, and life-table
# validity are vacuously satisfied. Checks that require at
# least one interval (has_*) fail.
age_diagnose_levels <- function(labels,
                      no_overlap = FALSE,
                      no_gap = FALSE,
                      no_total = FALSE,
                      no_na = FALSE,
                      no_open_right = FALSE,
                      has_open_right = FALSE,
                      has_zero = FALSE,
                      valid_life = FALSE,
                      interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_diagnose(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail,
    on = "levels",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    no_open_left = FALSE,
    no_open_right = no_open_right,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life
  )
}

#' @rdname age_diagnose_levels
#' @export
age_assert_levels <- function(labels,
                       no_overlap = FALSE,
                       no_gap = FALSE,
                       no_total = FALSE,
                       no_na = FALSE,
                       no_open_right = FALSE,
                       has_open_right = FALSE,
                       has_zero = FALSE,
                       valid_life = FALSE,
                       interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail,
    on = "levels",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    no_open_left = FALSE,
    no_open_right = no_open_right,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life
  )
}

#' @rdname age_diagnose_levels
#' @export
age_diagnose_values <- function(labels,
                                no_overlap = FALSE,
                                no_gap = FALSE,
                                no_total = FALSE,
                                no_na = FALSE,
                                no_open_right = FALSE,
                                has_open_right = FALSE,
                                has_zero = FALSE,
                                valid_life = FALSE,
                                interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_diagnose(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail,
    on = "values",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    no_open_left = FALSE,
    no_open_right = no_open_right,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life
  )
}

#' @rdname age_diagnose_levels
#' @export
age_assert_values <- function(labels,
                              no_overlap = FALSE,
                              no_gap = FALSE,
                              no_total = FALSE,
                              no_na = FALSE,
                              no_open_right = FALSE,
                              has_open_right = FALSE,
                              has_zero = FALSE,
                              valid_life = FALSE,
                              interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_assert(
    labels = labels,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "below_upper",
    interpret_fail = interpret_fail,
    on = "values",
    no_overlap = no_overlap,
    no_gap = no_gap,
    no_total = no_total,
    no_na = no_na,
    no_open_left = FALSE,
    no_open_right = no_open_right,
    has_zero = has_zero,
    has_open_left = FALSE,
    has_open_right = has_open_right,
    valid_life = valid_life
  )
}
