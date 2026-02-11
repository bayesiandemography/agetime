
#' Age Group Matching
#'
#' Matching functions for age labels.
#' `age_match()` gives the positions of first matches.
#' `age_matched()` reports whether matches were found
#'
#' @section The `type` argument:
#'
#'  When `type` is `"equal"` (the default),
#'  an element of `x` matches an element of `table`
#'  if the element of `x` and the element of
#'  `table` have the same upper and lower limits,
#'  even if the labels differ. For instance,
#'  `"10-14"` matches `"10--14"` and "10to14"`.
#' 
#' When `type` is `"inside"`, an element
#' of `x` matches an element of `table` if
#' the element of `x` is contained by the element of `table`.
#' Labels can, again, differ.
#' For instance, `"10-14"` matches `"10to14" and `"10to19"`.
#'
#' @inheritParams age_lower
#' @param x Vector of age labels
#' @param table Vector of age labels
#' @param type Type of matching. `"equal"` (the default)
#' or `"inside"`.
#' @param nomatch Value to be returned
#' if no match is found. Default is `NA_integer_`.
#' 
#' @returns
#' - `age_match()` An integer vector giving the position
#'    in `table` of the first match if there is a match,
#'    and `nomatch` otherwise.
#' - `age_matched()` A logical vector indicating whether a match
#'   was found for each element of `x`.
#'
#' @seealso
#' - [period_match()] [match()] for period labels
#' - [cohort_match()] [match()] for cohort labels
#' - [age_mapping()] mapping between age group labels
#' - `age_matched()` is similar to base function
#'   [%in%][`%in%`].
#'
#' @examples
#' ## different labelling conventions
#' x <- c("0--4", "10--14", "100+")
#' tab <- c("0to4", "100plus")
#' age_match(x, tab)
#' age_matched(x, tab)
#'
#' ## 'type' argument
#' x <- c("10-14", "10")
#' tab <- "10-14"
#' age_matched(x, tab)
#' age_matched(x, tab, match = "inside")
#' @export
age_match <- function(x,
                      table,
                      type = c("equal", "inside"),
                      nomatch = NA_integer_,
                      invalid = c("error", "warn", "silent")) {
  x <- to_character_or_factor(x = x, nm_x = "x")
  table <- to_character_or_factor(x = table, nm_x = "table")
  type <- match.arg(type)
  invalid <- match.arg(invalid)
  intervals_x <- intervals(labels = x,
                           type = "age",
                           invalid = invalid)
  intervals_table <- intervals(labels = table,
                               type = "age",
                               invalid = invalid)
  make_match(intervals_x = intervals_x,
             intervals_table = intervals_table,
             type = type,
             nomatch = nomatch)
}
 

#' @rdname age_match
#' @export
age_matched <- function(x,
                        table,
                        type = c("equal", "inside"),
                        invalid = c("error", "warn", "silent")) {
  type <- match.arg(type)
  invalid <- match.arg(invalid)
  i <- age_match(x = x,
                 table = table,
                 type = type,
                 nomatch = 0L,
                 invalid = invalid)
  i > 0L
}
