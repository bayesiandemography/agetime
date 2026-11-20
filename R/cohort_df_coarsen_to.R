#' Coarsen a Cohort Column Using Classifications in Another Data Frame
#'
#' Recode a cohort column in `data` using classifications in `to`,
#' matched within groups specified by `by`. All source rows and other
#' columns are preserved. Aggregation and joining measures are separate
#' operations.
#'
#' @inheritSection age_df_coarsen_to Column mappings
#' @inheritSection age_df_coarsen_to Grouping and checks
#' @inheritSection age_df_coarsen_to Factors and output
#' @inheritSection cohort_lower Rules for interpreting inputs
#' @inheritParams age_df_coarsen_to
#' @inheritParams cohort_lower
#' @param cohort A single cohort-column name or named source-to-target
#' mapping, such as `c(cohort = "years")`.
#' @returns A data frame of the same class and size as `data`, with the
#' selected column recoded as a factor. Source groups may now have repeated
#' labels; aggregate observations separately if required.
#'
#' @seealso [cohort_coarsen_to()], [age_df_coarsen_to()], [period_df_coarsen_to()]
#'
#' @examples
#' data <- data.frame(
#'   region = c("A", "A", "B", "B"),
#'   cohort = rep(c("2000-2005", "2005-2010"), 2),
#'   count = 1:4
#' )
#' target <- data.frame(
#'   area = c("A", "B"),
#'   years = "2000-2010"
#' )
#' cohort_df_coarsen_to(data, target,
#'                       cohort = c(cohort = "years"),
#'                       by = c(region = "area"))
#'
#' ## inclusive upper endpoints
#' data <- data.frame(cohort = c("2000-2004", "2005-2009"), count = 1:2)
#' cohort_df_coarsen_to(data, data.frame(cohort = "2000-2009"),
#'                       cohort = "cohort", by = NULL,
#'                       interpret_multi = "below_upper")
#' @export
cohort_df_coarsen_to <- function(data,
                                  to,
                                  cohort,
                                  by,
                                  interpret_single = c("lower", "upper"),
                                  interpret_multi = NULL,
                                  interpret_fail = c("error", "warn", "silent"),
                                  data_arg = rlang::caller_arg(data),
                                  to_arg = rlang::caller_arg(to),
                                  call = rlang::current_env()) {
  local_caller(args = list(data = data_arg, to = to_arg), call = call)
  interpret_single <- match.arg(interpret_single)
  interpret_fail <- match.arg(interpret_fail)
  withCallingHandlers(
    inner_df_coarsen_to(data, to, cohort, by, "cohort", interpret_single, interpret_multi,
                         interpret_fail, data_arg, to_arg),
    error = function(cnd) {
      cnd$call <- rlang::frame_call(call)
      stop(cnd)
    }
  )
}
