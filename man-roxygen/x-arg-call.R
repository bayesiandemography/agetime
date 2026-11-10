#' @param x_arg Name of `labels` to use in error and warning
#' messages. Defaults to the expression supplied for `labels`.
#' A function that calls this function can supply its own name,
#' such as `"data$age"`.
#' @param call Execution environment of the function to name
#' in error and warning messages. The default is this function
#' itself. A function that calls this function can supply
#' `call = rlang::current_env()`, so that messages name it
#' instead.
