# Create a New Set of Unique Age Labels

Create a New Set of Unique Age Labels

## Usage

``` r
age_labels(breaks, open = TRUE, include_total = FALSE, include_na = FALSE)

age_labels_one(
  lower_first = 0,
  lower_last = 100,
  open = TRUE,
  include_total = FALSE,
  include_na = FALSE
)

age_labels_five(
  lower_first = 0,
  lower_last = 100,
  open = TRUE,
  include_total = FALSE,
  include_na = FALSE
)

age_labels_ten(
  lower_first = 0,
  lower_last = 100,
  open = TRUE,
  include_total = FALSE,
  include_na = FALSE
)

age_labels_life(lower_last = 100, include_total = FALSE, include_na = FALSE)
```

## Arguments

- breaks:

  Boundaries between age groups. A numeric vector.

- open:

  Whether the oldest age group is "open", i.e. has no upper limit.
  Default is `TRUE`.

- include_total:

  Whether to include a `"Total"` category.

- include_na:

  Whether to include an `NA` category.

- lower_first:

  The lower limit of the youngest age group.

- lower_last:

  The lower limit of the last age group.

## Value

A character vector.

## Examples

``` r
## default 5-year age groups
age_labels_five()
#>  [1] "0-4"   "5-9"   "10-14" "15-19" "20-24" "25-29" "30-34" "35-39" "40-44"
#> [10] "45-49" "50-54" "55-59" "60-64" "65-69" "70-74" "75-79" "80-84" "85-89"
#> [19] "90-94" "95-99" "100+" 

## open age group is 80+
age_labels_five(lower_last = 80)
#>  [1] "0-4"   "5-9"   "10-14" "15-19" "20-24" "25-29" "30-34" "35-39" "40-44"
#> [10] "45-49" "50-54" "55-59" "60-64" "65-69" "70-74" "75-79" "80+"  

## reproductive ages: 5-year
age_labels_five(lower_first = 15,
                lower_last = 45,
                open = FALSE)
#> [1] "15-19" "20-24" "25-29" "30-34" "35-39" "40-44" "45-49"

## reproductive ages: 1-year
age_labels_one(lower_first = 15,
               lower_last = 49,
               open = FALSE)
#>  [1] "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29"
#> [16] "30" "31" "32" "33" "34" "35" "36" "37" "38" "39" "40" "41" "42" "43" "44"
#> [31] "45" "46" "47" "48" "49"

## include total and NA
age_labels_five(lower_last = 20,
                include_total = TRUE,
                include_na = TRUE)
#> [1] "0-4"   "5-9"   "10-14" "15-19" "20+"   "Total" NA     

## arbitrary age groups
age_labels(breaks = c(0, 5, 10, 14, 18),
           open = FALSE)
#> [1] "0-4"   "5-9"   "10-13" "14-17"

## life table age groups with
## open age group of 75+
age_labels_life(lower_last = 75)
#>  [1] "0"     "1-4"   "5-9"   "10-14" "15-19" "20-24" "25-29" "30-34" "35-39"
#> [10] "40-44" "45-49" "50-54" "55-59" "60-64" "65-69" "70-74" "75+"  
```
