#' Check Whether Age Groups Can Be Aggregated to a Target Classification
#'
#' @description
#' Check that observations labelled by `labels` can be aggregated to the
#' age groups in `to`, without splitting observations, omitting required
#' ages, or counting ages more than once.
#'
#' `age_diagnose_coarsen()` reports the results of the checks.
#' `age_assert_coarsen()` returns `labels` invisibly if the checks pass,
#' and throws an error otherwise. Neither function recodes the labels
#' or aggregates observations.
#'
#' @details
#' Both inputs must consist of age intervals, with no totals, missing
#' categories, or `NA` values. Within each input, intervals must not
#' overlap. Repeated labels, and different labels describing the same
#' interval, count as overlapping.
#'
#' Every source interval must fit wholly inside exactly one target
#' interval. The source intervals assigned to each target must cover it
#' completely, with no gaps. The classifications may have gaps between
#' target intervals, provided that the source has the same gaps.
#' Use [age_assert_values()] with `no_gap = TRUE` if continuous coverage
#' is also required.
#'
#' By default, identical classifications pass. Equality is based on
#' intervals, regardless of spelling or ordering. With
#' `include_equals = FALSE`, at least one target interval must combine
#' two or more source intervals; other intervals may stay unchanged.
#'
#' Unlike [age_coarsen_to()], these functions also check for overlaps
#' among source observations and for complete coverage of every target.
#' They do not check the values being aggregated, or whether other join
#' keys such as country and year match between datasets.
#'
#' @section Factors:
#' Both functions check the observed values of `labels` and `to`.
#' Unused factor levels are ignored, as in [age_assert_values()].
#' To check a classification defined by all factor levels instead,
#' supply `levels(x)` explicitly.
#'
#' [age_coarsen_to()] uses all factor levels when recoding. To coarsen
#' only the values checked here, supply `droplevels(labels)` and
#' `droplevels(to)` when the inputs are factors, or convert them to
#' character vectors.
#'
#' @inheritParams age_lower
#' @param to Vector of age group labels giving the target classification.
#' @param include_equals Whether to allow identical classifications.
#' Default is `TRUE`. Set to `FALSE` to require at least one genuine merge.
#' @param interpret_fail Action if a label cannot be interpreted:
#' `"error"` (the default), `"warn"`, or `"silent"`. Uninterpretable
#' labels fail the checks even when parsing errors are suppressed.
#' @param x_arg Name of `labels` to use in error and warning messages.
#' Defaults to the expression supplied for `labels`.
#' @param to_arg Name of `to` to use in error and warning messages.
#' Defaults to the expression supplied for `to`.
#' @param call Execution environment of the function to name in errors
#' from `age_assert_coarsen()`. Defaults to the assertion itself.
#' A calling function can supply `call = rlang::current_env()`.
#'
#' @return
#' - `age_diagnose_coarsen()` returns a list with a logical flag `ok`
#'   and a tibble `details`, with columns `condition`, `passed`, and
#'   `comment`, as in [age_diagnose_values()]. Checks that depend on
#'   earlier failed checks are omitted. Comments give an example of
#'   each failure.
#' - `age_assert_coarsen()` returns the original `labels` invisibly,
#'   or raises an error explaining the failures.
#'
#' Two empty inputs pass when `include_equals = TRUE`. An empty input
#' paired with a nonempty input fails.
#'
#' @seealso
#' - [age_coarsen_to()], [age_mapping()], [age_assert_values()]
#' - [period_assert_coarsen()], [period_diagnose_coarsen()]
#' - [cohort_assert_coarsen()], [cohort_diagnose_coarsen()]
#'
#' @examples
#' age <- c("0-4", "5-9", "10+")
#' target <- c("0-9", "10+")
#' age_assert_coarsen(age, to = target)
#' age_coarsen_to(age, to = target)
#'
#' ## equality is allowed by default
#' age_assert_coarsen(target, to = target)
#' age_diagnose_coarsen(target, to = target, include_equals = FALSE)
#'
#' ## target 0-9 is missing source ages 5-9
#' age_diagnose_coarsen(c("0-4", "10+"), to = target)
#'
#' ## a source interval crosses a target boundary
#' age_diagnose_coarsen(c("0-6", "7+"), to = target)
#'
#' ## matching gaps between targets are allowed
#' age_assert_coarsen(c("0-4", "5-9", "20+"), to = c("0-9", "20+"))
#'
#' ## check and aggregate separately within groups
#' library(dplyr, warn.conflicts = FALSE)
#' df <- data.frame(
#'   sex = rep(c("Female", "Male"), each = 3),
#'   age = rep(age, 2),
#'   deaths = c(1, 2, 3, 4, 5, 6)
#' )
#' df |>
#'   mutate(age = age_assert_coarsen(age, to = target), .by = sex) |>
#'   mutate(age = age_coarsen_to(age, to = target), .by = sex) |>
#'   summarise(deaths = sum(deaths), .by = c(sex, age))
#' @export
age_diagnose_coarsen <- function(labels,
                                 to,
                                 include_equals = TRUE,
                                 interpret_fail = c("error", "warn", "silent"),
                                 x_arg = rlang::caller_arg(labels),
                                 to_arg = rlang::caller_arg(to)) {
  local_caller(args = list(labels = x_arg, to = to_arg),
               call = rlang::current_env())
  interpret_fail <- match.arg(interpret_fail)
  inner_diagnose_coarsen(labels, to, include_equals, interpret_fail,
                         label_type = "age", interpret_single = "lower",
                         interpret_multi = "below_upper")
}

#' @rdname age_diagnose_coarsen
#' @export
age_assert_coarsen <- function(labels,
                               to,
                               include_equals = TRUE,
                               interpret_fail = c("error", "warn", "silent"),
                               x_arg = rlang::caller_arg(labels),
                               to_arg = rlang::caller_arg(to),
                               call = rlang::current_env()) {
  local_caller(args = list(labels = x_arg, to = to_arg), call = call)
  interpret_fail <- match.arg(interpret_fail)
  val <- inner_diagnose_coarsen(labels, to, include_equals, interpret_fail,
                                label_type = "age", interpret_single = "lower",
                                interpret_multi = "below_upper")
  throw_coarsen_assert_error(val, "age", x_arg, to_arg, call)
  invisible(labels)
}
