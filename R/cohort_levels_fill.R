#' Fill in Gaps in Cohort Levels
#'
#' Fill in gaps in levels of `labels`.
#'
#' If `labels` is not a factor, and so does
#' not have levels, convert it to
#' a factor before filling in levels.
#'
#' - `cohort_levels_fill` adds cohorts
#'   specified by `breaks`.
#' - `cohort_levels_fill_one` adds cohorts with
#'   width 1.
#' - `cohort_levels_fill_five` adds cohorts with
#'   width 5.
#' - `cohort_levels_fill_ten` adds cohorts with
#'   width 10.
#'
#' @inheritParams cohort_lower
#' @param breaks Boundaries of newly-created cohorts.
#' Boundaries for existing cohorts can be omitted.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [parsing_cohort_labels()] Interpretation details for cohort labels
#' - [age_levels_fill()] Age equivalent of `cohort_levels_fill()`
#' - [period_levels_fill()] Period equivalent of `cohort_levels_fill()`
#'
#' @examples
#' labels <- factor(c("2020-2025", "2030-2035"))
#' labels
#' cohort_levels_fill(labels) ## uses existing boundaries
#' cohort_levels_fill(labels, breaks = 2028)
#' cohort_levels_fill_one(labels)
#' cohort_levels_fill_five(labels)
#'
#' labels <- c("2051-2061", "2021-2031")
#' cohort_levels_fill_ten(labels)
#'
#' ## levels are used by functions
#' ## such as 'table()'
#' labels |> table()
#' labels |>
#'   cohort_levels_fill_ten() |>
#'   table()
#'
#' ## sort after filling
#' labels |>
#'   cohort_levels_fill_ten() |>
#'   cohort_levels_sort() |>
#'   table()
#' @export

# When length(labels) == 0 and there are no levels to fill,
# returns an empty factor.
# If breaks is supplied, levels are built from breaks. When
# length(labels) == 0 but labels
# is a factor with levels, levels() are still filled in. The ordered attribute
# is preserved when labels is an ordered factor.
cohort_levels_fill <- function(labels,
                               breaks = NULL,
                               interpret_single = c("lower", "upper"),
                               interpret_range = c("include", "exclude"),
                               interpret_fail = c("error", "warn", "silent")) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = breaks,
    width = NULL,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}

#' @rdname cohort_levels_fill
#' @export
cohort_levels_fill_one <- function(labels,
                                   interpret_single = c("lower", "upper"),
                                   interpret_range = c("include", "exclude"),
                                   interpret_fail = c(
                                     "error", "warn", "silent"
                                   )) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = NULL,
    width = 1L,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}

#' @rdname cohort_levels_fill
#' @export
cohort_levels_fill_five <- function(labels,
                                    interpret_single = c("lower", "upper"),
                                    interpret_range = c("include", "exclude"),
                                    interpret_fail = c(
                                      "error", "warn", "silent"
                                    )) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = NULL,
    width = 5L,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}

#' @rdname cohort_levels_fill
#' @export
cohort_levels_fill_ten <- function(labels,
                                   interpret_single = c("lower", "upper"),
                                   interpret_range = c("include", "exclude"),
                                   interpret_fail = c(
                                     "error", "warn", "silent"
                                   )) {
  interpret_single <- match.arg(interpret_single)
  interpret_range <- match.arg(interpret_range)
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = NULL,
    width = 10L,
    label_type = "cohort",
    interpret_single = interpret_single,
    interpret_range = interpret_range,
    interpret_fail = interpret_fail
  )
}
