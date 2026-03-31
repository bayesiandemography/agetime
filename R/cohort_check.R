
#' Check or Make Assertions About Cohorts
#'
#' Collect information on cohort labels (`cohort_check()`),
#' or throw an error if cohort labels do not
#' conform to expectations (`cohort_assert`).
#'
#' @inheritParams cohort_lower
#' @param no_overlap No cohorts overlap
#' @param no_gap The cohorts span the entire
#' range from the lower limit of the earliest cohort
#' to the upper limit of the latest cohort
#' @param no_total No "Total" label
#' @param no_na No NA label
#' @param include_open One or more cohorts
#' has no lower limit. 
#'
#' @returns
#' - `cohort_check()` returns a list with
#'   components `ok` (a logical flag)
#'   and `details` (a data frame).
#' - `cohort_assert()` returns `x` invisibly,
#'   or throws an error.
#'
#' @examples
#' lab <- cohort_labels_five(lower_first = 2020,
#'                           lower_last = 2030)
#' lab
#'
#' ## get info on everything
#' cohort_check(x = lab,
#'              no_overlap = TRUE,
#'              no_gap = TRUE,
#'              no_total = TRUE,
#'              no_na = TRUE,
#'              include_open = TRUE)
#'
#' ## throw error if gaps
#' cohort_assert(x = lab, no_gap = TRUE)
#'
#' lab_gap <- lab[c(1, 3)]
#' ## throw error if no gaps
#' cohort_assert(lab_gap, no_gap = FALSE)
#' @export
cohort_check <- function(x,
                         no_overlap = NA,
                         no_gap = NA,
                         no_total = NA,
                         no_na = NA,
                         include_open = NA,
                         parse_one = c("lower", "upper"),
                         parse_multi = c("include", "exclude"),
                         parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_check(x = x,
              label_type = "cohort",
              parse_one = parse_one,
              parse_multi = parse_multi,
              parse_fail = parse_fail,
              no_overlap = no_overlap,
              no_gap = no_gap,
              no_total = no_total,
              no_na = no_na,
              include_zero = NA,
              include_open = include_open)
}

#' @rdname cohort_check
#' @export
cohort_assert <- function(x,
                          no_overlap = NA,
                          no_gap = NA,
                          no_total = NA,
                          no_na = NA,
                          include_open = NA,
                          parse_one = c("lower", "upper"),
                          parse_multi = c("include", "exclude"),
                          parse_fail = c("error", "warn", "silent")) {
  parse_one <- match.arg(parse_one)
  parse_multi <- match.arg(parse_multi)
  parse_fail <- match.arg(parse_fail)
  inner_assert(x = x,
               label_type = "age",
               parse_one = "lower",
               parse_multi = "exclude",
               parse_fail = parse_fail,
               no_overlap = no_overlap,
               no_gap = no_gap,
               no_total = no_total,
               no_na = no_na,
               include_zero = NA,
               include_open = include_open)
}

