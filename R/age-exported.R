

## #' Validity Checks for Age Group Labels
## #'
## #' @description
## #' 
## #' Check that age labels can be parsed and,
## #' optionally, whether the labels
## #'
## #' - use standard formatting
## #' - are complete
## #' - are unique
## #' - start at zero
## #' - include an open age group.
## #'
## #' @details
## #'
## #' By default, `age_check()` only tests whether
## #' a set of labels can be interpreted as one of the
## #' type described in [age_type()].
## #' However, it can also apply the following tests:
## #'
## #' - `standard`. Use "standard" formatting, ie
## #'   follow same conventions as [age_create()].
## #' - `complete`. Whether `x` includes
## #'   all intermediate age groups, with no gaps.
## #'   For instance, the labels `c("10-14", "15-19", "5-9")`
## #'   are complete, while the labels`c("15-19", "5-9")`
## #'   are not (because they are missing `"10-14"`.)
## #' - `unique`. Whether `x` has duplicated labels.
## #' - `zero`. Whether the youngest age group in `x` starts
## #'   at age 0, eg by including age group `"0-4"`.
## #' - `open`. Whether the oldest age group in `x` has an "open"
## #'   age group with no upper limit, such as `"100+"` or `"65+"`.
## #'
## #' @param x A vector of age labels.
## #' @param complete If `TRUE`,
## #' test whether `x` has gaps.
## #' @param unique If `TRUE`,
## #' test whether `x` has duplicates.
## #' @param zero If `TRUE`,
## #' test whether youngest age group in
## #' `x` starts at 0.
## #' @param open If `TRUE`,
## #' test whether oldest age group in `x`
## #' is open.
## #'
## #' @returns `TRUE`, invisibly, or raises an
## #' error if a test fails.
## #'
## #' @seealso
## #' - [age_format()] convert labels to standard format.
## #' - [age_type()] infer age group type.
## #' - [period_check()] equivalent function for periods.
## #' - [cohort_check()] equivalent function for cohorts.
## #'
## #' @examples
## #' age_check(c("10-14", "0-4", "15+"))
## #'
## #' try(
## #'   age_check(c("10-14", "0 to 4", "15+"),
## #'             standard = TRUE)  
## #' )
## #'
## #' try(
## #'   age_check(c("10-14", "0-4", "15+"),
## #'             complete = TRUE)  
## #' )
## #' 
## #' try(
## #'   age_check(c("10-14", "5-9", "0-4", "5-9", "15+"),
## #'             unique = TRUE)
## #' )
## #'
## #' try(
## #'   age_check(c("10-14", "5-9", "15+"),
## #'             zero = TRUE)
## #' )
## #'
## #' try(
## #'   age_check(c("10-14", "0-4", "5-9"),
## #'             open = TRUE)
## #' )
## #' @export
## age_check <- function(x,
##                       standard = FALSE,
##                       complete = FALSE,
##                       unique = FALSE,
##                       zero = FALSE,
##                       open = FALSE) {
##     check_flag(x = complete, nm_x = "complete")
##     check_flag(x = unique, nm_x = "unique")
##     check_flag(x = zero, nm_x = "zero")
##     check_flag(x = open, nm_x = "open")
##     age <- age_format(x)
##     levels_age <- age_complete(age)
##     n_age <- length(levels_age)
##     limits <- limits(levels_age)
##     if (standard) {
##         reformatted <- labels_age(limits = limits, is_factor = FALSE)
##         nonstandard <- setdiff(x, reformatted)
##         if (length(nonstandard) > 0L)
##             cli::cli_abort("Age group{?s} with non-standard formatting: {.val {nonstandard}}.")
##     }
##     if (complete) {
##         is_missing <- !(levels_age %in% age)
##         i_missing <- match(FALSE, is_missing, nomatch = 0L)
##         if (i_missing > 0L) {
##             age_missing <- levels_age[[i_missing]]
##             cli::cli_abort("Age group {.val {age_missing}} is missing.")
##         }
##     }
##     if (unique) {
##         is_dup <- duplicated(x)
##         i_dup <- match(TRUE, is_dup, nomatch = 0L)
##         if (i_dup > 0L) {
##             x_dup <- x[[i_dup]]
##             cli::cli_abort("Age group {.val {x_dup}} is duplicated.")
##         }
##     }
##     if (zero) {
##         lower <- limits$lower
##         if (lower[[1L]] != 0L) {
##             i_youngest <- match(levels_age[[1L]], age)
##             youngest <- x[[i_youngest]]
##             cli::cli_abort(c("Youngest age group does not start at 0.",
##                              i = "Youngest age group is {.val {youngest}}."))
##         }
##     }
##     if (open) {
##         upper <- limits$upper
##         if (is.finite(upper[[n_age]])) {
##             i_oldest <- match(levels_age[[n_age]], age)
##             oldest <- x[[i_oldest]]
##             cli::cli_abort(c("Oldest age group is not open.",
##                              i = "Oldest age group is {.val {oldest}}."))
##         }
##     }
##     invisible(TRUE)
## }

## #' Factor with Levels for Omitted Age Groups
## #'
## #' Create a factor that has levels 
## age_complete <- function(x) {
##     limits <- limits_age(x)
##     type <- type_age(x = x,
##                      nm_x = "x",
##                      limits = limits)
##     reformatted <- labels_age(limits = limits,
##                               is_factor = FALSE)
##     nonstandard <- setdiff(x, reformatted)
##     if (length(nonstandard) > 0L)
##         cli::cli_abort("Age group{?s} with non-standard formatting: {.val {nonstandard}}.")
##     lower <- limits$lower
##     upper <- limits$upper
##     if (type == "general") {
##         i <- match(sorted(unique(lower)), lower)
##         levels <- x[i]
##     }
##     else {
##         min <- min(lower, na.rm = TRUE)
##         max_upper <- max(upper, na.rm = TRUE)
##         open <- is.infinite(max_upper)
##         if (open)
##             max <- max(lower, na.rm = TRUE)
##         else
##             max <- max_upper
##         levels <- age_create(type = type,
##                              min = min,
##                              max = max,
##                              open = open)
##         has_na <- NA %in% lower
##         if (has_na)
##             levels <- c(levels, NA)
##     }
##     factor(x,
##            levels = levels,
##            exclude = character())
## }
        

## age_convert <- function(x, type) {
##     ## check arguments
##     check_vector_or_factor(x = x, nm_x = "x")
##     type_new <- match_type(type = type,
##                            variable = "age",
##                            general_ok = FALSE)
##     check_type_less_detailed_age(type_new = type_new,
##                                  type_old = type_old)
##     ## extract values
##     is_factor <- is.factor(x)
##     limits_old <- limits_age(x = x,
##                              nm_x = "x")
##     lower_old <- limits_old$lower
##     upper_old <- limits_old$upper
##     type_old <- type_age(x = x,
##                          nm_x = "x",
##                          limits = limits_old)
##     has_open <- any(is.infinite(upper_old))
##     ## deal with case where 'x' has no non-NA values
##     n_non_na <- sum(!is.na(x))
##     if (n_non_na == 0L)
##         return(x)
##     ## make new labels and return
##     limits_new <- limits_new_age(limits_old = limits_old,
##                                  type_new = type_new)
##     labels_age(limits = limits_new,
##                is_factor = is_factor)
## }
    
    

    
    
    
## age_create <- function(type, min = 0, max = 100, open = NULL) {
##     type <- match_type(type = type,
##                        variable = "age",
##                        general_ok = FALSE)
##     check_number(x = min,
##                  x_arg = "min",
##                  na_ok = FALSE,
##                  negative_ok = FALSE,
##                  zero_ok = TRUE,
##                  fraction_ok = FALSE)
##     check_number(x = max,
##                  x_arg = "max",
##                  na_ok = FALSE,
##                  negative_ok = FALSE,
##                  zero_ok = FALSE,
##                  fraction_ok = FALSE)
##     min <- as.integer(min)
##     max <- as.integer(max)
##     if (max < min)
##         cli::cli_abort(c("{.arg min} is less than {.arg max}",
##                          i = "{.arg min}: {.val {min}}.",
##                          i = "{.arg max}: {.val {max}}."))
##     if (is.null(open))
##         open <- min == 0L
##     else
##         check_flag(x = open, nm_x = "open")
##     if ((max == min) && !open)
##         cli::cli_abort(c("{.arg min} equals {.arg max}",
##                          i = "{.arg min}: {.val {min}}.",
##                          i = "{.arg min} can only equal {.arg max} if {.arg open} is {.val {TRUE}}"))
##     limits <- create_limits_age(type = type,
##                                 min = min,
##                                 max = max,
##                                 open = open)
##     labels_age(limits)
## }

## ## HAS_TESTS
## #' Put Age Group Labels into Standard Format
## #'
## #' @description
## #' 
## #' Reformat age group labels so they match the style
## #' used within **agetime**. For instance,
## #'
## #' - `"20 to 24 years"` is converted to `"20-24"`
## #' - `"infant"` is converted `"0"`
## #' - `"100 or more"` is convected to `"100+"`
## #'
## #' The age group labels must fit within one of the standard types
## #' described in [age_type()].
## #'
## #' @details
## #'
## #' When `x` consists entirely of numbers, `age_format()`
## #' checks for two special cases:
## #' 
## #' - If every element of `x` is a multiple of 5,
## #'   and if `max(x) >= 50`, then `x` is assumed to
## #'   describe 5-year age groups
## #' - If every element of `x` is 0, 1, or a multiple
## #'   of 5, with `max(x) >= 50`, then `x` is assumed
## #'   to describe life table age groups.
## #' 
## #' @param x A vector or factor.
## #'
## #' @return If `x` is a factor, then `age_format()`
## #' returns a factor. Otherwise it returns a 
## #' character vector.
## #'
## #' @seealso
## #' - [age_check()] for validity checks
## #' - [age_create()] to create age group labels from scratch
## #' - [age_type()] for definitions of age group types
## #' - [age_complete()] to fill in gaps in age group labels
## #' - [period_format()] to reformat period labels
## #' - [cohort_format()] to reformat cohort labels
## #' 
## #' @examples
## #' age_format(c("80 to 84", "90 or more", "85 to 89"))
## #' age_format(c("80", "90plus"))
## #' age_format(c(0, 35, 10, 1, 80))
## #' @export
## age_format <- function(x) {
##     check_vector_or_factor(x = x, nm_x = "x")
##     x <- translate_age(x)
##     limits <- limits_age(x = x, nm_x = "x")
##     type <- type_age(x = x, nm_x = "x", limits = limits)
##     labels_age(limits = limits, type = type)
## }
                     

## age_lower <- function(x) {
##     limits <- limits_age(x = x, nm_x = "x")
##     check_type_age(x = x, nm_x = "x", limits = limits)
##     limits$lower
## }


## age_mid <- function(x, mid_open = NULL) {
##     limits <- limits_age(x = x, nm_x = "x")
##     type <- type_age(x = x, nm_x = "x", limits = limits)
##     lower <- limits$lower
##     upper <- limits$upper
##     ans <- 0.5 * (lower + upper)
##     is_open <- is.infinite(upper)
##     if (any(is_open)) {
##         if (is.null(mid_open))
##             mid_open <- mid_open(type = type,
##                                  limits = limits)
##         else {
##             check_number(x = mid_open,
##                          nm_x = "mid_open",
##                          na_ok = FALSE,
##                          negative_ok = FALSE,
##                          zero_ok = TRUE,
##                          fraction_ok = TRUE)
##             lower_open <- lower[is_open][[1L]]
##             if (mid_open < lower_open)
##                 cli::cli_abort(c("{.arg mid_open} less than lower limit for open age group.",
##                                  i = "{.arg mid_open}: {.val {mid_open}}.",
##                                  i = "Lower limit for open age group: {.val {lower_open}}."))
##         }
##         ans[is_open] <- mid_open
##     }
##     ans
## }


## age_upper <- function(x) {
##     limits <- limits_age(x = x, nm_x = "x")
##     check_type_age(x = x, nm_x = "x", limits = limits)
##     limits$upper
## }

    
## #' Set Lower Limit for Oldest Age Group
## #'
## #' Set the lower limit of the oldest age group.
## #' This group is often open (ie has no upper limit)
## #' but does not have to be.
## #'
## #' `age_oldest()` requires that `x` and
## #' the return value have a
## #' a five-year, single-year, or life table format,
## #' as described in [age_labels()].
## #'
## #' @param x A vector of age labels.
## #' @param lower An integer. The lower limit
## #' for the open age group.
## #'
## #' @returns A modified version of `x`.
## #'
## #' @seealso
## #' - `set_age_open()` uses [age_lower()] to identify
## #' lower limits
## #' - [age_labels()] for creating age labels from scratch
## #'
## #' @examples
## #' x <- c("100+", "80-84", "95-99", "20-24")
## #' set_age_open(x, 90)
## #' set_age_open(x, 25)
## #' @export
## set_age_open <- function(x, lower) {
##     if (!is.vector(x) && !is.factor(x))
##         cli::cli_abort(c("{.arg x} is not a vector or factor.",
##                          i = "{.arg x} has class {.cls {class(x)}}."))
##     check_number(x = lower,
##                  x_arg = "lower",
##                  check_na = TRUE,
##                  check_positive = FALSE,
##                  check_nonneg = TRUE,
##                  check_whole = FALSE)
##     lower <- as.integer(lower)
##     if (is.factor(x)) {
##         levels_old <- levels(x)
##         levels_new <- set_age_open(x = levels_old, lower = lower)
##         x <- levels_new[match(x, levels_old)]
##         factor(x, levels = unique(levels_new), exclude = character())
##     }
##     else {
##         x <- as.character(x)
##         limits <- age_limits(x)
##         lower_old <- limits$lower
##         upper_old <- limits$upper
##         if (all(is.na(lower_old)) && all(is.na(upper_old)))
##             return(x)
##         is_open_old <- is.infinite(limits$upper)
##         if (any(is_open_old)) {
##             lower_open_old <- lower_old[is_open_old][[1L]]
##             if (lower > lower_open_old)
##                 stop(gettextf(paste("'%s' [%d] is greater than current lower limit",
##                                     "for open age group [%d]"),
##                               "lower",
##                               lower,
##                               lower_open_old),
##                      call. = FALSE)
##         }
##         x[lower_old >= lower] <- paste0(lower, "+")
##         val <- tryCatch(reformat_age(unique(x)),
##                         error = function(e) e)
##         if (inherits(val, "error"))
##             stop(gettext("new age groups are invalid"),
##                  call. = FALSE)
##         x
##     }
## }








## #' Infer Type of Age Labels
## #'
## #' Determine the "type" of a set of age labels.
## #'
## #' @section Age group types:
## #'
## #' **agetime** recognizes the following
## #' age group types:
## #'
## #' - `"single"`. One-year age groups, eg
## #'   `"0"` or `"55"`, and possibly
## #'   an open age group, eg `"100+"`.
## #' - `"five"`. Five-year age groups, eg
## #'   `"0-4"` or `"55-59"`, and possibly
## #'    an open age group, eg `"100+"`.
## #' - `"ten". Ten-year age groups, eg "0-9"
## #'   or `"50-59", and possibly an open
## #'   age group, eg `"100+"`.
## #' - `"lifetable"`. Age groups commonly used
## #'   in "abridged" life tables.
## #'   Identical to `"five"`, except that the
## #'   first age group is divided into `"0"` and
## #'   `"1-4"`.
## #' - `"general"`. All other age groups, provided
## #'   that they have no gaps or overlaps.
## #'
## #' @section Gaps:
## #'
## #' A vector of labels that belongs to age types
## #' `"single"`, `"five", `"ten"`, or `"lifetable"`
## #' is allowed to have gaps. For instance,
## #' ```
## #' c("0-4", "10-14", "15+")
## #' ```
## #' is a valid set of "five" age labels.
## #'
## #' In contrast, a vector of `"general"` age labels
## #' is not allowed to have gaps. For instance,
## #' ```
## #' c("0-4", "10-25", "15+")
## #' ```
## #' would not be a valid set of `"general"` age labels.
## #'
## #' @section Multiple valid types:
## #'
## #' When a set of age labels could belong to
## #' more than one type, `age_type()` uses
## #' preferences
## #'
## #' `single > five > ten > lifetable > general`.
## #'
## #' For instance, the age labels
## #' ```
## #' c("5-9", "10-14")
## #' ```
## #' are consistent with `"five"` and `"lifetable"`,
## #' but `age_type()` chooses `"five"`.
## #' 
## #'
## #' @param x A vector of age labels
## #'
## #' @returns `"single"`, `"five"`, `"ten", `"lifetable"`,
## #' or `"general"`, or raises an error.
## #'
## #' @examples
## #' age_type(c("5-9", "0-4", "100+"))
## #' age_type(c("2", "5", "1"))
## #' age_type(c("0", "1 to 4"))
## #' age_type(c("0--14", "15--59", "60 plus"))
## #'
## #' ## could be any "single" or "lifetable"
## #' age_type("0")
## #' @export
## age_type <- function(x) {
##     type_age(x = x,
##              nm_x = "x",
##              limits = NULL)
## }

