library(shiny)
library(plotly)
library(DT)
source("R/helpers.R", local = TRUE)

palette <- c("blue", "red", "green", "purple", "pink", "magenta", "cyan")
outline_palette <- c("black", "red", "blue", "green")

ui <- fluidPage(
  tags$head(
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
    tags$style(HTML("
      body { background: #171b2b; color: #ecf2ff; font-family: system-ui, sans-serif; }
      .container-fluid { max-width: 1450px; padding: 18px 26px; }
      .well { background: #242b41; border: 1px solid #45506b; border-radius: 12px; }
      h2, h3 { color: #64d8ff; }
      .form-control, .selectize-input { background-color: #f8fafc; color: #151b2b; }
      .btn-primary { background-color: #087fb6; border-color: #087fb6; }
      .panel-heading { color: #ecf2ff; }
      .dataTables_wrapper { background: #f8fafc; color: #1b2331; padding: 12px; border-radius: 10px; }
      .shiny-output-error-validation { color: #ffc774; font-weight: 600; }
      .info-text { color: #c8d3e6; }
    "))
  ),
  titlePanel("Interactive Histogram Dashboard"),
  p(class = "info-text", "Explore Old Faithful data or upload your own CSV file with a numeric column."),
  fluidRow(
    column(3, wellPanel(
      h3("Data"),
      fileInput("csv", "Upload CSV (optional)", accept = ".csv"),
      uiOutput("columnPicker"),
      tags$hr(),
      h3("Appearance"),
      selectInput("barColor", "Bar colour", choices = palette, selected = "blue"),
      selectInput("borderColor", "Outline colour", choices = outline_palette),
      numericInput("bins", "Number of bins", value = 10, min = 1, max = 50, step = 1),
      checkboxInput("showDensity", "Show density curve", value = TRUE),
      conditionalPanel("input.showDensity",
        selectInput("densityColor", "Density curve colour", choices = outline_palette)),
      actionButton("reset", "Reset appearance", class = "btn-primary")
    )),
    column(9,
      plotlyOutput("hist", height = "450px"),
      textOutput("binMessage"),
      h3("Summary statistics"),
      tableOutput("summaryStats")
    )
  ),
  hr(),
  h3("Displayed values"),
  DTOutput("histData")
)

server <- function(input, output, session) {
  imported <- reactive({
    if (is.null(input$csv)) return(faithful)
    validate(need(input$csv$size <= 5 * 1024 * 1024,
                  "The CSV must be 5 MB or smaller."))
    result <- tryCatch(
      read.csv(input$csv$datapath, check.names = FALSE),
      error = function(e) NULL
    )
    validate(need(!is.null(result) && nrow(result) > 0,
                  "Could not read the CSV. Check its format and contents."))
    result
  })

  output$columnPicker <- renderUI({
    df <- imported()
    numeric_cols <- names(df)[vapply(df, is.numeric, logical(1))]
    validate(need(length(numeric_cols) > 0,
                  "This dataset has no numeric columns."))
    selected <- if (is.null(input$csv)) "eruptions" else numeric_cols[1]
    selectInput("dataColumn", "Numeric column",
                choices = numeric_cols, selected = selected)
  })

  values <- reactive({
    df <- imported()
    req(input$dataColumn)
    validate(need(input$dataColumn %in% names(df), "Select a valid column."))
    result <- tryCatch(validate_numeric_data(df[[input$dataColumn]]),
                       error = function(e) e)
    validate(need(!inherits(result, "error"), if (inherits(result, "error"))
      conditionMessage(result) else TRUE))
    result
  })

  histogram <- reactive({
    result <- tryCatch(make_histogram(values(), input$bins),
                       error = function(e) e)
    validate(need(!inherits(result, "error"), if (inherits(result, "error"))
      conditionMessage(result) else TRUE))
    result
  })

  observeEvent(input$reset, {
    updateSelectInput(session, "barColor", selected = "blue")
    updateSelectInput(session, "borderColor", selected = "black")
    updateNumericInput(session, "bins", value = 10)
    updateCheckboxInput(session, "showDensity", value = TRUE)
    updateSelectInput(session, "densityColor", selected = "black")
    showNotification("Appearance settings restored.", type = "message", duration = 3)
  })

  output$binMessage <- renderText({
    req(input$bins)
    if (!is.finite(input$bins) || input$bins < 1 || input$bins > 50 ||
        input$bins != as.integer(input$bins)) {
      "Choose a whole number of bins between 1 and 50."
    } else if (input$bins < 5) {
      "Tip: Few bins may hide details in the distribution."
    } else if (input$bins > 40) {
      "Tip: Many bins can make the distribution harder to interpret."
    } else {
      "Tip: Adjust the bin count to explore the distribution."
    }
  })

  output$summaryStats <- renderTable({
    stats <- data_summary(values())
    stats$Value <- format(round(stats$Value, 2), trim = TRUE)
    stats
  }, striped = TRUE, bordered = TRUE, spacing = "s")

  output$histData <- renderDT({
    datatable(data.frame(Value = values()),
      rownames = FALSE, filter = "top",
      options = list(pageLength = 10, scrollX = TRUE))
  })

  output$hist <- renderPlotly({
    vals <- values()
    h <- histogram()
    bin_width <- diff(h$breaks)[1]
    chart <- plot_ly(
      x = h$mids, y = h$counts, type = "bar",
      width = rep(bin_width, length(h$mids)),
      name = "Histogram",
      marker = list(color = input$barColor,
                    line = list(color = input$borderColor, width = 1)),
      hovertemplate = "Bin midpoint: %{x:.3f}<br>Count: %{y}<extra></extra>"
    )

    # A density estimate is in probability-density units. Multiply by the
    # sample size and the ACTUAL histogram width to plot on a count axis.
    if (isTRUE(input$showDensity) && length(unique(vals)) > 1L) {
      dens <- density(vals)
      chart <- chart %>% add_lines(
        x = dens$x, y = dens$y * length(vals) * bin_width,
        name = "Scaled density curve",
        line = list(color = input$densityColor, width = 2),
        hovertemplate = "X: %{x:.3f}<br>Expected count scale: %{y:.2f}<extra></extra>"
      )
    }

    chart %>% layout(
      title = paste("Distribution of", input$dataColumn),
      xaxis = list(title = input$dataColumn),
      yaxis = list(title = "Frequency"),
      barmode = "overlay",
      paper_bgcolor = "#171b2b", plot_bgcolor = "#171b2b",
      font = list(color = "#ecf2ff"),
      showlegend = TRUE
    )
  })
}
shinyApp(ui, server)
