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


#' Identify Open Periods
#'
#' Find periods that are open on the left or right.
#'
#' - `period_is_open_left()` finds periods open on the left
#'   (has no lower limit).
#' - `period_is_open_right()` finds periods open on the right
#'   (has no upper limit).
#'
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#'
#' @return Logical vector with the same length as `labels`.
#'
#' @seealso
#' - [period_is_total()] Identify period totals
#' - [period_set_open_left()] Specify open period
#' - [cohort_is_open_left()] Identify open cohort
#' - [age_is_open_right()] Identify open age group
#'
#' @examples
#' labels <- c("2020", "<1900", "2020-2030", "2030+")
#' period_is_open_left(labels)
#' period_is_open_right(labels)
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


#' @rdname period_is_open_left
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
