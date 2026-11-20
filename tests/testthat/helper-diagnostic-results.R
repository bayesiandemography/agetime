# Existing condition regressions exercise both factor-level lists and the
# new flat data-frame reports. Keep their shared expectations independent of
# the report container; dedicated data-frame tests check the public schema.
diagnostic_details <- function(x) {
  if (is.data.frame(x)) x else x$details
}

diagnostic_ok <- function(x) {
  if (is.data.frame(x)) all(x$passed) else x$ok
}
