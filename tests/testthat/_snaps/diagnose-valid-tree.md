# age_assert_values() with valid_tree returns labels or throws error

    Code
      age_assert_values(c("0-4", "5-9", "0-14"), valid_tree = TRUE)
    Condition
      Error in `age_assert_values()`:
      ! Age group labels fail check `valid_tree`.
      x `valid_tree`: Example: most detailed age groups do not reach upper limit of '0-14'.

