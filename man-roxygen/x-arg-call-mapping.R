#' @param x_arg Name of `labels_x` to use in error and warning
#' messages. Defaults to the expression supplied for `labels_x`.
#' A function that calls this function can supply its own name,
#' such as `"data$age"`.
#' @param y_arg Name of `labels_y` to use in error and warning
#' messages. Defaults to the expression supplied for `labels_y`.
#' @param call Execution environment of the function to name
#' in error and warning messages. The default is this function
#' itself. A function that calls this function can supply
#' `call = rlang::current_env()`, so that messages name it
#' instead.
