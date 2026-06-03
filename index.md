# agetime

[![](reference/figures/sticker/agetime_sticker.png)](https://github.com/bayesiandemography/agetime)

Work with age, period, and cohort labels.

**agetime** has functions for validating, manipulating, and harmonising
labels, and for extracting information from them.

One example: filtering on age.

``` r

library(agetime)
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

Another example: standardizing period labels, and inserting missing
levels.

``` r

x <-  c("2003 to 2005", "2012--2015", "2000-2005")

x |>
  period_modify_five()
#> [1] "2000-2005" "2010-2015" "2000-2005"

x |>
  period_modify_five() |>
  period_levels_fill() |>
  table()
#> 
#> 2000-2005 2005-2010 2010-2015 
#>         2         0         1
```

See
[`?agetime`](https://bayesiandemography.github.io/agetime/reference/agetime-package.md)
for a full list of functions grouped by task.
