# Interactive Histogram Dashboard

An interactive data-visualisation web application built with **R, Shiny, Plotly and DT**. Explore the built-in Old Faithful dataset or upload your own CSV, customise a histogram and inspect descriptive statistics and individual values.

## Features
- Upload a CSV (up to 5 MB) and select any numeric column, or use the included Old Faithful dataset.
- Interactive histogram with 1–50 bins, seven bar colours and configurable outlines.
- Optional kernel-density curve correctly scaled to histogram frequencies.
- Summary statistics: observations, minimum, maximum, mean, median and standard deviation.
- Searchable, sortable data table.
- Input validation, missing-value handling and resettable appearance controls.
- Responsive, dark-themed dashboard.

## Screenshots
Run the application and capture the dashboard for a genuine screenshot. Save it as `screenshots/dashboard.png`, then uncomment the following line:

<!-- ![Histogram dashboard](screenshots/dashboard.png) -->

A screenshot is not included yet because it must be captured from the running application.

## Requirements
- R (recent release)
- R packages `shiny`, `plotly`, `DT`
- Optional tests: `testthat`

## Run locally
Clone or download this repository and, in its root directory, run:

```r
install.packages(c("shiny", "plotly", "DT"))
shiny::runApp(".")
```

Alternatively, open `app.R` in RStudio and click **Run App**. The application starts with Old Faithful eruption durations; uploading a CSV switches to the uploaded dataset. Only finite values in the selected numeric column are plotted.

## Tests
```r
install.packages("testthat")
testthat::test_file("tests/test-helpers.R")
```

Tests cover numerical validation, invalid bin counts, constant-value datasets, histogram frequencies and descriptive statistics.

## Deploy to shinyapps.io
1. Create a shinyapps.io account and install `rsconnect`.
2. Set up your account token and secret using the instructions shown in your shinyapps.io dashboard (never commit these credentials).
3. Run `rsconnect::deployApp(appDir = ".")` from this project's root.
4. Add your deployed URL to the repository description and this README after it is live.

Deployment requires an external account and was not performed as part of these repository changes.

## Project layout
```text
app.R                   Shiny interface and server
R/helpers.R             Validated data and histogram calculations
tests/test-helpers.R    Automated unit tests
screenshots/            Add a genuine application screenshot here
```

## Future improvements
- Downloadable chart images and filtered datasets
- Additional visualisation types and data transformations
- End-to-end Shiny tests

## Author
Jadon Solomon
