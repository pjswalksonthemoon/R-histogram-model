library(shiny)
library(plotly)
library(DT)

variables <- c(
  "Eruption duration (min)" = "eruptions",
  "Waiting time (min)" = "waiting"
)

bar_colors <- c("blue", "red", "green", "purple", "pink", "magenta", "cyan")
line_colors <- c("black", "red", "blue", "green")

defaults <- list(
  variable = "eruptions",
  bins = 10,
  bar_color = "blue",
  border_color = "black",
  show_density = TRUE,
  density_color = "black"
)

ui <- fluidPage(
  tags$head(tags$style(HTML("
    body { background-color: #1e1e2f; color: white; }
    .well { background-color: #2c2c3e; }
    .btn { background-color: #007bc2; color: white; border: none; }
    .btn:hover { background-color: #005f94; }
    h2, h4 { color: #00c8ff; }
    table.dataTable, .dataTables_wrapper { color: white; }
    .dataTables_wrapper .dataTables_length,
    .dataTables_wrapper .dataTables_filter,
    .dataTables_wrapper .dataTables_info,
    .dataTables_wrapper .dataTables_paginate .paginate_button {
      color: white !important;
    }
  "))),
  titlePanel("Interactive Histogram Dashboard"),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      selectInput("variable", "Variable:", choices = variables),
      sliderInput("bins", "Number of bins:", min = 1, max = 50,
                  value = defaults$bins),
      selectInput("barColor", "Bar colour:", choices = bar_colors),
      selectInput("borderColor", "Bar outline colour:", choices = line_colors),
      checkboxInput("showDensity", "Show density curve", defaults$show_density),
      conditionalPanel(
        "input.showDensity",
        selectInput("densityColor", "Density curve colour:",
                    choices = line_colors)
      ),
      actionButton("reset", "Reset inputs"),
      downloadButton("downloadData", "Download CSV")
    ),
    mainPanel(
      width = 9,
      plotlyOutput("histogram", height = "450px"),
      textOutput("binMessage"),
      hr(),
      h4("Summary statistics"),
      tableOutput("summaryStats"),
      hr(),
      h4("Data"),
      DTOutput("dataTable")
    )
  )
)

server <- function(input, output, session) {
  selected_values <- reactive(faithful[[input$variable]])
  selected_label <- reactive(names(variables)[variables == input$variable])

  observeEvent(input$reset, {
    updateSelectInput(session, "variable", selected = defaults$variable)
    updateSliderInput(session, "bins", value = defaults$bins)
    updateSelectInput(session, "barColor", selected = defaults$bar_color)
    updateSelectInput(session, "borderColor", selected = defaults$border_color)
    updateCheckboxInput(session, "showDensity", value = defaults$show_density)
    updateSelectInput(session, "densityColor", selected = defaults$density_color)
  })

  output$binMessage <- renderText({
    if (input$bins < 5) {
      "Very few bins selected: the histogram may hide detail."
    } else if (input$bins > 40) {
      "Many bins selected: the histogram may be difficult to interpret."
    } else {
      "Number of bins is within the recommended range."
    }
  })

  output$histogram <- renderPlotly({
    values <- selected_values()
    p <- plot_ly(
      x = values,
      type = "histogram",
      nbinsx = input$bins,
      name = "Frequency",
      marker = list(
        color = input$barColor,
        line = list(color = input$borderColor, width = 1)
      ),
      hovertemplate = paste0(
        "<b>", selected_label(), "</b>",
        "<br>Value: %{x}",
        "<br>Count: %{y}",
        "<extra></extra>"
      )
    )
    if (input$showDensity) {
      dens <- density(values)
      count_scale <- length(values) * diff(range(values)) / input$bins
      p <- add_lines(
        p,
        x = dens$x,
        y = dens$y * count_scale,
        name = "Density",
        line = list(color = input$densityColor, width = 2),
        hovertemplate = paste0(
          "<b>Density</b>",
          "<br>Value: %{x:.2f}",
          "<br>Scaled density: %{y:.2f}",
          "<extra></extra>"
        )
      )
    }
    layout(
      p,
      title = paste("Old Faithful:", selected_label()),
      xaxis = list(title = selected_label()),
      yaxis = list(title = "Frequency"),
      paper_bgcolor = "#1e1e2f",
      plot_bgcolor = "#1e1e2f",
      font = list(color = "white")
    )
  })

  output$summaryStats <- renderTable({
    values <- selected_values()
    data.frame(
      Statistic = c("Minimum", "1st quartile", "Median", "Mean",
                    "3rd quartile", "Maximum", "Std. deviation",
                    "Observations"),
      Value = c(
        sprintf("%.2f", min(values)),
        sprintf("%.2f", quantile(values, 0.25)),
        sprintf("%.2f", median(values)),
        sprintf("%.2f", mean(values)),
        sprintf("%.2f", quantile(values, 0.75)),
        sprintf("%.2f", max(values)),
        sprintf("%.2f", sd(values)),
        as.character(length(values))
      )
    )
  }, spacing = "s")

  output$dataTable <- renderDT({
    datatable(
      faithful,
      colnames = c("Eruption duration (min)", "Waiting time (min)"),
      filter = "top",
      options = list(pageLength = 10)
    )
  })

  output$downloadData <- downloadHandler(
    filename = function() "old-faithful.csv",
    content = function(file) write.csv(faithful, file, row.names = FALSE)
  )
}

shinyApp(ui, server)
