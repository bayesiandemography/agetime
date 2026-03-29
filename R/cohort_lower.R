
## HAS_TESTS
#' Lower Limits, Upper Limits, Widths,
#' and Midpoints of Cohorts
#'
#' Calculate lower limits, upper limits,
#' widths, and midpoints for cohorts.
#'
#' Lower and upper limits can be used
#' to filter on cohorts.
#' See below for examples.
#'
#' @param x A vector of cohort labels.
#' @param label_one Whether labels
#' for one-year cohorts are based on the
#' lower or upper limit of the period.
#' Default is `"lower"`.
#' @param label_multi Whether
#' labels for multi-year periods
#' include or exclude the final
#' year of the period.
#' Default is `"include"`.
#' @param unknown_label Action if a label
#' cannot be interpreted. Choices are
#' `"error"` (the default), `"warn"`,
#' and `"silent"`.
#'
#' @return A numeric vector with same length as `x`.
#'
#' @examples
#' x <- c("2025-2030", "<2025", "2030-2035")
#' cohort_lower(x)
#' cohort_upper(x)
#' cohort_width(x)
#' cohort_mid(x)
#'
#' ## use 'cohort_lower()' to filter on cohort
#' library(dplyr, warn.conflicts = FALSE)
#' df <- tribble(    ~cohort, ~count,
#'               "2025-2030",     20,
#'                   "<2025",      5,
#'               "2030-2035",     11 )
#' df
#' df |> filter(cohort_lower(cohort) >= 2025)
#'
#' ## 'label_one' is "lower" (the default)
#' cohort_lower("2025")
#' cohort_upper("2025")
#' cohort_width("2025")
#'
#' ## 'label_one' is "upper"
#' cohort_lower("2025", label_one = "upper")
#' cohort_upper("2025", label_one = "upper")
#' cohort_width("2025", label_one = "upper")
#' 
#' ## 'label_multi' is "include" (the default)
#' cohort_upper("2025-2030")
#' cohort_width("2025-2030")
#'
#' ## 'label_multi' is "exclude"
#' cohort_upper("2025-2030", label_multi = "exclude")
#' cohort_width("2025-2030", label_multi = "exclude")
#'
#' ## no action when 'unknown_label' is "silent"
#' cohort_lower(c("2000-2005", "long time ago"),
#'              unknown_label = "silent")
#' @export
cohort_lower <- function(x,
                         label_one = c("lower", "upper"),
                         label_multi = c("include", "exclude"),
                         unknown_label = c("error", "warn", "silent")) {
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  unknown_label <- match.arg(unknown_label)
  inner_lower(x = x,
              label_type = "cohort",
              label_one = label_one,
              label_multi = label_multi,
              unknown_label = unknown_label)
}


#' @export
#' @rdname cohort_lower
cohort_mid <- function(x,
                       label_one = c("lower", "upper"),
                       label_multi = c("include", "exclude"),
                       unknown_label = c("error", "warn", "silent")) {
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  unknown_label <- match.arg(unknown_label)
  inner_mid(x = x,
            label_type = "cohort",
            label_one = label_one,
            label_multi = label_multi,
            unknown_label = unknown_label)
}


#' @export
#' @rdname cohort_lower
cohort_upper <- function(x,
                         label_one = c("lower", "upper"),
                         label_multi = c("include", "exclude"),
                         unknown_label = c("error", "warn", "silent")) {
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  unknown_label <- match.arg(unknown_label)
  inner_upper(x = x,
              label_type = "cohort",
              label_one = label_one,
              label_multi = label_multi,
              unknown_label = unknown_label)
}


#' @export
#' @rdname cohort_lower
cohort_width <- function(x,
                         label_one = c("lower", "upper"), ## redundant, but keep so interface constant
                         label_multi = c("include", "exclude"),
                         unknown_label = c("error", "warn", "silent")) {
  label_one <- match.arg(label_one)
  label_multi <- match.arg(label_multi)
  unknown_label <- match.arg(unknown_label)
  inner_width(x = x,
              label_type = "cohort",
              label_one = label_one,
              label_multi = label_multi,
              unknown_label = unknown_label)
}
