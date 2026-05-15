
int_is_empty <- function(intervals) {
  m <- get_m(intervals)
  identical(nrow(m), 0L)
}

int_is_open_left <- function(intervals) {
  is_open_left <- get_is_open_left(intervals)
  any(is_open_left)
}    

int_is_open_right <- function(intervals) {
  is_open_right <- get_is_open_right(intervals)
  any(is_open_right)
}    

int_has_na <- function(intervals) {
  is_na <- get_is_na(intervals)
  any(is_na)
}

int_has_total <- function(intervals) {
  is_total <- get_is_total(intervals)
  any(is_total)
}
