mapping_has_no_labels <- function(x) {
  if (is.factor(x))
    nlevels(x) == 0L
  else
    length(x) == 0L
}

mapping_empty <- function(return_val) {
  if (return_val == "data.frame") {
    tibble::tibble(x = character(0),
                   y = character(0))
  }
  else {
    matrix(integer(0),
           nrow = 0L,
           ncol = 0L,
           dimnames = list(x = character(0),
                           y = character(0)))
  }
}

inner_mapping <- function(x,
                          y,
                          relation,
                          return_val,
                          label_type,
                          x_one,
                          x_multi,
                          x_fail) {
  x <- to_character_or_factor(x = x,
                              nm_x = "x",
                              length_zero_ok = TRUE)
  if (is.null(y))
    y <- x
  else
    y <- to_character_or_factor(x = y,
                                nm_x = "y",
                                length_zero_ok = TRUE)
  if (mapping_has_no_labels(x) || mapping_has_no_labels(y))
    return(mapping_empty(return_val = return_val))
  intervals_x <- intervals(labels = x,
                           label_type = label_type,
                           x_one = x_one,
                           x_multi = x_multi,
                           x_fail = x_fail)
  intervals_y <- intervals(labels = y,
                           label_type = label_type,
                           x_one = x_one,
                           x_multi = x_multi,
                           x_fail = x_fail)
  make_mapping(intervals_x = intervals_x,
               intervals_y = intervals_y,
               relation = relation,
               return_val = return_val)
}
