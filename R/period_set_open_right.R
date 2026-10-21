#' @rdname period_set_open_left
#' @export

period_set_open_right <- function(labels,
                                     at,
                                     interpret_single = c("lower", "upper"),
                                     interpret_multi = NULL,
                                     interpret_fail = c(
                                       "error", "warn", "silent"
                                     )) {
  interpret_fail <- match.arg(interpret_fail)
  interpret_single <- match.arg(interpret_single)
  interpret_multi <- resolve_interpret_multi(
    interpret_multi = interpret_multi,
    labels = labels,
    labels_other = NULL,
    label_type = "period",
    interpret_single = interpret_single
  )
  inner_levels_set_open(
    labels = labels,
    open_boundary = at,
    nm_open_boundary = "at",
    make_open_left = FALSE,
    make_open_right = TRUE,
    label_type = "period",
    interpret_single = interpret_single,
    interpret_multi = interpret_multi,
    interpret_fail = interpret_fail
  )
}
