
<!-- README.md is generated from README.Rmd. Please edit that file -->

<a href="https://github.com/bayesiandemography/agetime">
<img src="man/figures/sticker/agetime_sticker.png"
       style="float:right; height:138px;" /> </a>

# agetime

<!-- badges: start -->

[![R-CMD-check](https://github.com/bayesiandemography/agetime/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/bayesiandemography/agetime/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/bayesiandemography/agetime/branch/main/graph/badge.svg)](https://app.codecov.io/gh/bayesiandemography/agetime?branch=main)
<!-- badges: end -->

Work with age, period, and cohort labels.

## Installation

Install the released version from CRAN:

``` r
install.packages("agetime")
```

Or install the development version from GitHub:

``` r
# install.packages("pak")
pak::pak("bayesiandemography/agetime")
```

## Overview

Functions for

- cleaning,
- validating,
- extracting information,
- coarsening, and
- creating new labels.

Example: creating a complete set of labels.

``` r
library(agetime)

age_labels_five(lower_last = 85)
#>  [1] "0-4"   "5-9"   "10-14" "15-19" "20-24" "25-29" "30-34" "35-39" "40-44"
#> [10] "45-49" "50-54" "55-59" "60-64" "65-69" "70-74" "75-79" "80-84" "85+"
```

Example: standardizing labels.

``` r
x <- c("2003 to 2005", "2012--2015", "2000-2005")

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

## Learn more

- `vignette("agetime")` for a quick start
- `vignette("cookbook")` for task-oriented recipes
- `vignette("troubleshooting")` for solutions to common problems
- `?agetime` for a full list of functions grouped by task
