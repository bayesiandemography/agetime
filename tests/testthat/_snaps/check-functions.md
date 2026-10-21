# check_m_contains() distinguishes split labels from labels not covered

    Code
      agetime:::check_m_contains(m_contains, m_new = rbind(c(0, 7), c(7, 10)), m_old = rbind(
        c(5, 10), c(10, 15)), label_type = "age")
    Condition
      Error in `agetime:::check_m_contains()`:
      ! Can't coarsen age groups.
      x Age group "5-9" would be split by the new age groups.
      i "5-9" overlaps "0-6" and "7-9".
      x Age group "10-14" is not fully covered by the new age groups.
      i New age groups cover [0, 10).
      i Set `open_right = TRUE` to include age groups above 10?

