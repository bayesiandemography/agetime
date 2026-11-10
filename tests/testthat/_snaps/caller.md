# supplied x_arg and call are used in messages

    Code
      wrapper_lower(data.frame(age = c("10", "abc")))
    Condition
      Error in `wrapper_lower()`:
      ! Can't interpret labels in `standard$age`.
      x Don't know how to interpret label "abc".

# warnings name the calling function

    Code
      ans <- f(c("0-4", "abc"))
    Condition
      Warning in `f()`:
      Can't interpret labels in `data$age`.
      x Don't know how to interpret label "abc".

# age_coarsen_to() names labels and to

    Code
      f(data.frame(age = c("10-14", "15-19")), age_labels(breaks = seq(0, 20, by = 4)))
    Condition
      Error in `f()`:
      ! Can't coarsen age groups in `standard$age`.
      x Age groups "10-14" and "15-19" would be split by the labels in `ages`.
      i "10-14" overlaps "8-11" and "12-15".

---

    Code
      f(data.frame(age = "10-14"), c("0-9", "abc"))
    Condition
      Error in `f()`:
      ! Can't interpret labels in `ages`.
      x Don't know how to interpret label "abc".

# functions with other errors use x_arg and call

    Code
      f("90+")
    Condition
      Error in `f()`:
      ! `data$age` contains age group open on the right: "90+".
      i `open_right` is FALSE.
      i Remove open-right labels from `data$age`?
      i Or unset `open_right`, or pass TRUE?

---

    Code
      g(c("0-4", "Total"))
    Condition
      Error in `g()`:
      ! Can't extend age groups: `data$age` includes a total ("Total").
      i Remove totals first with `data$age[!age_is_total(data$age)]`?

# assert functions name x_arg in parse errors

    Code
      f(c("0-4", "abc"))
    Condition
      Error in `f()`:
      ! Can't interpret labels in `data$age`.
      x Don't know how to interpret label "abc".

