
## User-Visible Functions ------------------------------------------------------

#' Convert Age Group Labels to New Format
#'
#' @inheritParams age_labels
#' @param x Vector of age group labels.
#' @param invalid Action if meaning
#' of label unclear. Choices are
#' `"error"` (the default), `"warn"`,
#' and `"silent"`.
#'
#' @returns A factor with the same length as `x`.
#'
#' @examples
#' x <- factor(c("1-4", "87-89", "50-54"))
#' age_to(x, breaks = c(0, 50, 90))
#' @export
age_to <- function(x,
                   breaks,
                   open = TRUE,
                   include_total = NULL,
                   include_na = NULL,
                   invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  check_breaks(breaks)
  breaks <- as.integer(breaks)
  check_flag(x = open, nm_x = "open")
  invalid <- match.arg(invalid)
  intervals <- intervals(labels = x,
                         type = "age",
                         invalid = invalid)
  age_to_inner(x = x,
               breaks = breaks,
               open = open,
               include_total = include_total,
               include_na = include_na,
               intervals = intervals)
}



#' Convert Age Group Labels to Specific New Format
#'
#' @includeParams age_labels
#' @param lower_first Integer or NULL
#' @param lower_last Integer or NULL
#'
#' @returns A factor the same length as `x`.
#' 
#' @examples
#' x <- factor(c("1-4", "87-89", "50-54"))
#' age_to_five(x)
#' age_to_life(x)
#' age_to_ten(x)
#' age_to_ten(x, open = FALSE)
#'
#' x <- factor(c("0-9", "70+", "22"))
#' age_to_labor(x)
#' age_to_labor(x,
#'              age_work = 20,
#'              age_retire = 67)
#'
#' x <- c(NA, 1, 10, "Total")
#' age_to_five(x)
#' @export
age_to_one <- function(x,
                       lower_first = NULL,
                       lower_last = NULL,
                       open = TRUE,
                       include_total = NULL,
                       include_na = NULL,
                       invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  check_flag(x = open, nm_x = "open")
  invalid <- match.arg(invalid)
  intervals <- intervals(labels = x,
                         type = "age",
                         invalid = invalid)
  lower_first <- make_lower_first(lower_first = lower_first,
                                  intervals = intervals,
                                  open = open,
                                  min = 0L,
                                  divisible_by = 1L)
  lower_last <- make_lower_last(lower_last = lower_last,
                                intervals = intervals,
                                open = open,
                                min = 0L,
                                divisible_by = 1L)
  check_x_lt_y(x = lower_first,
               y = lower_last,
               nm_x = "lower_first",
               nm_y = "lower_last")
  to <- if (open) lower_last else lower_last + 1L
  breaks <- seq.int(from = lower_first,
                    to = to,
                    by = 1L)
  age_to_inner(x = x,
               breaks = breaks,
               open = open,
               include_total = include_total,
               include_na = include_na,
               intervals = intervals)
}


#' @rdname age_to_one
#' @export
age_to_five <- function(x,
                        lower_first = NULL,
                        lower_last = NULL,
                        open = TRUE,
                        include_total = NULL,
                        include_na = NULL,
                        invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  check_flag(x = open, nm_x = "open")
  invalid <- match.arg(invalid)
  intervals <- intervals(labels = x,
                         type = "age",
                         invalid = invalid)
  lower_first <- make_lower_first(lower_first = lower_first,
                                  intervals = intervals,
                                  open = open,
                                  min = 0L,
                                  divisible_by = 5L)
  lower_last <- make_lower_last(lower_last = lower_last,
                                intervals = intervals,
                                open = open,
                                min = 5L,
                                divisible_by = 5L)
  check_x_lt_y(x = lower_first,
               y = lower_last,
               nm_x = "lower_first",
               nm_y = "lower_last")
  to <- if (open) lower_last else lower_last + 5L
  breaks <- seq.int(from = lower_first,
                    to = to,
                    by = 5L)
  age_to_inner(x = x,
               breaks = breaks,
               open = open,
               include_total = include_total,
               include_na = include_na,
               intervals = intervals)
}

#' @rdname age_to_one
#' @export
age_to_ten <- function(x,
                        lower_first = NULL,
                        lower_last = NULL,
                        open = TRUE,
                        include_total = NULL,
                        include_na = NULL,
                        invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  check_flag(x = open, nm_x = "open")
  invalid <- match.arg(invalid)
  intervals <- intervals(labels = x,
                         type = "age",
                         invalid = invalid)
  lower_first <- make_lower_first(lower_first = lower_first,
                                  intervals = intervals,
                                  open = open,
                                  min = 0L,
                                  divisible_by = 10L)
  lower_last <- make_lower_last(lower_last = lower_last,
                                intervals = intervals,
                                open = open,
                                min = 10L,
                                divisible_by = 10L)
  check_x_lt_y(x = lower_first,
               y = lower_last,
               nm_x = "lower_first",
               nm_y = "lower_last")
  to <- if (open) lower_last else lower_last + 10L
  breaks <- seq.int(from = lower_first,
                    to = to,
                    by = 10L)
  age_to_inner(x = x,
               breaks = breaks,
               open = open,
               include_total = include_total,
               include_na = include_na,
               intervals = intervals)
}


#' @rdname age_to_one
#' @export
age_to_life <- function(x,
                        lower_last = NULL,
                        include_total = NULL,
                        include_na = NULL,
                        invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  invalid <- match.arg(invalid)
  intervals <- intervals(labels = x,
                         type = "age",
                         invalid = invalid)
  lower_last <- make_lower_last(lower_last = lower_last,
                                intervals = intervals,
                                open = TRUE,
                                min = 5L,
                                divisible_by = 5L)
  s <- seq.int(from = 5L,
               to = lower_last,
               by = 5L)
  breaks <- c(0L, 1L, s)
  age_to_inner(x = x,
               breaks = breaks,
               open = TRUE,
               include_total = include_total,
               include_na = include_na,
               intervals = intervals)
}


#' @rdname age_to_one
#' @export
age_to_labor <- function(x,
                         age_work = 20,
                         age_retire = 65,
                         include_total = NULL,
                         include_na = NULL,
                         invalid = c("error", "warn", "silent")) {
  poputils::check_n(n = age_work,
                    nm_n = "age_work",
                    min = 1L,
                    max = NULL,
                    divisible_by = 1L)
  poputils::check_n(n = age_retire,
                    nm_n = "age_retire",
                    min = 2L,
                    max = NULL,
                    divisible_by = 1L)
  check_x_lt_y(x = age_work,
               y = age_retire,
               nm_x = "age_work",
               nm_y = "age_retire")
  breaks <- c(0L, age_work, age_retire)
  invalid <- match.arg(invalid)
  age_to(x = x,
         breaks = breaks,
         open = TRUE,
         include_total = include_total,
         include_na = include_na,
         invalid = invalid)
}


## Internal Functions ---------------------------------------------------------

age_to_inner <- function(x,
                         breaks,
                         open,
                         include_total,
                         include_na,
                         intervals) {
  int_has_total <- has_total(intervals)
  int_has_na <- has_na(intervals)
  if (is.null(include_total))
    include_total <- int_has_total
  else {
    check_flag(x = include_total, nm_x = "include_total")
    if (!include_total && int_has_total)
      cli::cli_abort(paste("{.arg include_total} is {.val {include_total}}",
                           "but {.arg x} has totals."))
  }
  if (is.null(include_na))
    include_na <- int_has_na
  else {
    check_flag(x = include_na, nm_x = "include_na")
    if (!include_na && int_has_na)
      cli::cli_abort(paste("{.arg include_na} is {.val {include_na}}",
                           "but {.arg x} has NAs."))
  }
  levels_breaks <- make_levels_from_breaks(breaks = breaks,
                                           is_open_left = FALSE,
                                           is_open_right = open,
                                           labels_one = "lower",
                                           labels_multi = "exclude",
                                           include_total = include_total,
                                           include_na = include_na)
  m_contains <- make_m_contains(breaks = breaks,
                                levels_breaks = levels_breaks,
                                is_open_left = FALSE,
                                is_open_right = open,
                                include_total = include_total,
                                include_na = include_na,
                                intervals = intervals)
  check_m_contains(m_contains = m_contains,
                   type = "age")
  i_new <- apply(m_contains, 2L, which)
  i_x_to_xu <- get_i_x_to_xu(intervals)
  ans <- levels_breaks[i_new][i_x_to_xu]
  ans <- factor(x = ans,
                levels = levels_breaks,
                exclude = NULL)
  ans
}
