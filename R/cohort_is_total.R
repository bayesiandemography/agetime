
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
                            label_one = c("lower", "upper"),
                            label_multi = c("include", "exclude"),
                            unknown_label = c("error", "warn", "silent")) {
  unknown_label <- match.arg(unknown_label)
  inner_is_total(x = x,
                 label_type = "cohort",
                 label_one = label_one,
                 label_multi = label_multi,
                 unknown_label = unknown_label)
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
                           label_one = c("lower", "upper"),
                           label_multi = c("include", "exclude"),
                           unknown_label = c("error", "warn", "silent")) {
  unknown_label <- match.arg(unknown_label)
  inner_is_open(x = x,
                label_type = "cohort",
                label_one = label_one,
                label_multi = label_multi,
                unknown_label = unknown_label,
                open = "left")
}

