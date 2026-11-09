# Interactive Histogram Dashboard

## Overview

This project is an interactive R Shiny dashboard that visualizes the Old Faithful Geyser dataset. Users can switch between eruption duration and waiting time, customise the histogram appearance, display a density curve, explore the underlying data, and download it as a CSV.

## Features

- Interactive histogram using Plotly
- Switch between eruption duration and waiting time
- Adjustable number of bins with guidance messages
- Custom histogram bar colours
- Custom bar outline colours
- Custom density curve colours
- Toggle density curve on/off, scaled to the frequency axis
- One-click reset of all controls
- Summary statistics table (min, quartiles, median, mean, max, standard deviation, observations)
- Sortable and filterable data table
- CSV download of the dataset

## Packages Used

- **shiny** - Web application framework for R
- **plotly** - Interactive visualisations
- **DT** - Interactive and filterable data tables

## Dataset

The application uses the built-in **faithful** dataset available in R, containing eruption durations and waiting times for the Old Faithful geyser.

## Running the Application

1. Install the required packages:

```r
install.packages(c("shiny", "plotly", "DT"))
```

2. Open `app.R` in RStudio.

3. Run the application:

```r
shiny::runApp()
```

## Authors

- Zain
- Jadon Solomon

## Checks and reproducibility

Run the smoke check after installing the packages above:

```sh
Rscript tests/smoke.R
```

GitHub Actions runs the same check on pushes and pull requests. For an exact local package record, run `sessionInfo()` in the R session used to test the app and keep its output with your release notes. Package versions are not currently locked, so a future package update may affect reproducibility.
