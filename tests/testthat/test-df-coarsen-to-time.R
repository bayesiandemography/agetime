for (domain in c("period", "cohort")) {
  fun <- get(paste0(domain, "_df_coarsen_to"))
  run <- function(labels, target, ...) {
    data <- data.frame(value = seq_along(labels))
    data[[domain]] <- labels
    to <- data.frame(years = target)
    args <- list(data = data, to = to, by = NULL, ...)
    args[[domain]] <- setNames("years", domain)
    do.call(fun, args)
  }

  test_that(paste(domain, "data-frame helpers coarsen open and closed intervals"), {
    x <- c("<2000", "2000-2005", "2005-2010", "2010+")
    target <- c("<2000", "2000-2010", "2010+")
    result <- run(x, target)
    expect_identical(as.character(result[[domain]]),
                     c("<2000", "2000-2010", "2000-2010", "2010+"))
    expect_identical(result$value, 1:4)
    expect_identical(as.character(run(x, x)[[domain]]), x)
    expect_identical(as.character(run(c("<2000", "2000-2005"), "<2005")[[domain]]),
                     rep("<2005", 2))
    expect_error(run("2000-2005", "<2005"), "<2000")
    expect_error(run("<2000", "<2005"), "2000-2005")
    expect_error(run("2000-2005", "2000+"), "2005\\+")
    expect_error(run(c("2000-2007", "2007+"), c("2000-2010", "2010+")), "crosses a boundary")
    expect_error(run("2000-2005", c("2000-2005", "2000 to 2005")), "overlap")
  })

  test_that(paste(domain, "data-frame helpers respect endpoint interpretation"), {
    expect_identical(as.character(run(c(2000, 2001), "2000-2002")[[domain]]),
                     rep("2000-2002", 2))
    expect_identical(as.character(run(c(2001, 2002), "2000-2002",
                                       interpret_single = "upper")[[domain]]),
                     rep("2000-2002", 2))
    expect_error(run(c(2000, 2001), "2000-2002", interpret_single = "upper"), "outside")
    expect_error(run("2001", "2000-2002", interpret_single = "upper"), "2002")
    expect_identical(as.character(run(c("2000-2004", "2005-2009"), "2000-2009",
                                       interpret_multi = "below_upper")[[domain]]),
                     rep("2000-2009", 2))
    expect_error(run("2000-2004", "2000-2009", interpret_multi = "below_upper"), "2005-2009")
    expect_message(expect_error(run(c("2000-2004", "2005-2009"), "2000-2009"),
                                 "not fully covered"), "Interpreting")
    expect_error(run("2000+", "2000+", interpret_multi = "bad"), "arg")
    expect_error(run("2000+", "2000+", interpret_single = "bad"), "arg")
  })

  test_that(paste(domain, "group-specific targets ignore unused groups and factor levels"), {
    data <- data.frame(code = rep(c("A", "B"), each = 2), value = 1:4)
    data[[domain]] <- ordered(rep(c("2000-2005", "2005-2010"), 2),
                              levels = c("2000-2005", "2005-2010", "1900-1904", "young"))
    target <- data.frame(region = c("B", "B", "A", "C"),
                           years = factor(c("2000-2005", "2005-2010", "2000-2010", "young"),
                                           levels = c("2000-2005", "2005-2010", "2000-2010", "young", "1900-1904")))
    args <- list(data = data, to = target, by = c(code = "region"))
    args[[domain]] <- setNames("years", domain)
    expect_silent(result <- do.call(fun, args))
    expect_identical(as.character(result[[domain]]),
                     c("2000-2010", "2000-2010", "2000-2005", "2005-2010"))
    expect_true(is.ordered(result[[domain]]))
    expect_identical(result$value, data$value)
    expect_identical(levels(result[[domain]]), c("2000-2005", "2005-2010", "2000-2010"))
  })

  test_that(paste(domain, "parse and coverage errors name the requested caller"), {
    f <- function() {
      data <- data.frame(value = 1)
      data[[domain]] <- "2000-2005"
      args <- list(data = data, to = data.frame(years = "2000-2010"), by = NULL,
                    data_arg = "events", to_arg = "target", call = rlang::current_env())
      args[[domain]] <- setNames("years", domain)
      do.call(fun, args)
    }
    err <- expect_error(f(), "not fully covered")
    expect_identical(err$call[[1L]], quote(f))
    expect_match(conditionMessage(err), paste0("events$", domain), fixed = TRUE)
    expect_match(conditionMessage(err), "target$years", fixed = TRUE)
    expect_error(run("young", "2000+"), "Can't interpret")
    expect_error(run("2000+", "young", interpret_fail = "silent"), "does not describe an interval")
    expect_false(caller_env$active)
  })
}

test_that("default time interpretation messages are retained for each group", {
  for (domain in c("period", "cohort")) {
    fun <- get(paste0(domain, "_df_coarsen_to"))
    x <- data.frame(country = c("A", "B"))
    x[[domain]] <- "2000-2004"
    args <- list(data = x, to = x, by = "country")
    args[[domain]] <- domain
    messages <- character()
    result <- withCallingHandlers(do.call(fun, args), message = function(cnd) {
      messages <<- c(messages, conditionMessage(cnd))
      invokeRestart("muffleMessage")
    })
    expect_identical(as.character(result[[domain]]), x[[domain]])
    expect_length(messages, 2L)
    expect_true(all(grepl("Interpreting", messages)))
    args$interpret_multi <- "at_upper"
    expect_silent(explicit <- do.call(fun, args))
    expect_identical(explicit, result)
  }
})
