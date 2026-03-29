
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
                            label_one = c("lower", "upper"),
                            label_multi = c("include", "exclude"),
                            unknown_label = c("error", "warn", "silent")) {
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  unknown_label <- match.arg(unknown_label)
  inner_is_total(x = x,
                 label_type = "period",
                 label_one = label_one,
                 label_multi = label_multi,
                 unknown_label = unknown_label)
}
