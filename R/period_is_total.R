#' Identify Period Labels for Totals
#'
#' Find "total" categories in period labels.
#'
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [age_is_total()] Age equivalent of `period_is_total()`
#' - [cohort_is_total()] Cohort equivalent of `period_is_total()`
#'
#' @examples
#' labels <- c("2020-2025", "Total", "1999", "ALL")
#' period_is_total(labels)
#' @export

# When length(labels) == 0, returns logical(0).
period_is_total <- function(labels,
                            interpret_single = c("lower", "upper"),
                            interpret_multi = c("include", "exclude"),
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_is_total(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}


#' Identify Periods Open on Left
#'
#' Find periods that are open on the left, i.e., that have no lower limit.
#'
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [period_is_total()] Find period labels for totals
#' - [period_is_open_right()] Find right-open periods
#' - [cohort_is_open_left()] Cohort equivalent of `period_is_open_left()`
#'
#' @examples
#' labels <- c("2020", "<1900", "2020-2030", "2030+")
#' period_is_open_left(labels)
#' @export

# When length(labels) == 0, returns logical(0).
period_is_open_left <- function(labels,
                                interpret_single = c("lower", "upper"),
                                interpret_multi = c("include", "exclude"),
                                interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_is_open(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    check_open_left = TRUE,
    check_open_right = FALSE
  )
}


#' Identify Periods Open on Right
#'
#' Find periods that are open on the right, i.e., that have no upper limit.
#'
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [period_is_total()] Find period labels for totals
#' - [period_is_open_left()] Find periods open on left
#' - [age_is_open_right()] Age equivalent of `period_is_open_right()`
#' - [cohort_is_open_right()] Cohort equivalent of `period_is_open_right()`
#'
#' @examples
#' labels <- c("2020", "<1900", "2020-2030", "2030+")
#' period_is_open_right(labels)
#' @export

# When length(labels) == 0, returns logical(0).
period_is_open_right <- function(labels,
                                 interpret_single = c("lower", "upper"),
                                 interpret_multi = c("include", "exclude"),
                                 interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_is_open(
    labels = labels,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail,
    check_open_left = FALSE,
    check_open_right = TRUE
  )
}
