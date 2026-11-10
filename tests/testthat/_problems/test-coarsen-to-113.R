# Extracted from test-coarsen-to.R:113

# test -------------------------------------------------------------------------
expect_error(
    age_coarsen_to("0-9", to = c("0-4", "5-9")),
    regexp = "Age group \"0-9\" would be split by the labels in `to`."
  )
