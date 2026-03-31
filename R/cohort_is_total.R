
#' Identify Cohort Labels that Refer to Totals
#'
#' Find cohort labels that \pkg{agetime} interprets as totals.
#' 
#' @inheritParams cohort_lower
#'
#' @returns A logical vector the same length as `x`.
#'
#' @examples
#' x <- c("2020-2025", "Total", "1999", "ALL")
#' cohort_is_total(x)
#' @export
cohort_is_total <- function(x, 
                            parse_one = c("lower", "upper"),
                            parse_multi = c("include", "exclude"),
                            parse_fail = c("error", "warn", "silent")) {
  parse_fail <- match.arg(parse_fail)
  inner_is_total(x = x,
                 label_type = "cohort",
                 parse_one = parse_one,
                 parse_multi = parse_multi,
                 parse_fail = parse_fail)
}


#' Identify Labels that Refer to Open Cohorts
#'
#' Find cohort labels that \pkg{agetime} interprets as
#' open, ie as having no lower limit.
#' 
#' @inheritParams cohort_lower
#'
#' @returns A logical vector the same length as `x`.
#'
#' @examples
#' x <- c("2020", "<1900", "2040-2050", "<2022")
#' cohort_is_open(x)
#' @export
cohort_is_open <- function(x, 
                           parse_one = c("lower", "upper"),
                           parse_multi = c("include", "exclude"),
                           parse_fail = c("error", "warn", "silent")) {
  parse_fail <- match.arg(parse_fail)
  inner_is_open(x = x,
                label_type = "cohort",
                parse_one = parse_one,
                parse_multi = parse_multi,
                parse_fail = parse_fail,
                check_open_left = TRUE,
                check_open_right = FALSE)
}

