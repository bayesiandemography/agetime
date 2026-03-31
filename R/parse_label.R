

make_label_parsers <- function(parse_one,
                               parse_multi,
                               allow_openleft,
                               allow_openright) {
  ans <- list(label_parser_total,
              label_parser_na)
  label_parser_one_inner <- function(label)
    label_parser_one(label = label,
                        parse_one = parse_one)
  ans <- append(ans, label_parser_one_inner)
  label_parser_range_inner <- function(label)
    label_parser_range(label = label,
                       parse_multi = parse_multi)
  ans <- append(ans, label_parser_range_inner)
  if (allow_openleft)
    ans <- append(ans, label_parser_openleft)
  if (allow_openright)
    ans <- append(ans, label_parser_openright)
  ans
}


make_label_parsers_age <- function() {
  make_label_parsers(parse_one = "lower",
                     parse_multi = "exclude",
                     allow_openleft = FALSE,
                     allow_openright = TRUE)
}

make_label_parsers_cohort <- function(parse_one,
                                      parse_multi) {
  make_label_parsers(parse_one = parse_one,
                     parse_multi = parse_multi,
                     allow_openleft = TRUE,
                     allow_openright = FALSE)
}


make_label_parsers_period <- function(parse_one,
                                      parse_multi) {
  make_label_parsers(parse_one = parse_one,
                     parse_multi = parse_multi,
                     allow_openleft = FALSE,
                     allow_openright = FALSE)
}


parse_label <- function(label, label_parsers, parse_fail) {
  na <- c(NA_real_, NA_real_)
  if (is.na(label))
    return(na)
  for (label_parser in label_parsers) {
    val <- label_parser(label)
    if (!is.null(val))
      return(val)
  }
  msg <- "Don't know how to intepret label {.val {label}}."
  if (parse_fail == "error")
    cli::cli_abort(msg)
  if (parse_fail == "warn")
    cli::cli_warn(msg)
  na
}    
