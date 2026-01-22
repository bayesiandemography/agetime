

make_label_parsers <- function(label_single,
                               label_multi,
                               allow_openleft,
                               allow_openright) {
  ans <- list()
  label_parser_single_inner <- function(label)
    label_parser_single(label = label,
                        label_single = label_single)
  ans <- append(ans, label_parser_single_inner)
  label_parser_range_inner <- function(label)
    label_parser_range(label = label,
                       label_multi = label_multi)
  ans <- append(ans, label_parser_range_inner)
  if (allow_openleft)
    ans <- append(ans, label_parser_openleft)
  if (allow_openright)
    ans <- append(ans, label_parser_openright)
  ans
}


make_label_parsers_age <- function() {
  make_label_parsers(label_single = "lower",
                     label_multi = "exclude",
                     allow_openleft = FALSE,
                     allow_openright = TRUE)
}

make_label_parsers_cohort <- function(label_single,
                                      label_multi) {
  make_label_parsers(label_single = label_single,
                     label_multi = label_multi,
                     allow_openleft = TRUE,
                     allow_openright = FALSE)
}


make_label_parsers_period <- function(label_single,
                                      label_multi) {
  make_label_parsers(label_single = label_single,
                     label_multi = label_multi,
                     allow_openleft = FALSE,
                     allow_openright = FALSE)
}


parse_label <- function(label, label_parsers) {
  na <- c(NA_real_, NA_real_)
  if (is.na(label))
    return(na)
  for (label_parser in label_parsers) {
    val <- label_parser(label)
    if (!is.null(val))
      return(val)
  }
  na
}    
