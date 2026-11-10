## Names of arguments and calling function in messages (x_arg, call)

wrapper_lower <- function(standard) {
  age_lower(standard$age, x_arg = "standard$age", call = rlang::current_env())
}

test_that("by default, messages name the expression supplied and the function", {
  x <- c("10", "abc")
  cnd <- tryCatch(age_lower(x), error = function(e) e)
  expect_match(conditionMessage(cnd), "Can't interpret labels in `x`.", fixed = TRUE)
  expect_identical(deparse(cnd$call[[1L]]), "age_lower")
})

test_that("supplied x_arg and call are used in messages", {
  cnd <- tryCatch(wrapper_lower(data.frame(age = c("10", "abc"))), error = function(e) e)
  expect_match(conditionMessage(cnd), "Can't interpret labels in `standard$age`.", fixed = TRUE)
  expect_identical(deparse(cnd$call[[1L]]), "wrapper_lower")
  expect_snapshot(wrapper_lower(data.frame(age = c("10", "abc"))), error = TRUE)
})

test_that("registration is cleared after an error", {
  try(wrapper_lower(data.frame(age = "abc")), silent = TRUE)
  y <- "abc"
  cnd <- tryCatch(age_upper(y), error = function(e) e)
  expect_match(conditionMessage(cnd), "in `y`", fixed = TRUE)
  expect_identical(deparse(cnd$call[[1L]]), "age_upper")
  expect_false(caller_env$active)
})

test_that("registration is cleared after success", {
  expect_identical(age_lower(c("0-4", "5+")), c(0, 5))
  expect_false(caller_env$active)
})

test_that("warnings name the calling function", {
  f <- function(x) age_lower(x, interpret_fail = "warn", x_arg = "data$age",
                             call = rlang::current_env())
  expect_snapshot(ans <- f(c("0-4", "abc")))
  expect_identical(ans, c(0, NA))
})

test_that("age_coarsen_to() names labels and to", {
  f <- function(standard, ages) {
    age_coarsen_to(standard$age, to = ages,
                   x_arg = "standard$age", to_arg = "ages",
                   call = rlang::current_env())
  }
  expect_snapshot(f(data.frame(age = c("10-14", "15-19")), age_labels(breaks = seq(0, 20, by = 4))),
                  error = TRUE)
  expect_snapshot(f(data.frame(age = "10-14"), c("0-9", "abc")), error = TRUE)
})

test_that("age_mapping() names labels_x and labels_y", {
  f <- function(a, b) age_mapping(a, b, x_arg = "a_lab", y_arg = "b_lab",
                                  call = rlang::current_env())
  cnd <- tryCatch(f("abc", "0-4"), error = function(e) e)
  expect_match(conditionMessage(cnd), "in `a_lab`", fixed = TRUE)
  cnd <- tryCatch(f("0-4", "abc"), error = function(e) e)
  expect_match(conditionMessage(cnd), "in `b_lab`", fixed = TRUE)
  expect_identical(deparse(cnd$call[[1L]]), "f")
})

test_that("functions with other errors use x_arg and call", {
  f <- function(x) age_coarsen_five(x, open_right = FALSE, x_arg = "data$age",
                                    call = rlang::current_env())
  expect_snapshot(f("90+"), error = TRUE)
  g <- function(x) age_extend(x, x_arg = "data$age", call = rlang::current_env())
  expect_snapshot(g(c("0-4", "Total")), error = TRUE)
  h <- function(x) period_set_open_left(x, at = 2002, x_arg = "data$time",
                                        call = rlang::current_env())
  cnd <- tryCatch(h(c("2000-2005", "2005-2010")), error = function(e) e)
  expect_identical(deparse(cnd$call[[1L]]), "h")
})

test_that("diagnose functions use x_arg", {
  expect_error(age_diagnose_levels("0-4", x_arg = "data$age"),
               "`data$age` is not a factor", fixed = TRUE)
  expect_error(age_diagnose_values(c("0-4", "abc"), x_arg = "data$age"),
               "Can't interpret labels in `data$age`", fixed = TRUE)
})

test_that("assert functions name x_arg in parse errors", {
  f <- function(x) age_assert_values(x, x_arg = "data$age", call = rlang::current_env())
  expect_snapshot(f(c("0-4", "abc")), error = TRUE)
})

test_that("invalid x_arg and call are errors", {
  expect_error(age_lower("0-4", x_arg = NULL), "`labels` must be a single string")
  expect_error(age_lower("0-4", x_arg = c("a", "b")), "`labels` must be a single string")
  expect_error(age_lower("0-4", call = "wrong"), "`call` must be an environment")
})
