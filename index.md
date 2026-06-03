# agetime

[![](reference/figures/sticker/agetime_sticker.png)](https://github.com/bayesiandemography/agetime)

Work with age, period, and cohort labels.

Functions for

- cleaning,
- validating,
- extracting information,
- modifying, and
- creating new labels.

Example: standardizing labels.

``` r

library(agetime)

x <-  c("2003 to 2005", "2012--2015", "2000-2005")

x |>
  period_standard()
#> [1] "2003-2005" "2012-2015" "2000-2005"
```

Example: filtering on age.

``` r

library(dplyr, warn.conflicts = FALSE)

df <- data.frame(
  age = c("0-14", "100+", "15-39"),
  count = c(100, 40, 200)
)   

df |>
  filter(age_lower(age) >= 15)
#>     age count
#> 1  100+    40
#> 2 15-39   200
```

See
[`?agetime`](https://bayesiandemography.github.io/agetime/reference/agetime-package.md)
for a full list of functions grouped by task.
