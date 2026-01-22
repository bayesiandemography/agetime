

## by_from_type_age <- function(type) {
##     switch(single = 1L,
##            five = 5L,
##            ten = 10L,
##            lifetable = cli::cli_abort("Internal error: {.val by} not defined for type {.val {type}}."),
##            cli::cli_abort("Internal error: Invalid value for {.arg type}}."))
## }
           
    

## Create_limits_age <- function(type, min, max, open) {
##     by <- switch(type,
##                  single = 1L,
##                  five = 5L,
##                  ten = 10L,
##                  cli::cli_abort("Internal error: {.arg type} is {.val {type}}."))
##     if ((max - min) %% by != 0L)
##         cli::cli_abort(c("Difference between {.arg max} and {.min min} not divisible by {.val {by}}.",
##                          i = "{.arg max}: {.val {max}}.",
##                          i = "{.arg min}: {.val {min}}.",
##                          i = "{.arg type}: {.val {type}}."))
##     s <- seq.int(from = min, by = by, to = max)
##     if (open) {
##         lower <- s
##         upper <- c(s[-1L], Inf)
##     }
##     else {
##         lower <- s[-length(s)]
##         upper <- s[-1L]
##     }
##     list(lower = lower,
##          upper = upper)
## }


## #' Create Age Labels from Limits
## #'
## #' Do not assume that elements in `limits` are ordered,
## #' unique, or complete.
## #'
## #' @param limits Named list with elements
## #' 'lower' and 'upper'
## #' @param is_factor Whether the return value
## #' should be a factor
## #'
## #' @returns A character vector or a factor
## #'
## #' @noRd
## labels_age <- function(limits, is_factor) {
##   l <- describe_limits(limits)
##   lower <- l$lower
##   upper <- l$upper
##   i <- l$i
##   is_open <- !is.na(lower) & is.na(upper)
##   is_closed <- !is.na(lower) & !is.na(upper)
##   is_single <- is_closed & (width == 1L)
##   is_lowup <- is_closed & !is_single
##   levels <- rep(NA_character_, times = length(lower))
##   levels[is_open] <- paste0(lower[is_open], "+")
##   levels[is_single] <- as.character(lower)
##   levels[is_lowup] <- paste0(lower[is_lowup], "-", upper[is_lowup] - 1L)
##   ans <- levels[i]
##   if (is_factor)
##     ans <- factor(ans, levels = levels, exclude = NULL)
## }

        


    
    


## #' Infer Lower and Upper Limits for Age Labels
## #'
## #' Parse an arbitrary set of age labels,
## #' and then infer the
## #' lower and upper bounds. If any labels cannot
## #' be parsed, raise an error. Otherwise, accept
## #' any set of labels. 
## #'
## #' @param x A vector or factor of arbitrary
## #' age labels.
## #' @param x Name for 'x' to be used in error messages.
## #'
## #' @returns A named list with elements 'lower'
## #' and 'upper'. Each element is an integer vector
## #' with the same length as 'x'.
## #'
## #' @noRd
## limits_age <- function(x, nm_x) {
##     check_vector_factor(x = x, nm_x = nm_x)
##     ## constants
##     p_single <- "^([0-9]+)$"
##     p_low_up <- "^([0-9]+)-([0-9]+)$"
##     p_open <- "^([0-9]+)\\+$"
##     ## deal with case where 'x' has no non-NA values
##     if (all(is.na(x))) {
##         val <- rep_int(NA_integer_, times = length(x))
##         ans <- list(lower = val, upper = val)
##         return(ans)
##     }
##     ## for efficiency, work with unique values
##     levels_old <- unique(x)
##     n_level <- length(levels_old)
##     ## attempt to translate to standard format
##     levels_new <- translate_age(levels_old)
##     ## classify levels
##     is_na <- is.na(levels_new)
##     is_single <- grepl(p_single, levels_new)
##     is_low_up <- grepl(p_low_up, levels_new)
##     is_open <- grepl(p_open, levels_new)
##     is_level_valid <- is_na | is_single | is_low_up | is_open
##     i_level_invalid <- match(FALSE, is_level_valid, nomatch = 0L)
##     if (i_level_invalid > 0L) {
##         level_invalid <- levels_old[[i_level_invalid]]
##         cli::cli_abort("Can't parse label {.val {level_invalid}}.")
##     }
##     ## characterise bounds
##     lower <- rep_int(NA_integer_, times = n_level)
##     lower[is_single] <- as.integer(sub(p_single, "\\1", levels_new[is_single]))
##     lower[is_low_up] <- as.integer(sub(p_low_up, "\\1", levels_new[is_low_up]))
##     lower[is_open] <- as.integer(sub(p_open, "\\1", levels_new[is_open]))
##     upper <- rep_int(NA_integer_, times = n_level)
##     upper[is_single] <- lower[is_single] + 1L
##     upper[is_low_up] <- as.integer(sub(p_low_up, "\\2", levels_new[is_low_up])) + 1L
##     upper[is_open] <- NA_integer_
##     ## map back to original levels
##     i <- match(levels_old, x)
##     list(lower = lower[i],
##          upper = upper[i])
## }



    
## #' Define Age Groups for New Age Group Type
## #'
## #' Assume that inputs have been checked,
## #' and conversion is feasible.
## #'
## #' @param limits_old Named list of vectors.
## #' @param type_new String.
## #'
## #' @returns A character vector.
## #'
## #' @noRd
## limits_new_age <- function(limits_old, type_new) {
##     lower_old <- limits_old$lower
##     upper_old <- limits_old$upper
##     if (type_new == "five") { ## possible 'type_old': "single" and "lifetable"
##         lower_new <- (lower_old %/% 5L) * 5L
##         upper_new <- lower_new + 5L
##     }
##     else if (type_new == "ten") { ## possible 'type_old': "single", "five", "lifetable"
##         lower_new <- (lower_old %/% 10L) * 10L
##         upper_new <- lower_new + 10L
##     }
##     else if (type_new = "lifetable") { ## possible 'type_old': "single"
##         lower_new <- (lower_old %/% 5L) * 5L
##         upper_new <- lower_old + 5L
##         lower_new[lower_old == 1L] <- 1L
##         upper_new[upper_old == 1L] <- 5L
##     }
##     else {
##         cli::cli_abort("Internal error: Invalid value for {.arg type_new}.")
##     }
##     list(lower = lower_new,
##          upper = upper_new)
## }


## HAS_TESTS
#' Try to Translate Age Labels to the 'agetime'
#' Standard Format
#'
#' Apply a series of text transformations
#' to try to convert x` into age group labels in the
#' style of [age_create()]. Transformations
#' are applied independently to each element of `x`.
#'
#' `NA`s are permitted, and propagate
#' through to the results.
#' 
#' @param x A vector or factor of arbitrary
#' age labels.
#'
#' @return A character vector.
#'
#' @noRd
translate_age <- function(x) {
    year <- "year|years|yr|yrs"
    infant <- "^infants$|^infant$|^in1st$|^lessthan1$|^under1$|^lessthanone$|^in1styear$|^0-0$|^0_0$"
    plus <- "andabove$|andmore$|andover$|andolder$|ormore$|orolder$|orover$|plus$|-$|_$|--$|__$"
    num <- c("zero", "one", "two", "three", "four",
             "five", "six", "seven", "eight", "nine")
    ## put everything into lower case
    x <- tolower(x)
    ## trim leading zeros from any numbers
    x <- gsub("(?<![0-9])0+(?=[0-9])", "", x, perl = TRUE)
    ## remove "year" labels
    x <- sub(year, "", x)
    ## remove spaces
    x <- gsub(" ", "", x)
    ## translate synonyms for age group "0"
    x <- sub(infant, "0", x)
    ## translate synonyms for "+"
    x <- sub(plus, "+", x)
    ## translate synonyms for "-"
    x <- sub("^([0-9]+)to([0-9]+)$", "\\1-\\2", x)
    x <- sub("^([0-9]+)[[:punct:]]+([0-9]+)$", "\\1-\\2", x)
    ## translate numbers
    for (i in seq_along(num))
        x <- gsub(num[[i]], i - 1L, x)
    ## return result
    x
}


## #' Infer Type of Age Labels, Possibly with Limits Supplied
## #'
## #' Helper function for user-visible function `age_type()',
## #' but with possibility of supplying pre-computed limits
## #' for labels.
## #'
## #' @param x Vector or factor of arbitrary age labels.
## #' @param nm_x Name for 'x' to be used in error messages.
## #' @param limits Output from function 'limits_age()',
## #' or NULL
## #'
## #' @returns A string
## #'
## #' @noRd
## type_age <- function(x, nm_x, limits) {
##     x_unique <- unique(x)
##     if (is.null(limits))
##         limits <- limits_age(x = x_unique, nm_x = nm_x)
##     if (is_overlap_open(limits))
##         return(FALSE)
##     width_closed <- width_closed(limits)
##     if (width_closed == 1L)
##         return("single")
##     if (width_closed == 5L)
##         return("five")
##     if (width_closed == 10L)
##         return("time")
##     if (is_widths_lifetable(limits))
##         return("lifetable")
##     if (is_no_gaps(limits))
##         return("general")
##     cli::cli_abort("{.arg nm_x} does conform to any age group type.")
## }


## width_closed <- function(limits) {
##     lower <- limits$lower
##     upper <- limits$upper
##     is_closed <- !is.na(lower) & !is.na(upper)
##     n_closed <- sum(is_closed)
##     if (n_closed == 0L)
##         return(0L)
##     widths <- upper[is_closed] - lower[is_closed]
##     if (n_closed == 1L)
##         return(widths)
##     if (all(widths[-1L] == widths[[1L]]))
##         widths[[1L]]
##     else
##         0L
## }


## is_width_lifetable <- function(limits) {
##     lower <- limits$lower
##     upper <- limits$upper
##     is_closed <- !is.na(lower) & !is.na(upper)
##     width <- upper - lower
##     is_0 <- is_closed & (lower == 0L)
##     if (any(width[is_0] != 1L))
##         return(FALSE)
##     is_1 <- is_closed & (lower == 1L)
##     if (any(width[is_1] != 4L))
##         return(FALSE)
##     if_5plus <- is_closed & (lower >= 5L)
##     if (any(width[is_5plus] != 5L))
##         return(FALSE)
##     TRUE
## }

        
## is_overlap_open <- function(limits) {
##     lower <- limits$lower
##     upper <- limits$upper
##     is_open <- !is.na(lower) & is.na(upper)
##     is_closed <- !is.na(lower) & !is.na(upper)
##     n_open <- sum(is_open)
##     if (n_open == 0L)
##         return(FALSE)
##     lower_open <- lower[is_open]
##     if (n_open >= 2L) {
##         if (any(lower_open[-1L] != lower_open[[1L]]))
##             return(TRUE)
##     }
##     min(lower_open) < max(upper[is_closed])
## }

## is_closed_widths_equal <- function(limits, target) {
##     lower <- limits$lower
##     upper <- limits$upper
##     widths <- upper - lower
##     is_closed <- !is.na(lower) & !is.na(upper)
##     widths_closed <- widths[is_closed]
##     all(widths_closed == target)
## }


## is_limits_age_single <- function(limits) {
##     is_closed <- is_closed_widths_equal(limits = limits, target = 1L)
##     no_overlap <- is_no_overlap_open(limits)
##     is_closed && no_overlap
## }


## is_limits_age_five <- function(limits) {
##     is_closed <- is_closed_widths_equal(limits = limits, target = )
##     no_overlap <- is_no_overlap_open(limits)
##     is_closed && no_overlap
## }





