# Extracted from test-coarsen-to.R:120

# test -------------------------------------------------------------------------
expect_error(
    age_coarsen_to("10", to = c("0-4", "5-9")),
    regexp = "Age group \"10\" is not fully covered by the labels in `to`."
  )
