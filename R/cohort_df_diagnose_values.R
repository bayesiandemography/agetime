#' Check Observed Cohort Labels in a Data Frame
#'
#' Check values in a cohort column, separately within groups when required.
#' Diagnostics return a flat report; assertions stop at the first failing
#' group and otherwise return the original data frame invisibly.
#'
#' @section Grouping:
#' If `by` is omitted, use existing [dplyr::group_by()] groups, or check all
#' rows together for ungrouped input. An explicitly supplied `by` replaces
#' existing groups. Explicit `by = NULL` or `character(0)` checks all rows
#' together, even for grouped input. Column names are character strings,
#' not tidyselect expressions; named mappings are not supported.
#'
#' Groups appear in order of first observation. Missing keys match missing
#' keys. Unused grouping-factor levels and empty groups are ignored.
#' With omitted `by`, rowwise tibbles are checked one row at a time,
#' retaining any identifier columns as report keys. Assertions preserve
#' the original grouping, including when `by` overrides the checks.
#'
#' @section Values and levels:
#' Only observed values are checked; unused label-factor levels are ignored.
#' Actual `NA` observations are included. Repeated interval labels within
#' a group fail `no_overlap`; repeats across groups do not interact.
#' To check a factor's declared classification, including unused levels,
#' use [cohort_diagnose_levels()] or [cohort_assert_levels()].
#'
#' `no_gap` checks coverage between the earliest and latest observed
#' intervals. It does not require groups to have the same span or detect
#' absent groups or missing end categories. Other checks retain the rules
#' described in [cohort_diagnose_levels()].
#'
#' @section Empty inputs:
#' With no grouping, a zero-row frame represents one empty set of values:
#' absence (`no_`) and validity checks pass, and presence (`has_`) checks
#' fail. With grouping and no rows there are no observed groups, so the
#' report is empty and assertions pass. With no checks requested, reports
#' have zero rows; input validation and parsing still apply.
#'
#' @param data A data frame or tibble with unique, nonempty column names.
#' @param cohort One unnamed string selecting the cohort column.
#' @param by An unnamed character vector of distinct grouping-column names,
#' or `NULL`. Omit to use existing groups; explicitly supply `NULL` to check
#' the whole dataset. The label column cannot be a grouping column.
#' Grouping names `condition`, `passed`, and `comment` are reserved for
#' diagnostic fields; rename such grouping columns before checking.
#' @inheritParams cohort_diagnose_levels
#' @param data_arg Name of `data` used in messages. Defaults to the supplied
#' expression. Selected-column messages append the column name.
#' @param call Execution environment of the function to name in errors.
#' Defaults to this function. A wrapper can supply `rlang::current_env()`.
#' @returns
#' - `cohort_df_diagnose_values()` returns an ungrouped tibble containing
#'   grouping columns followed by `condition` (character), `passed`
#'   (logical), and `comment` (character, `NA` on success). It includes each
#'   requested condition for each group, including successful checks.
#' - `cohort_df_assert_values()` returns `data` identically and invisibly
#'   if all checks pass, or raises an error identifying the first failing
#'   group and its failed conditions.
#'
#' Parsing errors still abort diagnostics with `interpret_fail = "error"`.
#' With `"warn"` or `"silent"`, structural checks passing does not guarantee
#' that all labels were interpretable. Classification results are reused
#' only within the current call, preserving repeated observations.
#'
#' @seealso [cohort_diagnose_levels()], [cohort_assert_levels()],
#'   [cohort_df_coarsen_to()]
#' @inheritSection cohort_lower Rules for interpreting inputs
#'
#' @section Interpretation messages:
#' Default multi-year interpretation advice is emitted at most once per
#' call, considering observed labels rather than unused factor levels.
#' @examples
#' dat <- data.frame(country = c("A", "A", "B", "B"),
#'                   cohort = c("2020-2025", "2030-2035", "2020-2025", "2025-2030"))
#' report <- cohort_df_diagnose_values(
#'   dat, cohort = "cohort", by = "country", no_gap = TRUE, no_overlap = TRUE
#' )
#' report[!report$passed, ]
#'
#' dat$cohort <- c("2020-2025", "2025-2030", "2020-2025", "2025-2030")
#' dat |> cohort_df_assert_values(cohort = "cohort", by = "country", no_gap = TRUE)
#'
#' library(dplyr, warn.conflicts = FALSE)
#' dat |>
#'   group_by(country) |>
#'   cohort_df_diagnose_values(cohort = "cohort", no_overlap = TRUE)
#' @export
cohort_df_diagnose_values <- function(
  data,
  cohort,
  by = NULL,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_left = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  valid_tree = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent"),
  data_arg = rlang::caller_arg(data),
  call = rlang::current_env()
) {
  local_caller(args = list(data = data_arg), call = call)
  interpret_fail <- match.arg(interpret_fail)
  interpret_single <- match.arg(interpret_single)
  checks <- list(
      no_overlap = no_overlap,
      no_gap = no_gap,
      no_total = no_total,
      no_subtotal = no_subtotal,
      no_missing = no_missing,
      no_open_left = no_open_left,
      no_open_right = no_open_right,
      has_total = has_total,
      has_subtotal = has_subtotal,
      has_missing = has_missing,
      has_zero = FALSE,
      has_open_left = has_open_left,
      has_open_right = has_open_right,
      valid_life = FALSE,
      valid_tree = valid_tree
  )
  withCallingHandlers(
    inner_df_diagnose_values(
      data, cohort, by, missing(by), "cohort", checks,
      interpret_single, interpret_multi,
      interpret_fail, data_arg, assert = FALSE
    ),
    error = function(cnd) {
      cnd$call <- rlang::frame_call(call)
      stop(cnd)
    }
  )
}

#' @rdname cohort_df_diagnose_values
#' @export
cohort_df_assert_values <- function(
  data,
  cohort,
  by = NULL,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_left = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_left = FALSE,
  has_open_right = FALSE,
  valid_tree = FALSE,
  interpret_single = c("lower", "upper"),
  interpret_multi = NULL,
  interpret_fail = c("error", "warn", "silent"),
  data_arg = rlang::caller_arg(data),
  call = rlang::current_env()
) {
  local_caller(args = list(data = data_arg), call = call)
  interpret_fail <- match.arg(interpret_fail)
  interpret_single <- match.arg(interpret_single)
  checks <- list(
      no_overlap = no_overlap,
      no_gap = no_gap,
      no_total = no_total,
      no_subtotal = no_subtotal,
      no_missing = no_missing,
      no_open_left = no_open_left,
      no_open_right = no_open_right,
      has_total = has_total,
      has_subtotal = has_subtotal,
      has_missing = has_missing,
      has_zero = FALSE,
      has_open_left = has_open_left,
      has_open_right = has_open_right,
      valid_life = FALSE,
      valid_tree = valid_tree
  )
  withCallingHandlers(
    inner_df_diagnose_values(
      data, cohort, by, missing(by), "cohort", checks,
      interpret_single, interpret_multi,
      interpret_fail, data_arg, assert = TRUE
    ),
    error = function(cnd) {
      cnd$call <- rlang::frame_call(call)
      stop(cnd)
    }
  )
}
