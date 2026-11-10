# Extracted from test-coarsen-to.R:134

# test -------------------------------------------------------------------------
expect_error(
    age_coarsen_to("0-4", to = character(0)),
    regexp = "to.*has no labels"
  )
