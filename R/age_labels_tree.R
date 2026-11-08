#' Create Age Group Labels for a Reporting Tree
#'
#' Create labels for a reporting tree, in which records are
#' tabulated at different levels of detail: detailed age groups,
#' broader age groups, and, optionally, age not stated.
#'
#' The most detailed age groups (the leaves of the tree) are
#' created from `breaks` and `open_right`, exactly as by
#' [age_labels()]. Broader age groups are supplied through `nodes`,
#' as ordinary age group labels such as `"0-14"` or `"65+"`.
#' Broader age groups can be given in any order, and can nest
#' to any depth: for instance, `nodes = c("0-14", "15+", "15-64", "65+")`
#' describes a tree where `"15+"` is divided into `"15-64"` and
#' `"65+"`, each of which is divided into detailed age groups.
#' Leaves do not need to be the same distance from the root.
#'
#' Each broad age group must start and end at values in `breaks`
#' (or be open, if `open_right` is `TRUE`), so that it is a union
#' of detailed age groups. It must contain at least two
#' detailed age groups, but not all of them, and broad age groups
#' must nest: any two either do not overlap, or one contains the
#' other. Labels in `nodes` are converted to the standard format
#' used by [age_standard()], so that, for instance,
#' `"Under 15"` becomes `"0-14"`.
#'
#' The root of the tree, representing records with no information
#' on age, is labelled `"Missing"`. Unlike [age_labels()],
#' `age_labels_tree()` includes `"Missing"` by default, since
#' most reporting trees in practice have a category for age not
#' stated.
#'
#' Labels are returned in the same order as
#' [age_set_order_tree()]: detailed age groups, then broad age
#' groups (each after the age groups inside it), then `"Missing"`.
#'
#' @inheritParams age_labels
#' @param nodes Labels for broad age groups. A character vector,
#' or `NULL` (the default), in which case there are no broad age
#' groups.
#' @param include_missing Whether to include a `"Missing"`
#' category, representing age not stated.
#' Default is `TRUE`.
#'
#' @return Character vector.
#'
#' @seealso
#' - [age_labels()] Create labels without broad age groups
#' - [age_set_order_tree()] Order existing labels as a tree
#' - [age_diagnose_values()] Check labels, including with
#'   `valid_tree = TRUE`
#'
#' @examples
#' ## census with 5-year and 10-year age groups,
#' ## age reported only as under or over 15,
#' ## and age not stated
#' age_labels_tree(
#'   breaks = c(0, 5, 10, 15, seq(20, 70, 10)),
#'   nodes = c("0-14", "15+")
#' )
#'
#' ## three levels, with leaves at different depths
#' age_labels_tree(
#'   breaks = seq(0, 85, 5),
#'   nodes = c("0-14", "15+", "15-64", "65+")
#' )
#'
#' ## no broad age groups, no "Missing"
#' age_labels_tree(
#'   breaks = seq(0, 20, 5),
#'   include_missing = FALSE
#' )
#' @export
age_labels_tree <- function(breaks,
                            nodes = NULL,
                            open_right = TRUE,
                            include_missing = TRUE) {
  check_flag(x = open_right, nm_x = "open_right")
  inner_labels_tree(
    breaks = breaks,
    nodes = nodes,
    label_type = "age",
    format_single = "lower",
    format_multi = "below_upper",
    is_open_left = FALSE,
    is_open_right = open_right,
    include_missing = include_missing
  )
}
