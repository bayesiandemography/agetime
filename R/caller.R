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
#
# Registration also records whether the user called the function
# directly (`call` left at its default) or another function supplied
# `call`. Messages are signalled with abort_msg(), warn_msg() and
# inform_msg(), which drop hints (bullets named "i") unless the call
# is direct. See dev/messages.md.

caller_env <- new.env(parent = emptyenv())
caller_env$active <- FALSE


#' Register Argument Names and Calling Function
#'
#' Registers names of arguments and the environment of the function
#' to name in error messages, for the duration of the calling
#' function, and whether the call is direct (`call` is the calling
#' function's own frame). Does nothing if an outer agetime function
#' has already registered.
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
      abort_msg("{.arg {nm}} is not a single string.", call = call)
    }
  }
  if (!is.environment(call)) {
    abort_msg("{.arg call} is not an environment.", call = frame)
  }
  caller_env$active <- TRUE
  caller_env$args <- args
  caller_env$call <- call
  caller_env$direct <- identical(call, frame)
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
  caller_env$direct <- NULL
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


#' Is the Current Call Direct?
#'
#' @returns `TRUE` if the registered function was called with `call`
#' left at its default, or if no function has registered (internal
#' use); `FALSE` if another function supplied `call`.
#'
#' @noRd
is_direct_call <- function() {
  if (!isTRUE(caller_env$active)) {
    return(TRUE)
  }
  isTRUE(caller_env$direct)
}


#' Drop Hints from a Message, Unless the Call Is Direct
#'
#' Hints are bullets named `"i"`: advice that names agetime's own
#' functions or arguments, which may mean nothing to the user of a
#' calling package.
#'
#' @param message Character vector of message bullets.
#' @returns `message`, without bullets named `"i"` if the call
#' is not direct.
#'
#' @noRd
drop_hints <- function(message) {
  nms <- names(message)
  if (is.null(nms) || is_direct_call()) {
    return(message)
  }
  message[nms != "i"]
}


#' Signal Errors, Warnings and Messages
#'
#' Wrappers around [cli::cli_abort()], [cli::cli_warn()] and
#' [cli::cli_inform()] that drop hints when the call is not direct.
#' All agetime messages go through these.
#'
#' @param message Character vector of message bullets.
#' @param ... Passed to the cli function.
#' @param call Environment of the function to name in the error.
#' @param .envir Environment in which to interpolate `message`.
#'
#' @noRd
abort_msg <- function(message, ..., call = .envir, .envir = parent.frame()) {
  cli::cli_abort(drop_hints(message), ..., call = call, .envir = .envir)
}

#' @rdname abort_msg
#' @noRd
warn_msg <- function(message, ..., .envir = parent.frame()) {
  cli::cli_warn(drop_hints(message), ..., .envir = .envir)
}

#' @rdname abort_msg
#' @noRd
inform_msg <- function(message, ..., .envir = parent.frame()) {
  cli::cli_inform(drop_hints(message), ..., .envir = .envir)
}
