#' Check Observed Age Labels in a Data Frame
#'
#' Check values in a age column, separately within groups when required.
#' Diagnostics return a flat report; assertions stop at the first failing
#' group and otherwise return the original data frame invisibly.
#'
#' @section Grouping:
#' If `by` is omitted, use existing [dplyr::group_by()] groups, or check all
#' rows together for ungrouped input. An explicitly supplied `by` replaces
#' existing groups. Explicit `by = NULL` or `character(0)` checks all rows
#' together, even for grouped input. Column arguments use
#' [tidyselect][tidyselect::language] semantics, including bare names,
#' ranges, and selection helpers. Renaming columns is not supported.
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
#' use [age_diagnose_levels()] or [age_assert_levels()].
#'
#' `no_gap` checks coverage between the earliest and latest observed
#' intervals. It does not require groups to have the same span or detect
#' absent groups or missing end categories. Other checks retain the rules
#' described in [age_diagnose_levels()].
#'
#' For column names stored in character vectors, use
#' [tidyselect::all_of()] or [tidyselect::any_of()]. A wrapper accepting
#' selection expressions can forward them with `{{ }}`. To preserve inferred
#' grouping, a wrapper must omit `by` when its own `by` is omitted.
#'
#' @section Empty inputs:
#' With no grouping, a zero-row frame represents one empty set of values:
#' absence (`no_`) and `valid_tree` checks pass, and presence (`has_`) and
#' `valid_life` checks fail. With grouping and no rows there are no observed
#' groups, so the report is empty and assertions pass. With no checks requested, reports
#' have zero rows; input validation and parsing still apply.
#'
#' @param data A data frame or tibble with unique, nonempty column names.
#' @param age <[tidy-select][tidyselect::language]> Select exactly one
#' age column, for example `age` or `all_of(column_name)`.
#' @param by <[tidy-select][tidyselect::language]> Select grouping columns,
#' for example `c(country, year, sex)`. Omit to use existing groups;
#' explicitly supply `NULL` to check
#' the whole dataset. The label column cannot be a grouping column.
#' Grouping names `condition`, `passed`, and `comment` are reserved for
#' diagnostic fields; rename such grouping columns before checking.
#' @inheritParams age_diagnose_levels
#' @param data_arg Name of `data` used in messages. Defaults to the supplied
#' expression. Selected-column messages append the column name.
#' @param call Execution environment of the function to name in errors.
#' Defaults to this function. A wrapper can supply `rlang::current_env()`.
#' @returns
#' - `age_df_diagnose_values()` returns an ungrouped tibble containing
#'   grouping columns followed by `condition` (character), `passed`
#'   (logical), and `comment` (character, `NA` on success). It includes each
#'   requested condition for each group, including successful checks.
#' - `age_df_assert_values()` returns `data` identically and invisibly
#'   if all checks pass, or raises an error identifying the first failing
#'   group and its failed conditions.
#'
#' Parsing errors still abort diagnostics with `interpret_fail = "error"`.
#' With `"warn"` or `"silent"`, structural checks passing does not guarantee
#' that all labels were interpretable. Classification results are reused
#' only within the current call, preserving repeated observations.
#'
#' @seealso [age_diagnose_levels()], [age_assert_levels()],
#'   [age_df_coarsen_to()]
#' @examples
#' dat <- data.frame(country = c("A", "A", "B", "B"),
#'                   age = c("0-4", "10-14", "0-4", "5-9"))
#' report <- age_df_diagnose_values(
#'   dat, age = age, by = country, no_gap = TRUE, no_overlap = TRUE
#' )
#' report[!report$passed, ]
#'
#' dat$age <- c("0-4", "5-9", "0-4", "5-9")
#' dat |> age_df_assert_values(age = age, by = country, no_gap = TRUE)
#'
#' ## check a full life-table age classification within each country
#' dat <- data.frame(country = rep(c("A", "B"), each = 4),
#'                   age = rep(c("0", "1-4", "5-9", "10+"), 2))
#' age_df_assert_values(dat, age = age, by = country, valid_life = TRUE)
#'
#' library(dplyr, warn.conflicts = FALSE)
#' dat |>
#'   group_by(country) |>
#'   age_df_diagnose_values(age = age, no_overlap = TRUE)
#' @export
age_df_diagnose_values <- function(
  data,
  age,
  by = NULL,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_right = FALSE,
  has_zero = FALSE,
  valid_life = FALSE,
  valid_tree = FALSE,
  interpret_fail = c("error", "warn", "silent"),
  data_arg = rlang::caller_arg(data),
  call = rlang::current_env()
) {
  local_caller(args = list(data = data_arg), call = call)
  interpret_fail <- match.arg(interpret_fail)
  checks <- list(
      no_overlap = no_overlap,
      no_gap = no_gap,
      no_total = no_total,
      no_subtotal = no_subtotal,
      no_missing = no_missing,
      no_open_left = FALSE,
      no_open_right = no_open_right,
      has_total = has_total,
      has_subtotal = has_subtotal,
      has_missing = has_missing,
      has_zero = has_zero,
      has_open_left = FALSE,
      has_open_right = has_open_right,
      valid_life = valid_life,
      valid_tree = valid_tree
  )
  withCallingHandlers(
    inner_df_diagnose_values(
      data, rlang::enquo(age), rlang::enquo(by), missing(by), "age", checks,
      "lower", "below_upper",
      interpret_fail, data_arg, assert = FALSE
    ),
    error = function(cnd) {
      cnd$call <- rlang::frame_call(call)
      stop(cnd)
    }
  )
}

#' @rdname age_df_diagnose_values
#' @export
age_df_assert_values <- function(
  data,
  age,
  by = NULL,
  no_overlap = FALSE,
  no_gap = FALSE,
  no_total = FALSE,
  no_subtotal = FALSE,
  no_missing = FALSE,
  no_open_right = FALSE,
  has_total = FALSE,
  has_subtotal = FALSE,
  has_missing = FALSE,
  has_open_right = FALSE,
  has_zero = FALSE,
  valid_life = FALSE,
  valid_tree = FALSE,
  interpret_fail = c("error", "warn", "silent"),
  data_arg = rlang::caller_arg(data),
  call = rlang::current_env()
) {
  local_caller(args = list(data = data_arg), call = call)
  interpret_fail <- match.arg(interpret_fail)
  checks <- list(
      no_overlap = no_overlap,
      no_gap = no_gap,
      no_total = no_total,
      no_subtotal = no_subtotal,
      no_missing = no_missing,
      no_open_left = FALSE,
      no_open_right = no_open_right,
      has_total = has_total,
      has_subtotal = has_subtotal,
      has_missing = has_missing,
      has_zero = has_zero,
      has_open_left = FALSE,
      has_open_right = has_open_right,
      valid_life = valid_life,
      valid_tree = valid_tree
  )
  withCallingHandlers(
    inner_df_diagnose_values(
      data, rlang::enquo(age), rlang::enquo(by), missing(by), "age", checks,
      "lower", "below_upper",
      interpret_fail, data_arg, assert = TRUE
    ),
    error = function(cnd) {
      cnd$call <- rlang::frame_call(call)
      stop(cnd)
    }
  )
}
