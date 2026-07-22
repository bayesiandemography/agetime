#' Fill in Gaps in Period Levels
#'
#' @description
#' Add intermediate periods.
#'
#' The return value is a factor, and the intermediate
#' periods are added as factor levels.
#'
#' - `period_fill` adds periods specified by `breaks`.
#' - `period_fill_one` adds periods with width 1.
#' - `period_fill_five` adds periods with width 5.
#' - `period_fill_ten` adds periods with width 10.
#'
#' @inheritSection period_lower Controlling how period labels are interpreted
#'
#' @inheritParams period_lower
#' @param breaks Boundaries of newly-created periods.
#' Boundaries for existing periods can be omitted.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [age_fill()] Age equivalent of `period_fill()`
#' - [cohort_fill()] Cohort equivalent of `period_fill()`
#'
#' @examples
#' labels <- factor(c("2020-2025", "2030-2035"))
#' labels
#' period_fill(labels) ## uses existing boundaries
#' period_fill(labels, breaks = 2028)
#' period_fill_one(labels)
#' period_fill_five(labels)
#'
#' labels <- c("2051-2061", "2021-2031")
#' period_fill_ten(labels)
#'
#' ## levels are used by functions
#' ## such as 'table()'
#' labels |> table()
#' labels |>
#'   period_fill_ten() |>
#'   table()
#'
#' ## sort after filling
#' labels |>
#'   period_fill_ten() |>
#'   period_sort() |>
#'   table()
#' @export

# When length(labels) == 0 and there are no levels to fill,
# returns an empty factor.
# If breaks is supplied, levels are built from breaks. When
# length(labels) == 0 but labels
# is a factor with levels, levels() are still filled in. The ordered attribute
# is preserved when labels is an ordered factor.
period_fill <- function(labels,
                               breaks = NULL,
                               interpret_single = c("lower", "upper"),
                               interpret_multi = c("include", "exclude"),
                               interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = breaks,
    width = NULL,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}

#' @rdname period_fill
#' @export
period_fill_one <- function(labels,
                                   interpret_single = c("lower", "upper"),
                                   interpret_multi = c("include", "exclude"),
                                   interpret_fail = c(
                                     "error", "warn", "silent"
                                   )) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = NULL,
    width = 1L,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}

#' @rdname period_fill
#' @export
period_fill_five <- function(labels,
                                    interpret_single = c("lower", "upper"),
                                    interpret_multi = c("include", "exclude"),
                                    interpret_fail = c(
                                      "error", "warn", "silent"
                                    )) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = NULL,
    width = 5L,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}

#' @rdname period_fill
#' @export
period_fill_ten <- function(labels,
                                   interpret_single = c("lower", "upper"),
                                   interpret_multi = c("include", "exclude"),
                                   interpret_fail = c(
                                     "error", "warn", "silent"
                                   )) {
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = NULL,
    width = 10L,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
