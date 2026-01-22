
make_intervals_age <- function(labels) {
  labels_normalizers <- make_labels_normalizers_age()
  label_parsers <- make_label_parsers_age()
  l <- make_intervals_inner(labels = labels,
                            labels_normalizers = labels_normalizers,
                            label_parsers = label_parsers)
  m <- l$m
  i <- l$i
  new_agetime_interval_age(m = m, i = i)
}

make_intervals_cohort <- function(labels,
                                  label_single,
                                  label_multi) {
  labels_normalizers <- make_labels_normalizers_cohort()
  label_parsers <- make_label_parsers_cohort(label_single = label_single,
                                             label_multi = label_multi)
  l <- make_intervals_inner(labels = labels,
                            labels_normalizers = labels_normalizers,
                            label_parsers = label_parsers)
  m <- l$m
  i <- l$i
  new_agetime_interval_cohort(m = m, i = i)
}


make_intervals_period <- function(labels,
                                  label_single,
                                  label_multi) {
  labels_normalizers <- make_labels_normalizers_period()
  label_parsers <- make_label_parsers_period(label_single = label_single,
                                             label_multi = label_multi)
  l <- make_intervals_inner(labels = labels,
                            labels_normalizers = labels_normalizers,
                            label_parsers = label_parsers)
  m <- l$m
  i <- l$i
  new_agetime_interval_period(m = m, i = i)
}


make_intervals_inner <- function(labels,
                                 labels_normalizers,
                                 label_parsers) {
  labels <- as.character(labels)
  labels_norm <- normalize_labels(labels = labels,
                                  labels_normalizers = labels_normalizers)
  labels_norm_unique <- unique(labels_norm)
  m <- vapply(labels_norm_unique,
              FUN = parse_label,
              FUN.VALUE = c(NA_real_, NA_real_),
              label_parsers = label_parsers)
  m <- t(m)
  i <- match(labels_norm, labels_norm_unique)
  list(m = m, i = i)
}
