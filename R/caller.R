# caller.R
# Names of arguments and calling function, used in error messages.
#
# Exported functions that take labels have arguments 'x_arg' (and
# sometimes 'to_arg' or 'y_arg') and 'call'. On entry, they register
# these with local_caller(). Internal helpers then use arg_nm() to
# name arguments in messages, and user_frame() to name the function.
# Only the outermost agetime function registers, so when one exported
# function calls another, messages refer to the function the user
# called.

caller_env <- new.env(parent = emptyenv())
caller_env$active <- FALSE


#' Register Argument Names and Calling Function
#'
#' Registers names of arguments and the environment of the function
#' to name in error messages, for the duration of the calling
#' function. Does nothing if an outer agetime function has already
#' registered.
#'
#' @param args Named list. Names are the formal arguments
#' (eg `"labels"`), and values are the names to use in messages.
#' @param call Environment of the function to name in messages.
#' @param frame Frame of the function doing the registering.
#' @returns `TRUE` if registered, otherwise `FALSE`, invisibly.
#'
#' @noRd
local_caller <- function(args, call, frame = parent.frame()) {
  if (isTRUE(caller_env$active)) {
    return(invisible(FALSE))
  }
  is_valid_arg <- function(x) is.character(x) && length(x) == 1L && !is.na(x)
  for (nm in names(args)) {
    if (!is_valid_arg(args[[nm]])) {
      cli::cli_abort("{.arg {nm}} must be a single string.", call = call)
    }
  }
  if (!is.environment(call)) {
    cli::cli_abort("{.arg call} must be an environment.", call = frame)
  }
  caller_env$active <- TRUE
  caller_env$args <- args
  caller_env$call <- call
  do.call(base::on.exit,
          list(as.call(list(clear_caller)), add = TRUE, after = FALSE),
          envir = frame)
  invisible(TRUE)
}


#' Clear Registered Argument Names and Calling Function
#'
#' @returns `NULL`, invisibly.
#'
#' @noRd
clear_caller <- function() {
  caller_env$active <- FALSE
  caller_env$args <- NULL
  caller_env$call <- NULL
  invisible(NULL)
}


#' Name of an Argument, for Use in Messages
#'
#' @param nm Name of the formal argument, eg `"labels"`.
#' @returns The name registered by the user-facing function,
#' or `nm` if none was registered.
#'
#' @noRd
arg_nm <- function(nm) {
  ans <- if (isTRUE(caller_env$active)) caller_env$args[[nm]] else NULL
  if (is.null(ans)) nm else ans
}
