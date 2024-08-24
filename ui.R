library(shiny)
library(DT)
library(plotly)

# UI
ui <- navbarPage(
  title = "Data Explorer",
  
  # First tab: Data Overview
  tabPanel(
    title = "Data Overview",
    sidebarLayout(
      sidebarPanel(
        fileInput("file1", "Choose CSV File",
                  accept = c(
                    "text/csv",
                    "text/comma-separated-values,text/plain",
                    ".csv")
        ),
        helpText("Default dataset is 'mtcars'.")
      ),
      mainPanel(
        h3("Dataset Preview"),
        DTOutput("data_table"),
        
        h3("Summary Statistics"),
        verbatimTextOutput("data_summary"),
        
        h3("Dataset Structure"),
        verbatimTextOutput("data_structure"),
        
        h3("NA Value Checker"),
        tableOutput("na_checker")
      )
    )
  ),
  
  # Second tab: Scatter Plot
  tabPanel(
    title = "Scatter Plot",
    sidebarLayout(
      sidebarPanel(
        selectizeInput("x_var_scatter", "Select X-axis Variable", choices = NULL),
        selectizeInput("y_var_scatter", "Select Y-axis Variable", choices = NULL)
      ),
      mainPanel(
        plotlyOutput(outputId = "scatterPlot")
      )
    )
  ),
  
  # Third tab: Boxplot
  tabPanel(
    title = "Boxplot",
    sidebarLayout(
      sidebarPanel(
        selectizeInput("x_var_boxplot", "Select X-axis Variable", choices = NULL),
        selectizeInput("y_var_boxplot", "Select Y-axis Variable", choices = NULL),
        selectizeInput("cat_var", "Select Categorical Variable (for Grouping)", choices = NULL)
      ),
      mainPanel(
        plotlyOutput(outputId = "boxplot")
      )
    )
  )
)
