# Extracted from test-coarsen.R:264

# test -------------------------------------------------------------------------
expect_error(age_coarsen_five("90+", open_right = FALSE),
               "`labels` contains age group open on the right")
