#' Create Cohort Labels for a Reporting Tree
#'
#' Create labels for a reporting tree, in which records are
#' tabulated at different levels of detail: detailed cohorts,
#' broader cohorts, and, optionally, cohort not stated.
#'
#' The most detailed cohorts (the leaves of the tree) are
#' created from `breaks`, `open_left`, and `open_right`, exactly as by
#' [cohort_labels()]. Broader cohorts are supplied through `nodes`,
#' as ordinary cohort labels. Broader cohorts can be given
#' in any order, and can nest to any depth.
#' Leaves do not need to be the same distance from the root.
#'
#' Labels in `nodes` are interpreted using the same rules as
#' are used to format the leaves, as set by `format_single` and
#' `format_multi`. With the default `format_multi = "at_upper"`,
#' for instance, `"2000-2010"` means the cohort from the
#' start of 2000 to the start of 2010. Labels in `nodes` are
#' then converted into the same format as the leaves.
#'
#' Each broad cohort must start and end at values in `breaks`
#' (or be open, if `open_left` or `open_right` is `TRUE`), so that it
#' is a union of detailed cohorts. It must contain at least two
#' detailed cohorts, but not all of them, and broad cohorts
#' must nest: any two either do not overlap, or one contains the
#' other.
#'
#' The root of the tree, representing records with no information
#' on cohort, is labelled `"Missing"`. Unlike [cohort_labels()],
#' `cohort_labels_tree()` includes `"Missing"` by default, since
#' most reporting trees in practice have a category for
#' cohort not stated.
#'
#' Labels are returned in the same order as
#' [cohort_set_order_tree()]: detailed cohorts, then broad
#' cohorts (each after the cohorts inside it), then `"Missing"`.
#'
#' @inheritSection cohort_labels Rules for formatting output
#'
#' @inheritParams cohort_labels
#' @param nodes Labels for broad cohorts. A character vector,
#' or `NULL` (the default), in which case there are no broad
#' cohorts.
#' @param include_missing Whether to include a `"Missing"`
#' category, representing cohort not stated.
#' Default is `TRUE`.
#'
#' @return Character vector.
#'
#' @seealso
#' - [cohort_labels()] Create labels without broad cohorts
#' - [cohort_set_order_tree()] Order existing labels as a tree
#' - [cohort_diagnose_values()] Check labels, including with
#'   `valid_tree = TRUE`
#' - [age_labels_tree()] Age equivalent of `cohort_labels_tree()`
#' - [period_labels_tree()] Period equivalent of `cohort_labels_tree()`
#'
#' @examples
#' ## year of birth: 10-year cohorts, a broad group
#' ## for births before 1960, and not stated
#' cohort_labels_tree(
#'   breaks = seq(1940, 2000, 10),
#'   nodes = "<1960",
#'   open_left = TRUE
#' )
#' @export
cohort_labels_tree <- function(breaks,
                       nodes = NULL,
                       open_left = FALSE,
                       open_right = FALSE,
                       format_single = c("lower", "upper"),
                       format_multi = c("at_upper", "below_upper"),
                       include_missing = TRUE) {
  check_flag(x = open_left, nm_x = "open_left")
  check_flag(x = open_right, nm_x = "open_right")
  format_single <- match.arg(format_single)
  format_multi <- match.arg(format_multi)
  inner_labels_tree(
    breaks = breaks,
    nodes = nodes,
    label_type = "cohort",
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = open_left,
    is_open_right = open_right,
    include_missing = include_missing
  )
}
