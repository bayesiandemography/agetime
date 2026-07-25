#' Fill in Gaps in Cohort Levels
#'
#' @description
#' Add intermediate cohorts.
#'
#' The return value is a factor, and the intermediate
#' cohorts are added as factor levels.
#'
#' - `cohort_fill` adds cohorts specified by `breaks`.
#' - `cohort_fill_one` adds cohorts with width 1.
#' - `cohort_fill_five` adds cohorts with width 5.
#' - `cohort_fill_ten` adds cohorts with width 10.
#'
#' @inheritSection cohort_lower Controlling how cohort labels are interpreted
#'
#' @inheritParams cohort_lower
#' @param breaks Boundaries of newly-created cohorts.
#' Boundaries for existing cohorts can be omitted.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [age_fill()] Age equivalent of `cohort_fill()`
#' - [period_fill()] Period equivalent of `cohort_fill()`
#'
#' @examples
#' labels <- factor(c("2020-2025", "2030-2035"))
#' labels
#' cohort_fill(labels) ## uses existing boundaries
#' cohort_fill(labels, breaks = 2028)
#' cohort_fill_one(labels)
#' cohort_fill_five(labels)
#'
#' labels <- c("2051-2061", "2021-2031")
#' cohort_fill_ten(labels)
#'
#' ## levels are used by functions
#' ## such as 'table()'
#' labels |> table()
#' labels |>
#'   cohort_fill_ten() |>
#'   table()
#'
#' ## set level order after filling
#' labels |>
#'   cohort_fill_ten() |>
#'   cohort_set_order() |>
#'   table()
#' @export

# When length(labels) == 0 and there are no levels to fill,
# returns an empty factor.
# If breaks is supplied, levels are built from breaks. When
# length(labels) == 0 but labels
# is a factor with levels, levels() are still filled in. The ordered attribute
# is preserved when labels is an ordered factor.
cohort_fill <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}

#' @rdname cohort_fill
#' @export
cohort_fill_one <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}

#' @rdname cohort_fill
#' @export
cohort_fill_five <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}

#' @rdname cohort_fill
#' @export
cohort_fill_ten <- function(labels,
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
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
