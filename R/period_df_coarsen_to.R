#' Coarsen a Period Column Using Classifications in Another Data Frame
#'
#' Recode a period column in `data` using classifications in `to`,
#' matched within groups specified by `by`. All source rows and other
#' columns are preserved. Aggregation and joining measures are separate
#' operations.
#'
#' @inheritSection age_df_coarsen_to Column mappings
#' @inheritSection age_df_coarsen_to Grouping and checks
#' @inheritSection age_df_coarsen_to Factors and output
#' @inheritSection period_lower Rules for interpreting inputs
#' @inheritParams age_df_coarsen_to
#' @inheritParams period_lower
#' @param period A single period-column name or named source-to-target
#' mapping, such as `c(period = "years")`.
#' @returns A data frame of the same class and size as `data`, with the
#' selected column recoded as a factor. Source groups may now have repeated
#' labels; aggregate observations separately if required.
#'
#' @seealso [period_coarsen_to()], [age_df_coarsen_to()], [cohort_df_coarsen_to()]
#'
#' @examples
#' data <- data.frame(
#'   region = c("A", "A", "B", "B"),
#'   period = rep(c("2000-2005", "2005-2010"), 2),
#'   count = 1:4
#' )
#' target <- data.frame(
#'   area = c("A", "B"),
#'   years = "2000-2010"
#' )
#' period_df_coarsen_to(data, target,
#'                       period = c(period = "years"),
#'                       by = c(region = "area"))
#'
#' ## inclusive upper endpoints
#' data <- data.frame(period = c("2000-2004", "2005-2009"), count = 1:2)
#' period_df_coarsen_to(data, data.frame(period = "2000-2009"),
#'                       period = "period", by = NULL,
#'                       interpret_multi = "below_upper")
#' @export
period_df_coarsen_to <- function(data,
                                  to,
                                  period,
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
    inner_df_coarsen_to(data, to, period, by, "period", interpret_single, interpret_multi,
                         interpret_fail, data_arg, to_arg),
    error = function(cnd) {
      cnd$call <- rlang::frame_call(call)
      stop(cnd)
    }
  )
}
