
int_is_empty <- function(intervals) {
  m <- get_m(intervals)
  identical(nrow(m), 0L)
}

int_has_na <- function(intervals) {
  is_na <- get_is_na(intervals)
  any(is_na)
}

int_has_total <- function(intervals) {
  is_total <- get_is_total(intervals)
  any(is_total)
}
