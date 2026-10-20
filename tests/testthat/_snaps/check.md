# assert error messages name each failed condition and give comments

    Code
      age_assert(c("0-4", "3-7", "10-14"), no_overlap = TRUE, no_gap = TRUE)
    Condition
      Error in `age_assert()`:
      ! Age group labels fail checks `no_overlap` and `no_gap`.
      x `no_overlap`: Example of overlap among levels: '0-4' and '3-7'.
      x `no_gap`: Example: gap among levels below '10-14'.

---

    Code
      period_assert_values(c("2020", "Total"), no_total = TRUE)
    Condition
      Error in `period_assert_values()`:
      ! Period labels fail check `no_total`.
      x `no_total`: Example among values: 'Total'.

---

    Code
      cohort_assert(c("2000-2004", "2005-2009"), has_open_left = TRUE)
    Condition
      Error in `cohort_assert()`:
      ! Cohort labels fail check `has_open_left`.
      x `has_open_left`: Lowest interval among levels: '2000-2004'.

