
#' Check or Make Assertions About Age Groups
#'
#' Collect information on age group labels (`age_check()`),
#' or throw an error if age group labels do not
#' conform to expectations (`age_assert`).
#'
#' @inheritParams age_lower
#' @param no_overlap No age groups overlap
#' @param no_gap The age groups span the entire
#' range from the lower limit of the youngest age
#' group to the upper limit of the oldest age group
#' @param no_total No "Total" age group
#' @param no_na No NA age group
#' @param include_zero One or more age groups
#' have a lower limit of zero.
#' @param include_open One or more age groups
#' has no upper limit. 
#'
#' @returns
#' - `age_check()` returns a list with
#'   components `ok` (a logical flag)
#'   and `details` (a data frame).
#' - `age_assert()` returns `x` invisibly,
#'   or throws an error.
#'
#' @examples
#' lab <- age_labels_labor()
#' lab
#'
#' ## get info on everything
#' age_check(x = lab,
#'           no_overlap = TRUE,
#'           no_gap = TRUE,
#'           no_total = TRUE,
#'           no_na = TRUE,
#'           include_zero = TRUE,
#'           include_open = TRUE)
#'
#' ## throw error if gaps
#' age_assert(x = lab, no_gap = TRUE)
#'
#' lab_gap <- lab[c(1, 3)]
#' ## throw error if no gaps
#' age_assert(x = lab_gap, no_gap = FALSE)
#' @export
age_check <- function(x,
                      no_overlap = NA,
                      no_gap = NA,
                      no_total = NA,
                      no_na = NA,
                      include_zero = NA,
                      include_open = NA,
                      unknown_label = c("error", "warn", "silent")) {
  unknown_label <- match.arg(unknown_label)
  inner_check(x = x,
              label_type = "age",
              label_one = "lower",
              label_multi = "exclude",
              unknown_label = unknown_label,
              no_overlap = no_overlap,
              no_gap = no_gap,
              no_total = no_total,
              no_na = no_na,
              include_zero = include_zero,
              include_open = include_open)
}

#' @rdname age_check
#' @export
age_assert <- function(x,
                       no_overlap = NA,
                       no_gap = NA,
                       no_total = NA,
                       no_na = NA,
                       include_zero = NA,
                       include_open = NA,
                       unknown_label = c("error", "warn", "silent")) {
  unknown_label <- match.arg(unknown_label)
  inner_assert(x = x,
               label_type = "age",
               label_one = "lower",
               label_multi = "exclude",
               unknown_label = unknown_label,
               no_overlap = no_overlap,
               no_gap = no_gap,
               no_total = no_total,
               no_na = no_na,
               include_zero = include_zero,
               include_open = include_open)
}

