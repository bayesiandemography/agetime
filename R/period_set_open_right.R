#' @rdname period_set_open_left
#' @export

period_set_open_right <- function(labels,
                                     lower_open,
                                     interpret_single = c("lower", "upper"),
                                     interpret_multi = c("include", "exclude"),
                                     interpret_fail = c(
                                       "error", "warn", "silent"
                                     )) {
  interpret_fail <- match.arg(interpret_fail)
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- match.arg(interpret_multi)
  inner_levels_set_open(
    labels = labels,
    open_boundary = lower_open,
    nm_open_boundary = "lower_open",
    make_open_left = FALSE,
    make_open_right = TRUE,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
