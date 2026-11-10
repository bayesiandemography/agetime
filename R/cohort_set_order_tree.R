#' Set Order of Cohort Levels for a Reporting Tree
#'
#' Modify the `levels` attribute of `labels` so that cohorts
#' are ordered as a reporting tree: the most detailed cohorts
#' first, then broader cohorts, then cohort not stated.
#'
#' In a reporting tree, cohorts nest: any two cohorts
#' either do not overlap, or one contains the other.
#' Reporting trees arise, for instance, in
#' tables of year of birth, where most records have detailed cohorts (`"1960-1970"`), some have only broad cohorts (`"<1960"`), and some have no cohort at all (`"Missing"`).
#'
#' Levels are ordered as follows:
#'
#' 1. Leaves, that is, cohorts that contain no other cohort,
#'    ordered by lower limit.
#' 2. Broader cohorts, ordered so that each cohort comes
#'    after all cohorts inside it, and before any cohort
#'    entirely above it.
#' 3. Labels that could not be interpreted, if `interpret_fail`
#'    is `"warn"` or `"silent"`.
#' 4. Labels for missing values, as defined by [cohort_is_missing()].
#'
#' Different labels that describe the same cohort are placed
#' next to each other, in the order in which they first appear.
#' Leaves do not need to lie at the same depth in the tree.
#'
#' `cohort_set_order_tree()` checks only that the cohorts nest.
#' It does not check, for instance, that the leaves cover the
#' full span. Labels for totals, as defined by [cohort_is_total()], are
#' not part of a reporting tree, and cause an error.
#' Some tables use `"Total"` to mean cohort not stated. In such
#' cases, recode the total to `"Missing"` before calling
#' `cohort_set_order_tree()`, for instance using
#' `x[cohort_is_total(x)] <- "Missing"`.
#'
#' `cohort_set_order_tree()` has no effect on the
#' values of `labels`. Only the levels are changed.
#'
#' @inheritSection cohort_lower Rules for interpreting inputs
#'
#' @inheritParams cohort_lower
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [cohort_set_order()] Order cohorts by lower limit
#' - [age_set_order_tree()] Age equivalent of `cohort_set_order_tree()`
#' - [period_set_order_tree()] Period equivalent of `cohort_set_order_tree()`
#'
#' @examples
#' ## year of birth: detailed cohorts, birth year
#' ## known only as before 1960, and not stated
#' labels <- c("1960-1970", "<1940", "1940-1950", "1950-1960",
#'             "<1960", "Missing")
#' cohort_set_order_tree(labels)
#' @export
#' @template x-arg-call
cohort_set_order_tree <- function(labels,
                         interpret_single = c("lower", "upper"),
                         interpret_multi = NULL,
                         interpret_fail = c("error", "warn", "silent"),
                                  x_arg = rlang::caller_arg(labels),
                                  call = rlang::current_env()) {
  local_caller(args = list(labels = x_arg), call = call)
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- resolve_interpret_multi(
    interpret_multi = interpret_multi,
    labels = labels,
    labels_other = NULL,
    label_type = "cohort",
    interpret_single = interpret_single
  )
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_set_order_tree(
    labels = labels,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
