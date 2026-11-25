# age_df_assert_values() with valid_tree returns labels or throws error

    Code
      age_df_assert_values(data.frame(age = c("0-4", "5-9", "0-14")), age = "age",
      valid_tree = TRUE)
    Condition
      Error in `age_df_assert_values()`:
      ! Age group labels in `data.frame(age = c("0-4", "5-9", "0-14"))$age` fail check `valid_tree`.
      x `valid_tree`: Example: most detailed age groups do not reach upper limit of '0-14'.
      i Use `age_df_diagnose_values()` to report checks for every group?

