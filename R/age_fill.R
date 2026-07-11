#' Fill in Gaps in Age Group Levels
#'
#' Fill in gaps in levels of `labels`.
#'
#' If `labels` is not a factor, and so does
#' not have levels, convert it to
#' a factor before filling in levels.
#'
#' - `age_fill` adds age groups
#'   specified by `breaks`.
#' - `age_fill_one` adds age groups with
#'   width 1.
#' - `age_fill_five` adds age groups with
#'   width 5.
#' - `age_fill_ten` adds age groups with
#'   width 10.
#' - `age_fill_life` adds age groups
#'   used by an abridged life table.
#'
#' @inheritSection age_check Abridged and complete life tables
#'
#' @inheritParams age_lower
#' @param breaks Boundaries of newly-created age groups.
#' Boundaries for existing age groups can be omitted.
#' @return Factor with the same length as `labels`.
#'
#' @seealso
#' - [period_fill()] Period equivalent of `age_fill()`
#' - [cohort_fill()] Cohort equivalent of `age_fill()`
#'
#' @examples
#' labels <- factor(c("0-4", "20-24"))
#' labels
#' age_fill(labels) ## uses existing boundaries
#' age_fill(labels, breaks = c(8, 12))
#' age_fill_one(labels)
#' age_fill_five(labels)
#'
#' labels <- c("25-29", "0-4")
#' age_fill_ten(labels)
#'
#' labels <- c("60+", "0")
#' age_fill_life(labels)
#'
#' ## levels are used by functions
#' ## such as 'table()'
#' labels <- c("30-39", "0-9")
#' labels |> table()
#' labels |>
#'   age_fill() |>
#'   table()
#'
#' ## sort after filling
#' labels |>
#'   age_fill() |>
#'   age_sort() |>
#'   table()
#' @export

# When length(labels) == 0 and there are no levels to fill,
# returns an empty factor.
# If breaks is supplied, levels are built from breaks. When
# length(labels) == 0 but labels
# is a factor with levels, levels() are still filled in. The ordered attribute
# is preserved when labels is an ordered factor.
age_fill <- function(labels,
                            breaks = NULL,
                            interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = breaks,
    width = NULL,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}

#' @rdname age_fill
#' @export
age_fill_one <- function(labels,
                                interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = NULL,
    width = 1L,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}

#' @rdname age_fill
#' @export
age_fill_five <- function(labels,
                                 interpret_fail = c(
                                   "error", "warn", "silent"
                                 )) {
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = NULL,
    width = 5L,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}

#' @rdname age_fill
#' @export
age_fill_ten <- function(labels,
                                interpret_fail = c("error", "warn", "silent")) {
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill(
    labels = labels,
    breaks = NULL,
    width = 10L,
    label_type = "age",
    interpret_single = "lower",
    interpret_multi = "exclude",
    interpret_fail = interpret_fail
  )
}


#' @rdname age_fill
#' @export
age_fill_life <- function(labels,
                                 interpret_fail = c(
                                   "error", "warn", "silent"
                                 )) {
  interpret_fail <- match.arg(interpret_fail)
  inner_levels_fill_life(
    labels = labels,
    interpret_fail = interpret_fail
  )
}
