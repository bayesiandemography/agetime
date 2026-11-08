#' Create Period Labels for a Reporting Tree
#'
#' Create labels for a reporting tree, in which records are
#' tabulated at different levels of detail: detailed periods,
#' broader periods, and, optionally, period not stated.
#'
#' The most detailed periods (the leaves of the tree) are
#' created from `breaks`, `open_left`, and `open_right`, exactly as by
#' [period_labels()]. Broader periods are supplied through `nodes`,
#' as ordinary period labels. Broader periods can be given
#' in any order, and can nest to any depth.
#' Leaves do not need to be the same distance from the root.
#'
#' Labels in `nodes` are interpreted using the same rules as
#' are used to format the leaves, as set by `format_single` and
#' `format_multi`. With the default `format_multi = "at_upper"`,
#' for instance, `"2000-2010"` means the period from the
#' start of 2000 to the start of 2010. Labels in `nodes` are
#' then converted into the same format as the leaves.
#'
#' Each broad period must start and end at values in `breaks`
#' (or be open, if `open_left` or `open_right` is `TRUE`), so that it
#' is a union of detailed periods. It must contain at least two
#' detailed periods, but not all of them, and broad periods
#' must nest: any two either do not overlap, or one contains the
#' other.
#'
#' The root of the tree, representing records with no information
#' on period, is labelled `"Missing"`. Unlike [period_labels()],
#' `period_labels_tree()` includes `"Missing"` by default, since
#' most reporting trees in practice have a category for
#' period not stated.
#'
#' Labels are returned in the same order as
#' [period_set_order_tree()]: detailed periods, then broad
#' periods (each after the periods inside it), then `"Missing"`.
#'
#' @inheritSection period_labels Rules for formatting output
#'
#' @inheritParams period_labels
#' @param nodes Labels for broad periods. A character vector,
#' or `NULL` (the default), in which case there are no broad
#' periods.
#' @param include_missing Whether to include a `"Missing"`
#' category, representing period not stated.
#' Default is `TRUE`.
#'
#' @return Character vector.
#'
#' @seealso
#' - [period_labels()] Create labels without broad periods
#' - [period_set_order_tree()] Order existing labels as a tree
#' - [period_diagnose_values()] Check labels, including with
#'   `valid_tree = TRUE`
#' - [age_labels_tree()] Age equivalent of `period_labels_tree()`
#' - [cohort_labels_tree()] Cohort equivalent of `period_labels_tree()`
#'
#' @examples
#' ## year of arrival: 5-year periods, a broad group
#' ## for arrivals before 2010, and not stated
#' period_labels_tree(
#'   breaks = seq(2000, 2020, 5),
#'   nodes = "<2010",
#'   open_left = TRUE
#' )
#'
#' ## labels in "below_upper" format
#' period_labels_tree(
#'   breaks = seq(2000, 2020, 5),
#'   nodes = c("2000-2009", "2010-2019"),
#'   format_multi = "below_upper"
#' )
#' @export
period_labels_tree <- function(breaks,
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
    label_type = "period",
    format_single = format_single,
    format_multi = format_multi,
    is_open_left = open_left,
    is_open_right = open_right,
    include_missing = include_missing
  )
}
