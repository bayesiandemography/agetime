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

