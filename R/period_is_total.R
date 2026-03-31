
#' Identify Period Labels that Refer to Totals
#'
#' Find period labels that \pkg{agetime} interprets as totals.
#' 
#' @inheritParams period_lower
#'
#' @returns A logical vector the same length as `x`.
#'
#' @examples
#' x <- c("2020-2025", "Total", "1999", "ALL")
#' period_is_total(x)
#' @export
period_is_total <- function(x,
                            parse_one = c("lower", "upper"),
                            parse_multi = c("include", "exclude"),
                            parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_is_total(x = x,
                 label_type = "period",
                 parse_one = parse_one,
                 parse_multi = parse_multi,
                 parse_fail = parse_fail)
}
