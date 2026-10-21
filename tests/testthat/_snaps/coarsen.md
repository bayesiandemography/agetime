# coarsen error messages describe each problem and suggest fixes

    Code
      age_coarsen(c("3", "7", "12"), breaks = c(5, 10))
    Condition
      Error in `age_coarsen()`:
      ! Can't coarsen age groups.
      x Age groups "3" and "12" are not fully covered by the new age groups.
      i New age groups cover [5, 10).
      i Set `open_right = TRUE` to include age groups above 10?
      i Add a lower break?

---

    Code
      age_coarsen(c("0-4", "5-9", "10-14", "15-19", "20-24", "25+"), breaks = c(2, 7,
        12, 17, 22, 27))
    Condition
      Error in `age_coarsen()`:
      ! Can't coarsen age groups.
      x Age groups "5-9", "10-14", "15-19", and 2 others would be split by the new age groups.
      i "5-9" overlaps "2-6" and "7-11".
      x Age group "0-4" is not fully covered by the new age groups.
      i New age groups cover [2, Inf).
      i Add a lower break?

---

    Code
      period_coarsen(c("2000", "2010"), breaks = c(2005, 2015))
    Condition
      Error in `period_coarsen()`:
      ! Can't coarsen periods.
      x Period "2000" is not fully covered by the new periods.
      i New periods cover [2005, 2015).
      i Set `open_left = TRUE`, or add a lower break?

---

    Code
      age_coarsen_to(c("0-4", "10-14", NA), to = c("0-2", "3-9"))
    Condition
      Error in `age_coarsen_to()`:
      ! Can't coarsen age groups.
      x Age group "0-4" would be split by the labels in `to`.
      i "0-4" overlaps "0-2" and "3-9".
      x Age group "10-14" is not fully covered by the labels in `to`.
      i Add labels to `to` that cover it?
      x `to` has no category for "NA".
      i Add it to `to`?

