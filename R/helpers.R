# Pure functions used by the Shiny app and automated tests.
validate_numeric_data <- function(values) {
  if (!is.numeric(values)) stop("Select a numeric column.")
  values <- values[is.finite(values)]
  if (length(values) < 2L) stop("At least two finite numeric values are required.")
  values
}

make_histogram <- function(values, bins) {
  values <- validate_numeric_data(values)
  if (length(bins) != 1L || !is.finite(bins) ||
      bins != as.integer(bins) || bins < 1L || bins > 50L) {
    stop("Bins must be a whole number between 1 and 50.")
  }
  limits <- range(values)
  if (limits[1] == limits[2]) {
    pad <- max(abs(limits[1]) * 0.05, 0.5)
    limits <- limits + c(-pad, pad)
  }
  breaks <- seq(limits[1], limits[2], length.out = bins + 1L)
  hist(values, breaks = breaks, plot = FALSE, include.lowest = TRUE)
}

data_summary <- function(values) {
  values <- validate_numeric_data(values)
  data.frame(
    Statistic = c("Observations", "Minimum", "Maximum", "Mean", "Median", "Standard deviation"),
    Value = c(length(values), min(values), max(values),
              mean(values), median(values), sd(values))
}
