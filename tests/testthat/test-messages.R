## Message conventions (dev/messages.md), checked with the inventory
## script in dev/messages/. dev/ is not in the built package, so this test
## runs only from a source checkout.

test_that("messages follow the conventions in dev/messages.md", {
  skip_on_cran()
  skip_if_not_installed("codetools")
  root <- normalizePath(testthat::test_path("..", ".."))
  script <- file.path(root, "dev", "messages", "inventory.R")
  skip_if_not(file.exists(script), "dev/messages/inventory.R not found")
  env <- new.env()
  sys.source(script, envir = env)
  old <- setwd(root)
  on.exit(setwd(old), add = TRUE)
  fails <- env$check_inventory(env$build_inventory())
  expect_identical(
    sprintf("[%s] %s:%d %s", fails$check, fails$file, fails$text_line,
            fails$text),
    character()
  )
})
