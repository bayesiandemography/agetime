#' Mapping Has No Labels
#'
#' @param labels Vector of labels.
#' @returns `TRUE` when there are no labels in `labels`.
#'
#' @noRd
mapping_has_no_labels <- function(labels) {
  if (is.factor(labels)) {
    nlevels(labels) == 0L
  } else {
    length(labels) == 0L
  }
}
#' Mapping Empty
#'
#' @param format Output format for mappings.
#' @returns Empty mapping object in requested `format`.
#'
#' @noRd

mapping_empty <- function(format) {
  if (format == "tibble") {
    tibble::tibble(
      x = character(0),
      y = character(0)
    )
  } else {
    matrix(integer(0),
      nrow = 0L,
      ncol = 0L,
      dimnames = list(
        x = character(0),
        y = character(0)
      )
    )
  }
}
#' Inner Mapping
#'
#' @param labels_x Vector of labels.
#' @param labels_y Vector of labels to compare against `labels_x`.
#' @param relation Interval relation used to build mappings.
#' @param format Output format for mappings.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_multi Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns Mapping object in requested `format`.
#'
#' @noRd

inner_mapping <- function(labels_x,
                          labels_y,
                          relation,
                          format,
                          label_type,
                          interpret_single,
                          interpret_multi,
                          interpret_fail) {
  labels_x <- to_character_or_factor(
    labels = labels_x,
    nm_labels = "labels_x",
    length_zero_ok = TRUE
  )
  if (is.null(labels_y)) {
    labels_y <- labels_x
  } else {
    labels_y <- to_character_or_factor(
      labels = labels_y,
      nm_labels = "labels_y",
      length_zero_ok = TRUE
    )
  }
  if (mapping_has_no_labels(labels_x) || mapping_has_no_labels(labels_y)) {
    return(mapping_empty(format = format))
  }
  intervals_x <- intervals(
    labels = labels_x,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  intervals_y <- intervals(
    labels = labels_y,
    label_type = label_type,
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
  construct_mapping(
    intervals_x = intervals_x,
    intervals_y = intervals_y,
    relation = relation,
    format = format
  )
}
