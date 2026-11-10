# Extracted from test-length-zero-extend.R:29

# test -------------------------------------------------------------------------
msg <- tryCatch(
    age_extend(character(0)),
    error = function(e) conditionMessage(e)
  )
expect_match(msg, "`labels` has length 0\\.")
