# Interactive Histogram Dashboard

## Overview

This project is an interactive R Shiny dashboard that visualizes the Old Faithful Geyser dataset. Users can customise the histogram appearance, display a density curve, explore the underlying data, and view summary statistics.

## Features

- Interactive histogram using Plotly
- Adjustable number of bins
- Custom histogram bar colours
- Custom bar outline colours
- Custom density curve colours
- Toggle density curve on/off
- Sortable and filterable data table
- Dynamic user feedback based on bin selection
- Summary statistics for the displayed data

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

## Author

Jadon Solomon
