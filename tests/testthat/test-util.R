
## ## 'classify_relationship' ----------------------------------------------------

## test_that("classify_relationship worths with one-to-one", {
##   m <- rbind(c(T, F, F),
##              c(F, F, T),
##              c(F, T, F))
##   expect_identical(classify_relationship(m), "one-to-one")
## })

## test_that("classify_relationship worths with many-to-one", {
##   m <- rbind(c(T, F),
##              c(T, F),
##              c(F, T))
##   expect_identical(classify_relationship(m), "many-to-one")
## })

## test_that("classify_relationship worths with one-to-many", {
##   m <- rbind(c(T, T, F),
##              c(F, F, T))
##   expect_identical(classify_relationship(m), "one-to-many")
## })

## test_that("classify_relationship worths with many-to-many", {
##   m <- rbind(c(T, F, T),
##              c(F, F, T),
##              c(F, T, F))
##   expect_identical(classify_relationship(m), "many-to-many")
## })
               


## 'does_int1_overlap_int2' ----------------------------------------------------------

test_that("'does_int1_overlap_int2' works", {
  expect_true(does_int1_overlap_int2(int1 = c(1, 2), int2 = c(0, 3)))
  expect_true(does_int1_overlap_int2(int1 = c(1, 2), int2 = c(1, 2)))
  expect_true(does_int1_overlap_int2(int1 = c(1, 2), int2 = c(1, Inf)))
  expect_true(does_int1_overlap_int2(int1 = c(1, 2), int2 = c(-Inf, 2)))
  expect_true(does_int1_overlap_int2(int1 = c(-Inf, 2), int2 = c(0, 2)))
  expect_true(does_int1_overlap_int2(int1 = c(-Inf, 2), int2 = c(-Inf, 2)))
  expect_false(does_int1_overlap_int2(int1 = c(-Inf, 2), int2 = c(2, 100)))
  expect_false(does_int1_overlap_int2(int1 = c(1, 2), int2 = c(0, 1)))
  expect_identical(does_int1_overlap_int2(int1 = c(-Inf, 2), int2 = c(NA_real_, NA_real_)), NA)
  expect_identical(does_int1_overlap_int2(int1 = c(NA_real_, NA_real_), int2 = c(3, 10)), NA)
})


## 'does_m1_overlap_m2' --------------------------------------------------------------

test_that("'is_mx_x_in_m2' works", {
  m1 <- rbind(c(1, 2),
              c(-Inf, 0),
              c(NA, NA))
  m2 <- rbind(c(0, 3),
              c(1, 2),
              c(1, Inf),
              c(-Inf, 2),
              c(-1, 2),
              c(-Inf, 2),
              c(NA_real_, NA_real_))
  ans_obtained <- does_m1_overlap_m2(m1 = m1, m2 = m2)
  ans_expected <- rbind(c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, NA),
                        c(FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, NA),
                        rep(NA, 7))
  expect_identical(ans_obtained, ans_expected)
})

         

