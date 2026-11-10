# Extracted from test-coarsen-to.R:127

# test -------------------------------------------------------------------------
expect_error(
    age_coarsen_to(c("0", "Total"), to = c("0-4", "5-9")),
    regexp = "`to` has no category for \"Total\"."
  )
