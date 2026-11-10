# age_labels_tree() throws expected errors for invalid nodes

    Code
      age_labels_tree(breaks_census, nodes = 5)
    Condition
      Error in `age_labels_tree()`:
      ! `nodes` is not a character vector.
      i `nodes` has class <numeric>.

---

    Code
      age_labels_tree(breaks_census, nodes = c("0-14", NA))
    Condition
      Error in `age_labels_tree()`:
      ! `nodes` has NA.
      i To include a category for missing values, use `include_missing`.

---

    Code
      age_labels_tree(breaks_census, nodes = "15+x")
    Condition
      Error in `age_labels_tree()`:
      ! Can't interpret labels in `nodes`.
      x Don't know how to interpret label "15+x".

---

    Code
      age_labels_tree(breaks_census, nodes = c("0-14", "Missing"))
    Condition
      Error in `age_labels_tree()`:
      ! `nodes` includes "Missing", which is a label for missing values.
      i To include a category for missing values, use `include_missing`.

---

    Code
      age_labels_tree(breaks_census, nodes = "Total")
    Condition
      Error in `age_labels_tree()`:
      ! `nodes` includes "Total", which is a label for a total.
      i A total is not part of a reporting tree.
      i To include a category for age not stated, use `include_missing`.

---

    Code
      age_labels_tree(breaks_census, nodes = "15-25")
    Condition
      Error in `age_labels_tree()`:
      ! Broad age group "15-25" does not line up with `breaks`.
      i "15-25" is interpreted as [15, 26), and 26 is not one of the `breaks`: 0, 5, 10, 15, 20, 30, 40, 50, 60, and 70.

---

    Code
      age_labels_tree(breaks_census, nodes = "12+")
    Condition
      Error in `age_labels_tree()`:
      ! Broad age group "12+" does not line up with `breaks`.
      i "12+" is interpreted as [12, Inf), and 12 is not one of the `breaks`: 0, 5, 10, 15, 20, 30, 40, 50, 60, and 70.

---

    Code
      age_labels_tree(seq(0, 20, 5), nodes = "10+", open_right = FALSE)
    Condition
      Error in `age_labels_tree()`:
      ! Broad age group "10+" does not line up with `breaks`.
      i "10+" is open, but the most detailed age groups are not open on the right.

---

    Code
      age_labels_tree(breaks_census, nodes = "20-29")
    Condition
      Error in `age_labels_tree()`:
      ! Broad age group "20-29" is the same as a most detailed age group.
      i A broad age group must contain two or more of the most detailed age groups.

---

    Code
      age_labels_tree(breaks_census, nodes = "0+")
    Condition
      Error in `age_labels_tree()`:
      ! Broad age group "0+" contains all the most detailed age groups.
      i Records with no information on age are represented by "Missing".
      i To include "Missing", use `include_missing`.

---

    Code
      age_labels_tree(breaks_census, nodes = c("0-14", "Under 15"))
    Condition
      Error in `age_labels_tree()`:
      ! `nodes` includes "0-14" and "Under 15", which describe the same age group.

---

    Code
      age_labels_tree(breaks_census, nodes = c("0-14", "0-14"))
    Condition
      Error in `age_labels_tree()`:
      ! `nodes` includes "0-14" more than once.

---

    Code
      age_labels_tree(breaks_census, nodes = c("0-29", "20-39"))
    Condition
      Error in `age_labels_tree()`:
      ! Broad age groups do not form a tree.
      i "0-29" and "20-39" overlap, but neither contains the other.

# period_labels_tree() and cohort_labels_tree() throw errors

    Code
      period_labels_tree(breaks = seq(2000, 2020, 5), nodes = "<2010")
    Condition
      Error in `period_labels_tree()`:
      ! Broad period "<2010" does not line up with `breaks`.
      i "<2010" is open, but the most detailed periods are not open on the left.

---

    Code
      cohort_labels_tree(breaks = seq(1940, 2000, 10), nodes = "1945-1960")
    Condition
      Error in `cohort_labels_tree()`:
      ! Broad cohort "1945-1960" does not line up with `breaks`.
      i "1945-1960" is interpreted as [1945, 1960), and 1945 is not one of the `breaks`: 1940, 1950, 1960, 1970, 1980, 1990, and 2000.

