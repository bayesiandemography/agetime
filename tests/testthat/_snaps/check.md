# assert error messages name each failed condition and give comments

    Code
      age_df_assert_values(data.frame(age = c("0-4", "3-7", "10-14")), age = "age",
      no_overlap = TRUE, no_gap = TRUE)
    Condition
      Error in `age_df_assert_values()`:
      ! Age group labels in `data.frame(age = c("0-4", "3-7", "10-14"))$age` fail checks `no_overlap` and `no_gap`.
      x `no_overlap`: Example of overlap among values: '0-4' and '3-7'.
      x `no_gap`: Example: gap among values below '10-14'.
      i Use `age_df_diagnose_values()` to report checks for every group?

---

    Code
      period_df_assert_values(data.frame(period = c("2020", "Total")), period = "period",
      no_total = TRUE)
    Condition
      Error in `period_df_assert_values()`:
      ! Period labels in `data.frame(period = c("2020", "Total"))$period` fail check `no_total`.
      x `no_total`: Example among values: 'Total'.
      i Use `period_df_diagnose_values()` to report checks for every group?

---

    Code
      cohort_df_assert_values(data.frame(cohort = c("2000-2004", "2005-2009")),
      cohort = "cohort", has_open_left = TRUE, interpret_multi = "at_upper")
    Condition
      Error in `cohort_df_assert_values()`:
      ! Cohort labels in `data.frame(cohort = c("2000-2004", "2005-2009"))$cohort` fail check `has_open_left`.
      x `has_open_left`: Lowest interval among values: '2000-2004'.
      i Use `cohort_df_diagnose_values()` to report checks for every group?

