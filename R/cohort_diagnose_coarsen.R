#' Check Whether Cohorts Can Be Aggregated to a Target Classification
#'
#' @description
#' Check that observations labelled by `labels` can be aggregated to the
#' cohorts in `to`, without splitting observations, omitting required
#' cohorts, or counting cohorts more than once.
#'
#' `cohort_diagnose_coarsen()` reports the results of the checks.
#' `cohort_assert_coarsen()` returns `labels` invisibly if the checks pass,
#' and throws an error otherwise. Neither function recodes the labels
#' or aggregates observations.
#'
#' @details
#' Both inputs must consist of cohort intervals, with no totals, missing
#' categories, or `NA` values. Within each input, intervals must not
#' overlap. Repeated labels, and different labels describing the same
#' interval, count as overlapping.
#'
#' Every source interval must fit wholly inside exactly one target
#' interval. The source intervals assigned to each target must cover it
#' completely, with no gaps. Matching gaps between target intervals are
#' allowed. Use [cohort_assert_values()] with `no_gap = TRUE` if
#' continuous coverage is also required.
#'
#' By default, identical classifications pass. Equality is based on
#' intervals, regardless of spelling or ordering. With
#' `include_equals = FALSE`, at least one target interval must combine
#' two or more source intervals; other intervals may stay unchanged.
#'
#' The same interpretation rules apply to `labels` and `to`.
#' Unlike [cohort_coarsen_to()], these functions also check for overlaps
#' among source observations and for complete coverage of every target.
#' They do not check the values being aggregated or other join keys.
#'
#' @section Factors:
#' Both functions check observed values; unused factor levels are ignored.
#' Supply `levels(x)` explicitly to check all factor levels instead.
#' [cohort_coarsen_to()] uses all factor levels when recoding. To coarsen
#' only the values checked here, drop unused levels in both factor inputs,
#' or convert them to character vectors before recoding.
#'
#' @inheritSection cohort_lower Rules for interpreting inputs
#' @inheritParams cohort_lower
#' @inheritParams age_diagnose_coarsen
#' @param to Vector of cohort labels giving the target classification.
#' @param interpret_fail Action if a label cannot be interpreted:
#' `"error"` (the default), `"warn"`, or `"silent"`. Uninterpretable
#' labels fail the checks even when parsing errors are suppressed.
#' @param call Execution environment of the function to name in errors
#' from `cohort_assert_coarsen()`. Defaults to the assertion itself.
#' A calling function can supply `call = rlang::current_env()`.
#'
#' @return
#' - `cohort_diagnose_coarsen()` returns a list with a logical flag `ok`
#'   and a tibble `details`, with columns `condition`, `passed`, and
#'   `comment`, as in [cohort_diagnose_values()]. Checks that depend on
#'   earlier failed checks are omitted. Comments give an example of
#'   each failure.
#' - `cohort_assert_coarsen()` returns the original `labels` invisibly,
#'   or raises an error explaining the failures.
#'
#' Two empty inputs pass when `include_equals = TRUE`. An empty input
#' paired with a nonempty input fails.
#'
#' @seealso
#' - [cohort_coarsen_to()], [cohort_mapping()], [cohort_assert_values()]
#' - [age_assert_coarsen()], [age_diagnose_coarsen()]
#' - [period_assert_coarsen()], [period_diagnose_coarsen()]
#'
#' @examples
#' labels <- c("2000-2005", "2005-2010", "2010+")
#' target <- c("2000-2010", "2010+")
#' cohort_assert_coarsen(labels, to = target)
#' cohort_coarsen_to(labels, to = target)
#'
#' ## equality is allowed by default
#' cohort_assert_coarsen(target, to = target)
#' cohort_diagnose_coarsen(target, to = target, include_equals = FALSE)
#'
#' ## missing years in a target interval
#' cohort_diagnose_coarsen(c("2000-2005", "2010+"), to = target)
#'
#' ## an open interval on the left can also be coarsened
#' cohort_assert_coarsen(c("<2000", "2000-2005"), to = "<2005")
#'
#' ## specify inclusive upper endpoints for multi-year labels
#' cohort_assert_coarsen(
#'   c("2000-2004", "2005-2009"),
#'   to = "2000-2009",
#'   interpret_multi = "below_upper"
#' )
#' @export
cohort_diagnose_coarsen <- function(labels,
                                    to,
                                    include_equals = TRUE,
                                    interpret_single = c("lower", "upper"),
                                    interpret_multi = NULL,
                                    interpret_fail = c("error", "warn", "silent"),
                                    x_arg = rlang::caller_arg(labels),
                                    to_arg = rlang::caller_arg(to)) {
  local_caller(args = list(labels = x_arg, to = to_arg),
               call = rlang::current_env())
  interpret_single <- match.arg(interpret_single)
  interpret_fail <- match.arg(interpret_fail)
  inner_diagnose_coarsen(labels, to, include_equals, interpret_fail,
                         label_type = "cohort", interpret_single = interpret_single,
                         interpret_multi = interpret_multi)
}

#' @rdname cohort_diagnose_coarsen
#' @export
cohort_assert_coarsen <- function(labels,
                                  to,
                                  include_equals = TRUE,
                                  interpret_single = c("lower", "upper"),
                                  interpret_multi = NULL,
                                  interpret_fail = c("error", "warn", "silent"),
                                  x_arg = rlang::caller_arg(labels),
                                  to_arg = rlang::caller_arg(to),
                                  call = rlang::current_env()) {
  local_caller(args = list(labels = x_arg, to = to_arg), call = call)
  interpret_single <- match.arg(interpret_single)
  interpret_fail <- match.arg(interpret_fail)
  val <- inner_diagnose_coarsen(labels, to, include_equals, interpret_fail,
                                label_type = "cohort", interpret_single = interpret_single,
                                interpret_multi = interpret_multi)
  throw_coarsen_assert_error(val, "cohort", x_arg, to_arg, call)
  invisible(labels)
}
