source("app.R", local = TRUE)

shiny::testServer(server, {
  session$setInputs(
    variable = "eruptions",
    bins = 10,
    barColor = "blue",
    borderColor = "black",
    showDensity = TRUE,
    densityColor = "black"
  )
  stopifnot(length(selected_values()) == nrow(faithful))
  stopifnot(identical(selected_label(), "Eruption duration (min)"))
  stopifnot(identical(output$binMessage, "Number of bins is within the recommended range."))
  session$setInputs(bins = 2)
  stopifnot(grepl("Very few bins", output$binMessage))
  session$setInputs(variable = "waiting")
  stopifnot(identical(selected_values(), faithful$waiting))
})
