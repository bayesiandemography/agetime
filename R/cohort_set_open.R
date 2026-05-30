
#' Define Open Cohort
#' 
#' Set an open cohort, i.e. a cohort with no
#' lower limit. Replace existing
#' cohorts where necessary.
#' 
#' @inheritParams cohort_lower
#' @param open Upper limit of open cohort.
#'
#' @return
#' A factor if `x` is a factor; otherwise a character vector.
#'
#' If no labels qualify for the open group (including when `x` is
#' `character(0)` or a factor with no levels), `x` is returned unchanged.
#' When `x` is a factor with levels but no element values, qualifying levels
#' are still relabelled.
#'
#' @examples
#' x <- c("2020-2024", "<2000", "2015")
#' cohort_set_open(x, open = 2020)
#' cohort_set_open(x, open = 2005)
#' @export
cohort_set_open <- function(x,
                            open,
                            x_one = c("lower", "upper"),
                            x_multi = c("include", "exclude"),
                            x_fail = c("error", "warn", "silent")) {
  x_fail <- match.arg(x_fail)
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  inner_set_open(x = x,
                 open = open,
                 make_open_left = FALSE,
                 make_open_right = TRUE,
                 label_type = "cohort",
                 x_one = x_one,
                 x_multi = x_multi,
                 x_fail = x_fail)
}
