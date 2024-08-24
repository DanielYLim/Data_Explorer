library(shiny)

# Source UI and server files
source("ui.R")
source("server.R")

# Run the Shiny App
shinyApp(ui = ui, server = server)
