library(testthat)
source(file.path("R", "helpers.R"))

test_that("validation drops missing and non-finite values", {
  expect_equal(validate_numeric_data(c(1, 2, NA, Inf, -Inf)), c(1, 2))
  expect_error(validate_numeric_data(c("a", "b")), "numeric")
  expect_error(validate_numeric_data(c(NA_real_, 1)), "two")
})
test_that("histograms use exact bin counts and preserve observations", {
  h <- make_histogram(c(1, 2, 3, 4, 5), 4)
  expect_length(h$counts, 4)
  expect_equal(sum(h$counts), 5)
  expect_equal(length(unique(diff(h$breaks))), 1)
})
test_that("constant datasets can be plotted", {
  expect_equal(sum(make_histogram(rep(7, 5), 10)$counts), 5)
})
test_that("invalid bins are rejected", {
  for (n in c(0, 51, 3.5, NA_real_)) {
    expect_error(make_histogram(1:10, n))
  }
})
test_that("summary statistics are accurate", {
  s <- data_summary(c(1, 2, 3))
  expect_equal(s$Value[s$Statistic == "Mean"], 2)
  expect_equal(s$Value[s$Statistic == "Observations"], 3)
})
