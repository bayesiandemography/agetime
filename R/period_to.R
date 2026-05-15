
## User-Visible Functions ------------------------------------------------------

#' Convert Period Labels to New Format
#'
#' Modify a set of period labels by aggregating
#' periods or changing the .
#'
#' @inheritParams age_labels
#' @param x Vector of period labels.
#' @param x_fail Action if meaning
#' of label unclear. Choices are
#' `"error"` (the default), `"warn"`,
#' and `"silent"`.
#'
#' @returns
#' If `x` is a factor, then the return value is
#' a factor; otherwise it is a character vector.
#'
#' @examples
#' x <- c("2021-2024", "2017-2019", "2022")
#' period_to(x, breaks = c(2000, 2020, 2030))
#' @export
period_to <- function(x,
                      breaks,
                      open = TRUE,
                      x_one = c("lower", "upper"),
                      x_multi = c("include", "exclude"),
                      x_fail = c("error", "warn", "silent")) {
  x_one <- match.arg(x_one)
  x_multi <- match.arg(x_multi)
  x_fail <- match.arg(x_fail)
  inner_to(x = x,
           breaks = breaks,
           is_open_left = FALSE,
           is_open_right = FALSE,
           label_type = "period",
           x_one = x_one,
           x_multi = x_multi,
           x_fail = x_fail)
}

  

#' Convert Period Group Labels to Specialized Format
#'
#' @description
#' 
#' Modify a set of existing period group labels
#' so that it conforms to a specialised format.
#'
#' - `period_to_one` Single-year period groups
#' - `period_to_five` Five-year period groups
#' - `period_to_ten` Ten-year period groups
#'
#' @details
#'
#' @inheritParams period_labels
#' @param lower_first Lower limit of first period.
#' @param lower_last Lower limit of last period.
#'
#' @returns
#' If `x` is a factor, then the return value is
#' a factor; otherwise it is a character vector.
#' 
#' @examples
#' x <- c("2001-2003", "2007-2008", "2005"))
#' period_to_five(x, lower_first = 2000, lower_last = 2005)
#' period_to_five(x, lower_first = 2001, lower_last = 2006)
#' period_to_ten(x, lower_first = 1990, lower_last = 2010)
#' @export
period_to_one <- function(x,
                          lower_first = NULL,
                          lower_last = NULL,
                          x_one = c("lower", "upper"),
                          x_multi = c("include", "exclude"),
                          x_fail = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  check_flag(x = open, nm_x = "open")
  x_fail <- match.arg(x_fail)
  intervals <- intervals(labels = x,
                         label_type = "period",
                         x_fail = x_fail)
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
  period_to_inner(x = x,
                  breaks = breaks,
                  open = open,
                  include_total = include_total,
                  include_na = include_na,
                  intervals = intervals)
}


#' @rdname period_to_one
#' @export
period_to_five <- function(x,
                        lower_first = NULL,
                        lower_last = NULL,
                        open = TRUE,
                        include_total = NULL,
                        include_na = NULL,
                        x_fail = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  check_flag(x = open, nm_x = "open")
  x_fail <- match.arg(x_fail)
  intervals <- intervals(labels = x,
                         label_type = "period",
                         x_fail = x_fail)
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
  period_to_inner(x = x,
               breaks = breaks,
               open = open,
               include_total = include_total,
               include_na = include_na,
               intervals = intervals)
}

#' @rdname period_to_one
#' @export
period_to_ten <- function(x,
                        lower_first = NULL,
                        lower_last = NULL,
                        open = TRUE,
                        include_total = NULL,
                        include_na = NULL,
                        x_fail = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  check_flag(x = open, nm_x = "open")
  x_fail <- match.arg(x_fail)
  intervals <- intervals(labels = x,
                         label_type = "period",
                         x_fail = x_fail)
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
  period_to_inner(x = x,
               breaks = breaks,
               open = open,
               include_total = include_total,
               include_na = include_na,
               intervals = intervals)
}


#' @rdname period_to_one
#' @export
period_to_life <- function(x,
                        lower_last = NULL,
                        include_total = NULL,
                        include_na = NULL,
                        x_fail = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  x_fail <- match.arg(x_fail)
  intervals <- intervals(labels = x,
                         label_type = "period",
                         x_fail = x_fail)
  lower_last <- make_lower_last(lower_last = lower_last,
                                intervals = intervals,
                                open = TRUE,
                                min = 5L,
                                divisible_by = 5L)
  s <- seq.int(from = 5L,
               to = lower_last,
               by = 5L)
  breaks <- c(0L, 1L, s)
  period_to_inner(x = x,
               breaks = breaks,
               open = TRUE,
               include_total = include_total,
               include_na = include_na,
               intervals = intervals)
}


#' @rdname period_to_one
#' @export
period_to_labor <- function(x,
                            period_work = 20,
                            period_retire = 65,
                            include_total = NULL,
                            include_na = NULL,
                            x_fail = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  check_n(n = period_work,
          nm_n = "period_work",
          min = 1L,
          max = NULL,
          divisible_by = 1L)
  check_n(n = period_retire,
          nm_n = "period_retire",
          min = 2L,
          max = NULL,
          divisible_by = 1L)
  check_x_lt_y(x = period_work,
               y = period_retire,
               nm_x = "period_work",
               nm_y = "period_retire")
  breaks <- c(0L, period_work, period_retire)
  x_fail <- match.arg(x_fail)
  period_to(x = x,
            breaks = breaks,
            open = TRUE,
            include_total = include_total,
            include_na = include_na,
            x_fail = x_fail)
}


## Internal Functions ---------------------------------------------------------

period_to_inner <- function(x,
                         breaks,
                         open,
                         include_total,
                         include_na,
                         intervals) {
  int_has_total <- int_has_total(intervals)
  int_has_na <- int_has_na(intervals)
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
                                           x_one = "lower",
                                           x_multi = "exclude",
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
                   label_type = "period")
  i_new <- apply(m_contains, 2L, which)
  i_x_to_xu <- get_i_x_to_xu(intervals)
  ans <- levels_breaks[i_new][i_x_to_xu]
  ans <- factor(x = ans,
                levels = levels_breaks,
                exclude = NULL)
  ans
}
