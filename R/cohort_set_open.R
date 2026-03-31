
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
                            parse_one = c("lower", "upper"),
                            parse_multi = c("include", "exclude"),
                            parse_fail = c("error", "warn", "silent")) {
  parse_fail <- match.arg(parse_fail)
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  inner_set_open(x = x,
                 open = open,
                 make_open_left = FALSE,
                 make_open_right = TRUE,
                 label_type = "cohort",
                 parse_one = parse_one,
                 parse_multi = parse_multi,
                 parse_fail = parse_fail)
}
