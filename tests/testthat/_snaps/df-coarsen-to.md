# ungrouped coarsening errors suggest `by` only in direct calls

    Code
      age_df_coarsen_to(x, to, age = "age", by = NULL)
    Condition
      Error in `age_df_coarsen_to()`:
      ! Can't coarsen `x$age` to `to$age`.
      i Use `by` to coarsen each group with its own classification?
      Caused by error in `age_df_coarsen_to()`:
      ! Source "0-4" does not fit wholly inside a single target interval in `to$age`; it crosses a boundary or lies outside the target classification.

---

    Code
      f(x)
    Condition
      Error in `f()`:
      ! Can't coarsen `x$age` to `to$age`.
      Caused by error in `f()`:
      ! Source "0-4" does not fit wholly inside a single target interval in `to$age`; it crosses a boundary or lies outside the target classification.

