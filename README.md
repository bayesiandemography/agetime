
<!-- README.md is generated from README.Rmd. Please edit that file -->

<a href="https://github.com/bayesiandemography/agetime">
<img src="man/figures/sticker/agetime_sticker.png"
       style="float:right; height:138px;" /> </a>

# agetime

<!-- badges: start -->

[![R-CMD-check](https://github.com/bayesiandemography/agetime/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/bayesiandemography/agetime/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/bayesiandemography/agetime/branch/main/graph/badge.svg)](https://app.codecov.io/gh/bayesiandemography/agetime?branch=main)
<!-- badges: end -->

Work with age, period, and cohort labels.

## Installation

``` r
install.packages("agetime")
```

## Overview

Functions for

- cleaning,
- validating,
- extracting information,
- coarsening, and
- creating new labels.

``` r
library(agetime)
```

Create a new set of labels.

``` r
period_labels_five(lower_first = 2001, lower_last = 2026)
#> [1] "2001-2006" "2006-2011" "2011-2016" "2016-2021" "2021-2026" "2026-2031"
```

Standardize existing labels.

``` r
x <- c("2003 to 2005", "2012--2015", "2000-2005")
period_standard(x)
#> [1] "2003-2005" "2012-2015" "2000-2005"
```

Calculate widths.

``` r
x <- c("10-14", "infants", "1-4")
age_width(x)
#> [1] 5 1 4
```

Filter and sort on age.

``` r
library(dplyr, warn.conflicts = FALSE)

df <- data.frame(
  age = c("0-14", "100+", "15-39"),
  count = c(100, 40, 200)
)
df
#>     age count
#> 1  0-14   100
#> 2  100+    40
#> 3 15-39   200

df |>
  filter(age_lower(age) >= 15) |>
  arrange(age_lower(age))
#>     age count
#> 1 15-39   200
#> 2  100+    40
```

## Learn more

- `vignette("agetime")` for a quick start
- `vignette("cookbook")` for task-oriented recipes
- `vignette("troubleshooting")` for solutions to common problems
- `?agetime` for a full list of functions grouped by task
