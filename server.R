library(shiny)
library(ggplot2)
library(dplyr)

# Server
server <- function(input, output, session) {
  
  # Reactive expression to read the uploaded file or use default dataset
  user_data <- reactive({
    if (is.null(input$file1)) {
      mtcars  # Default dataset
    } else {
      read.csv(input$file1$datapath, stringsAsFactors = TRUE)
    }
  })
  
  # Update selectize inputs for scatter plot and boxplot once the data is loaded
  observe({
    updateSelectizeInput(session, "x_var_scatter", choices = colnames(user_data()))
    updateSelectizeInput(session, "y_var_scatter", choices = colnames(user_data()))
    updateSelectizeInput(session, "x_var_boxplot", choices = colnames(user_data()))
    updateSelectizeInput(session, "y_var_boxplot", choices = colnames(user_data()))
    updateSelectizeInput(session, "cat_var", choices = colnames(user_data()))
  })
  
  # Render the interactive data table
  output$data_table <- renderDT({
    datatable(user_data(), options = list(pageLength = 10, searchable = TRUE, sortable = TRUE))
  })
  
  # Render the summary statistics
  output$data_summary <- renderPrint({
    summary(user_data())
  })
  
  # Render the dataset structure
  output$data_structure <- renderPrint({
    str(user_data())
  })
  
  # Render the NA value checker
  output$na_checker <- renderTable({
    na_count <- sapply(user_data(), function(x) sum(is.na(x)))
    data.frame(Variable = names(na_count), NA_Count = na_count)
  })
  
  # Render the interactive scatter plot
  output$scatterPlot <- renderPlotly({
    req(input$x_var_scatter, input$y_var_scatter)
    data <- user_data() %>% select(input$x_var_scatter, input$y_var_scatter)
    p <- ggplot(data, aes_string(x = input$x_var_scatter, y = input$y_var_scatter)) +
      geom_point(color = "blue") +
      labs(
        title = paste(input$y_var_scatter, "vs", input$x_var_scatter),
        x = input$x_var_scatter,
        y = input$y_var_scatter
      ) +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # Render the interactive boxplot
  output$boxplot <- renderPlotly({
    req(input$x_var_boxplot, input$cat_var, input$y_var_boxplot)
    data <- user_data() %>% select(input$x_var_boxplot, input$cat_var, input$y_var_boxplot)
    p <- ggplot(data, aes_string(x = input$x_var_boxplot, y = input$y_var_boxplot, fill = input$cat_var)) +
      geom_boxplot(color = "black") +
      labs(
        title = paste("Boxplot of", input$y_var_boxplot, "by", input$x_var_boxplot),
        x = input$x_var_boxplot,
        y = input$y_var_boxplot
      ) +
      theme_minimal()
    
    ggplotly(p)
  })
}
