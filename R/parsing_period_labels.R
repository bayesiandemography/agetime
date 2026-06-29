#' Parsing Period Labels
#'
#' Parameters `interpret_single`, `interpret_range`, and `interpret_fail`
#' control how \pkg{agetime}
#' interprets period labels.
#'
#' @section `interpret_single`: Parsing one-year labels
#'
#' - `interpret_single` is `"lower"`. Label refers to lower limit.
#'    For instance, `"2030"` might be 1 January 2030 to 1 January 2031.
#' - `interpret_single` is `"upper"`. Label refers to upper limit.
#'   For instance, `"2030"` might be 30 June 2029 to 30 June 2030.
#'
#' @section `interpret_range`: Parsing multi-year labels
#'
#' - `interpret_range` is `"include"`. Label includes upper limit.
#'    For instance, `"2030-2035"` might be 30 June 2030 to 30 June 2035.
#' - `interpret_range` is `"exclude"`. Label excludes upper limit.
#'    For instance, `"2030-2035"` might be 1 January 2030 to 1 January 2036.
#'
#' @section `interpret_fail`: Action if label cannot be parsed
#'
#' - `interpret_fail` is `"error"`. Throw an error.
#' - `interpret_fail` is `"warn"`. Throw a warning.
#' - `interpret_fail` is `"silent"`. Ignore the label and carry on.
#'
#' @seealso
#' - [parsing_cohort_labels()] Cohort equivalent of `parsing_period_labels()`
#'
#' @name parsing_period_labels
NULL
