#' Create a New Set of Unique Age Labels
#'
#' @param breaks Boundaries between age groups.
#' A numeric vector.
#' @param open Whether the oldest age group
#' is "open", i.e. has no upper limit.
#' Default is `TRUE`.
#' @param lower_first The lower limit of the
#' youngest age group. 
#' @param lower_last The lower limit of the
#' last age group.
#' @param include_total Whether to include a
#' `"Total"` category.
#' @param include_na Whether to include
#' an `NA` category.
#'
#' @returns A character vector.
#'
#' @examples
#' ## default 5-year age groups
#' age_labels_five()
#'
#' ## open age group is 80+
#' age_labels_five(lower_last = 80)
#'
#' ## reproductive ages: 5-year
#' age_labels_five(lower_first = 15,
#'                 lower_last = 45,
#'                 open = FALSE)
#'
#' ## reproductive ages: 1-year
#' age_labels_one(lower_first = 15,
#'                lower_last = 49,
#'                open = FALSE)
#'
#' ## include total and NA
#' age_labels_five(lower_last = 20,
#'                 include_total = TRUE,
#'                 include_na = TRUE)
#' 
#' ## arbitrary age groups
#' age_labels(breaks = c(0, 5, 10, 14, 18),
#'            open = FALSE)
#'
#' ## life table age groups with
#' ## open age group of 75+
#' age_labels_life(lower_last = 75)
#'
#' ## labor force age groups
#' age_labels_labor()
#' age_labels_labor(age_retire = 67)
#' @export
age_labels <- function(breaks,
                       open = TRUE,
                       include_total = FALSE,
                       include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  inner_labels(breaks = breaks,
               x_one = "lower",
               x_multi = "exclude",
               is_open_left = FALSE,
               is_open_right = open,
               include_total = include_total,
               include_na = include_na)
}

#' @rdname age_labels
#' @export
age_labels_one <- function(lower_first = 0,
                           lower_last = 100,
                           open = TRUE,
                           include_total = FALSE,
                           include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  inner_labels_one(lower_first = lower_first,
                   lower_last = lower_last,
                   x_one = "lower",
                   x_multi = "exclude",
                   is_open_left = FALSE,
                   is_open_right = open,
                   include_total = include_total,
                   include_na = include_na)
}


#' @rdname age_labels
#' @export
age_labels_five <- function(lower_first = 0,
                            lower_last = 100,
                            open = TRUE,
                            include_total = FALSE,
                            include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  inner_labels_five(lower_first = lower_first,
                    lower_last = lower_last,
                    x_one = "lower",
                    x_multi = "exclude",
                    is_open_left = FALSE,
                    is_open_right = open,
                    include_total = include_total,
                    include_na = include_na)
}

#' @rdname age_labels
#' @export
age_labels_ten <- function(lower_first = 0,
                           lower_last = 100,
                           open = TRUE,
                           include_total = FALSE,
                           include_na = FALSE) {
  check_flag(x = open, nm_x = "open")
  inner_labels_ten(lower_first = lower_first,
                   lower_last = lower_last,
                   x_one = "lower",
                   x_multi = "exclude",
                   is_open_left = FALSE,
                   is_open_right = open,
                   include_total = include_total,
                   include_na = include_na)
}


#' @rdname age_labels
#' @export
age_labels_life <- function(lower_last = 100,
                            include_total = FALSE,
                            include_na = FALSE) {
  check_n(n = lower_last,
                    nm_n = "lower_last",
                    min = 5L,
                    max = NULL,
                    divisible_by = 5L)
  check_flag(x = include_total, nm_x = "include_total")
  check_flag(x = include_na, nm_x = "include_na")
  s <- seq(from = 5L,
           to = lower_last,
           by = 5L) 
  breaks <- c(0L, 1L, s)
  age_labels(breaks = breaks,
             open = TRUE,
             include_total = include_total,
             include_na = include_na)
}

#' @rdname age_labels
#' @export
age_labels_labor <- function(age_work = 20,
                             age_retire = 65,
                             include_total = FALSE,
                             include_na = FALSE) {
  check_n(n = age_work,
                    nm_n = "age_work",
                    min = 1L,
                    max = NULL,
                    divisible_by = 1L)
  check_n(n = age_retire,
                    nm_n = "age_retire",
                    min = 2L,
                    max = NULL,
                    divisible_by = 1L)
  check_x_lt_y(x = age_work,
               y = age_retire,
               nm_x = "age_work",
               nm_y = "age_retire")
  check_flag(x = include_total, nm_x = "include_total")
  check_flag(x = include_na, nm_x = "include_na")
  breaks <- c(0L, age_work, age_retire)
  age_labels(breaks = breaks,
             open = TRUE,
             include_total = include_total,
             include_na = include_na)
}



