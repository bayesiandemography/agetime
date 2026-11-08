# age_set_order_tree() throws error when labels overlap without nesting

    Code
      age_set_order_tree(c("0-4", "10-19", "15-24", "0-9"))
    Condition
      Error in `age_set_order_tree()`:
      ! Age groups do not form a tree.
      i '10-19' and '15-24' overlap, but neither contains the other.

# age_set_order_tree() error lists at most three pairs

    Code
      age_set_order_tree(c("0-4", "10-19", "15-24", "0-9", "5-14", "3-7", "2-6"))
    Condition
      Error in `age_set_order_tree()`:
      ! Age groups do not form a tree.
      i '0-4' and '3-7' overlap, but neither contains the other.
      i '0-4' and '2-6' overlap, but neither contains the other.
      i '10-19' and '15-24' overlap, but neither contains the other.
      i ...and 5 more pairs.

# age_set_order_tree() throws error with totals

    Code
      age_set_order_tree(c("0-4", "5+", "Total"))
    Condition
      Error in `age_set_order_tree()`:
      ! Age groups include a total, so do not form a reporting tree.
      i Total: "Total".
      i If a total means age not stated, recode it to "Missing" first, e.g. `age[age_is_total(age)] <- "Missing"`.
      i If a total is a sum over other age groups, remove it.

---

    Code
      age_set_order_tree(c("0-4", "Total", "all"))
    Condition
      Error in `age_set_order_tree()`:
      ! Age groups include a total, so do not form a reporting tree.
      i Totals: "Total" and "all".
      i If a total means age not stated, recode it to "Missing" first, e.g. `age[age_is_total(age)] <- "Missing"`.
      i If a total is a sum over other age groups, remove it.

# period_set_order_tree() and cohort_set_order_tree() throw errors

    Code
      period_set_order_tree(c("2000-2010", "2005-2015"), interpret_multi = "at_upper")
    Condition
      Error in `period_set_order_tree()`:
      ! Periods do not form a tree.
      i '2000-2010' and '2005-2015' overlap, but neither contains the other.

---

    Code
      cohort_set_order_tree(c("1950-1960", "Total"), interpret_multi = "at_upper")
    Condition
      Error in `cohort_set_order_tree()`:
      ! Cohorts include a total, so do not form a reporting tree.
      i Total: "Total".
      i If a total means cohort not stated, recode it to "Missing" first, e.g. `cohort[cohort_is_total(cohort)] <- "Missing"`.
      i If a total is a sum over other cohorts, remove it.

