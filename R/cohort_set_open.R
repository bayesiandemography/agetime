
#' Define Open Cohort
#' 
#' Set an open cohort, i.e. a cohort with no
#' lower limit. Replace existing
#' cohorts where necessary.
#' 
#' @inheritParams cohort_lower
#' @param open Upper limit of open cohort.
#'
#' @returns Modified version of `x`.
#'
#' @examples
#' x <- c("2020-2024", "<2000", "2015")
#' cohort_set_open(x, open = 2020)
#' cohort_set_open(x, open = 2005)
#' @export
cohort_set_open <- function(x,
                            open,
                            label_one = c("lower", "upper"),
                            label_multi = c("include", "exclude"),
                            unknown_label = c("error", "warn", "silent")) {
  unknown_label <- match.arg(unknown_label)
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  inner_set_open(x = x,
                 open = open,
                 make_open_left = FALSE,
                 make_open_right = TRUE,
                 label_type = "cohort",
                 label_one = label_one,
                 label_multi = label_multi,
                 unknown_label = unknown_label)
}
