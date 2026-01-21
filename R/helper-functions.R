

match_type <- function(type, variable, general_ok) {
    if (variable == "age")
        choices_nongen <- c("single",
                            "five",
                            "ten",
                            "lifetable")
    else
        choices_nongen <- c("single",
                            "five",
                            "ten",
                            "month",
                            "quarter")
    choices <- c(choices_nongen, "general")
    type <- match.arg(type, choices = choices)
    if (!general_ok && (type == "general"))
        cli::cli_abort(c("{.arg type} is {.val {type}}.",
                         i = "Valid options for {.arg type}: {.val {choices_valid}}."))
    type
}


## assume that limits is list with 'lower' and 'upper', both of which are numeric.

describe_limits <- function(limits) {
  lower <- limits$lower
  upper <- limits$upper
  dup <- duplicated(cbind(lower, upper))
  lower_unique <- lower[!dup]
  upper_unique <- upper[!dup]
  ord <- order(replace(lower_unique, which(is.na(lower_unique)), -Inf),
               replace(upper_unique, which(is.na(upper_unique)), Inf))
  lower_unique <- lower_unique[ord]
  upper_unique <- upper_unique[ord]
  i <- match(paste(lower, upper), paste(lower_unique, upper_unique))
  list(lower = lower,
       upper = upper,
       i = i)
  }
