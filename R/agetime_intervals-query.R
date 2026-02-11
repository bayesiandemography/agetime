
has_na <- function(intervals) {
  is_na <- get_is_na(intervals)
  any(is_na)
}

has_total <- function(intervals) {
  is_total <- get_is_total(intervals)
  any(is_total)
}
