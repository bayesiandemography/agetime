        


## NO_TESTS
#' Check that Argument is a Vector or Factor
#'
#' @param x Argument
#' @param nm_x Name of argument
#'
#' @returns TRUE, invisibly
#'
#' @noRd
check_vector_or_factor <- function(x, nm_x) {
    if (!is.vector(x) && !is.factor(x))
        cli::cli_abort(c("{.arg {nm_x}} is not a vector or factor.",
                         i = "{.arg {nm_x}} has class {.cls {class(x)}}."))
    invisible(TRUE)
}


#' Check that New Type Less Detailed than Old Type

check_type_less_detailed_age <- function(type_new, type_old) {
    is_more_detailed <- ((type_new == "single" && (type_old == "five"))
        || (type_new == "single" && (type_old == "ten"))
        || (type_new == "single" && (type_old == "lifetable"))
        || ((type_new == "five") && (type_old == "ten"))
        || ((type_new == "lifetable") && (type_old == "five"))
        || ((type_new == "lifetable") && (type_old == "ten")))
    if (is_more_detailed)
        cli::cli_abort(c("New type is more detailed than old type.",
                         i = "New type: {.val {type_new}}.",
                         i = "Old type: {.val {type_old}}."))
    invisible(TRUE)
}

    
