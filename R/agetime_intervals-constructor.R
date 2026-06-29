#' Intervals
#'
#' @param labels Vector of labels.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_single Rule for one-year labels: `"lower"` or `"upper"`.
#' @param interpret_range Rule for multi-year labels: `"include"`
#' or `"exclude"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns An `agetime_intervals` object.
#'
#' @noRd
intervals <- function(labels,
                      label_type,
                      interpret_single,
                      interpret_range,
                      interpret_fail) {
  label_type <- match.arg(label_type, choices = c("age", "cohort", "period"))
  if (label_type == "age") {
    labels_normalizers <- make_labels_normalizers_age()
    label_parsers <- make_label_parsers_age()
  } else if (label_type == "cohort") {
    labels_normalizers <- make_labels_normalizers_cohort()
    label_parsers <- make_label_parsers_cohort(
      interpret_single = interpret_single,
      interpret_range = interpret_range
    )
  } else {
    labels_normalizers <- make_labels_normalizers_period()
    label_parsers <- make_label_parsers_period(
      interpret_single = interpret_single,
      interpret_range = interpret_range
    )
  }
  ans <- intervals_inner(
    labels = labels,
    labels_normalizers = labels_normalizers,
    label_parsers = label_parsers,
    label_type = label_type,
    interpret_fail = interpret_fail
  )
  ans
}

#' Intervals Inner
#'
#' @param labels Vector of labels.
#' @param labels_normalizers List of label normalizer functions.
#' @param label_parsers List of label parser functions.
#' @param label_type Label domain: `"age"`, `"cohort"`, or `"period"`.
#' @param interpret_fail How to handle unparsable labels.
#' @returns An `agetime_intervals` object.
#'
#' @noRd
intervals_inner <- function(labels,
                            labels_normalizers,
                            label_parsers,
                            label_type,
                            interpret_fail) {
  if (is.factor(labels)) {
    labels_unique <- levels(labels)
  } else {
    labels_unique <- unique(labels)
  }
  labels_unique_norm <- normalize_labels(
    labels = labels_unique,
    labels_normalizers = labels_normalizers
  )
  labels_unique_norm_unique <- unique(labels_unique_norm)
  i_x_to_xu <- match(labels, labels_unique)
  i_xun_to_xunu <- match(labels_unique_norm, labels_unique_norm_unique)
  i <- i_xun_to_xunu[i_x_to_xu]
  m <- vapply(labels_unique_norm_unique,
    FUN = x_label,
    FUN.VALUE = c(NA_real_, NA_real_),
    label_parsers = label_parsers,
    interpret_fail = interpret_fail
  )
  m <- t(m)
  ans <- list(
    labels_unique = labels_unique,
    labels_unique_norm_unique = labels_unique_norm_unique,
    m = m,
    i = i,
    i_x_to_xu = i_x_to_xu,
    i_xun_to_xunu = i_xun_to_xunu
  )
  class <- "agetime_intervals"
  class <- c(paste(class, label_type, sep = "_"), class)
  class(ans) <- class
  ans
}
