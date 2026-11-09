# Interactive Histogram Dashboard

An R Shiny app for exploring the built-in Old Faithful `faithful` dataset. Choose eruption duration or waiting time, adjust the histogram, and view the underlying data.

## What it does

- Interactive Plotly histogram with adjustable bins and colours
- Optional density curve
- Summary statistics for the selected variable
- Sortable, filterable data table
- CSV download and a reset button

## Run it

Install R, then install the packages:

```r
install.packages(c("shiny", "plotly", "DT"))
```

From this folder, run:

```r
shiny::runApp()
```

You can also open `app.R` in RStudio and click **Run App**.

## Check it

```sh
Rscript tests/smoke.R
```

The smoke test checks the dataset selection and bin guidance. GitHub Actions runs it on pushes and pull requests. Package versions are not locked; record `sessionInfo()` when reproducing a particular run.

## Authors

Zain and Jadon Solomon.
