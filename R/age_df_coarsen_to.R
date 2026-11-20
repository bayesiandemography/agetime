#' Coarsen an Age Column Using Classifications in Another Data Frame
#'
#' Recode an age column in `data` using the target classification in `to`,
#' matching groups through `by`. Return the source data frame with its
#' rows, row order, column names, and other columns preserved.
#' No observations are aggregated and no target columns are added.
#'
#' @section Column mappings:
#' Column arguments are character vectors, not tidyselect expressions.
#' An unnamed name selects the same column in both frames. A named
#' element maps a source column to a target column: for example,
#' `age = c(age = "age_group")` and
#' `by = c(country = "country_code", "year", "sex")`.
#' Names on the left refer to `data`; values on the right refer to `to`.
#' The recoded column keeps its source name.
#'
#' `by` must be supplied explicitly. Use `by = NULL` (or `character(0)`)
#' for one target classification for the whole dataset. The label column
#' cannot also be a grouping column.
#'
#' @section Grouping and checks:
#' Within each group, every distinct source interval must fit wholly
#' inside exactly one target interval. Source and target classifications
#' must have no overlapping distinct intervals, and the source intervals
#' must completely cover every target interval. Matching gaps between
#' target intervals are allowed. Identical classifications are allowed.
#' Totals, missing categories, and `NA` labels are not supported.
#' Errors identify the source group and the problem, including an example
#' of missing ages or years when coverage is incomplete.
#'
#' Repeated observations are kept. Repeated source labels, including
#' synonyms for the same interval, describe one category for the coverage
#' checks. Repeated identical target labels are also allowed, but different
#' target labels for the same interval are ambiguous and cause an error.
#' These checks concern classifications, not completeness or uniqueness
#' of observations within other dimensions, or the measures to aggregate.
#'
#' Every source group must have a corresponding group in `to`.
#' Target-only groups are ignored. Grouping keys are matched by equality,
#' with missing keys matching missing keys. Compatible types, such as
#' factors and character vectors, can be matched.
#' Existing data-frame grouping is preserved, but does not determine the
#' matching groups: these are always specified by `by`.
#'
#' @section Factors and output:
#' Only observed label values are used; unused factor levels are ignored.
#' The recoded column is a factor using the original target labels.
#' If the target column is a factor, its level order is retained among
#' the labels used by matched groups. The result is ordered if the source
#' column was ordered. All other columns retain their values and types.
#'
#' @param data A source data frame or tibble.
#' @param to A data frame supplying target classifications.
#' @param age A single age-column name, or a named source-to-target
#' column mapping, such as `c(age = "age_group")`.
#' @param by A character vector of grouping column names or named
#' source-to-target mappings. Supply `NULL` explicitly for no grouping.
#' @param interpret_fail Action if a label cannot be interpreted:
#' `"error"` (the default), `"warn"`, or `"silent"`. Uninterpretable
#' labels cannot be coarsened even when parsing messages are suppressed.
#' @param data_arg,to_arg Names of `data` and `to` used in error and
#' warning messages. Default to the expressions supplied for the frames.
#' @param call Execution environment of the function to name in errors.
#' Defaults to this function. A calling function can supply
#' `call = rlang::current_env()`.
#' @returns A data frame of the same class and size as `data`, with the
#' selected column recoded. Source groups may now have repeated labels;
#' aggregate observations separately if required.
#'
#' @seealso
#' - [age_coarsen_to()] Recode a vector to a target classification
#' - [period_df_coarsen_to()], [cohort_df_coarsen_to()]
#' - [age_df_assert_values()] Check labels before recoding or after aggregation
#'
#' @examples
#' deaths <- data.frame(
#'   country = c("A", "A", "B", "B"),
#'   age = c("0-4", "5-9", "0-4", "5-9"),
#'   deaths = c(1, 2, 3, 4)
#' )
#' target <- data.frame(
#'   code = c("A", "B", "B"),
#'   age_group = c("0-9", "0-4", "5-9")
#' )
#' deaths |>
#'   age_df_coarsen_to(
#'     to = target,
#'     age = c(age = "age_group"),
#'     by = c(country = "code")
#'   )
#'
#' ## one classification for all observations
#' age_df_coarsen_to(deaths, data.frame(age = "0-9"), age = "age", by = NULL)
#'
#' ## incomplete coverage is an error
#' \dontrun{
#' age_df_coarsen_to(deaths[-2, ], target,
#'                   age = c(age = "age_group"), by = c(country = "code"))
#' }
#' @export
age_df_coarsen_to <- function(data,
                               to,
                               age,
                               by,
                               interpret_fail = c("error", "warn", "silent"),
                               data_arg = rlang::caller_arg(data),
                               to_arg = rlang::caller_arg(to),
                               call = rlang::current_env()) {
  local_caller(args = list(data = data_arg, to = to_arg), call = call)
  interpret_fail <- match.arg(interpret_fail)
  withCallingHandlers(
    inner_df_coarsen_to(data, to, age, by, "age", "lower", "below_upper",
                         interpret_fail, data_arg, to_arg),
    error = function(cnd) {
      cnd$call <- rlang::frame_call(call)
      stop(cnd)
    }
  )
}
