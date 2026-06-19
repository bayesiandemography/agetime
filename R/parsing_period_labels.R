#' Parsing Period Labels
#'
#' Parameters `x_one`, `x_multi`, and `x_fail` control how \pkg{agetime}
#' interprets period labels.
#'
#' @section `x_one`: Parsing one-year labels
#'
#' - `x_one` is `"lower"`. Label refers to lower limit.
#'    For instance, `"2030"` might be 1 January 2030 to 1 January 2031.
#' - `x_one` is `"upper"`. Label refers to upper limit.
#'   For instance, `"2030"` might be 30 June 2029 to 30 June 2030.
#'
#' @section `x_multi`: Parsing multi-year labels
#'
#' - `x_multi` is `"include"`. Label includes upper limit.
#'    For instance, `"2030-2035"` might be 30 June 2030 to 30 June 2035.
#' - `x_multi` is `"exclude"`. Label excludes upper limit.
#'    For instance, `"2030-2035"` might be 1 January 2030 to 1 January 2036.
#'
#' @section `x_fail`: Action if label cannot be parsed
#'
#' - `x_fail` is `"error"`. Throw an error.
#' - `x_fail` is `"warn"`. Throw a warning.
#' - `x_fail` is `"silent"`. Ignore the label and carry on.
#'
#' @seealso
#' - [parsing_cohort_labels()] Cohort equivalent of `parsing_period_labels()`
#'
#' @name parsing_period_labels
NULL
