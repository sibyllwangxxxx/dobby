## --------------------------------------------------------------------
## Program: numericInputInline.R
## Date: 06/21/2019
## Author: bwang4
## Project: Go/No-Go
## Purpose: numericInput with inline label on the left using css style and HTML
## Input: 
## Output: 
## Note: https://stackoverflow.com/questions/20850483/how-to-put-a-box-and-its-label-in-the-same-row-shiny-package
## --------------------------------------------------------------------

numericInputInline <- function(inputId, label, value, min = NA, max = NA, step = NA, width = "50%"){
  
  tagList(
    
    tags$head(
      tags$style(type="text/css", "#inline label{ display: table-cell; text-align: left; vertical-align: middle; } 
                                   #inline .form-group { display: table-row;}")
      ),
    
    tags$div(id = "inline", 
             tags$table(
               tags$tr(width = "100%",
                       tags$td(width = "35%", div(style = "font-weight:bold;", label)),
                       tags$td(width = "5%"),
                       tags$td(width = "60%", numericInput(inputId, label = NULL, 
                                                           value = value, min = min, max = max, 
                                                           step = step, width = "100%")))
             ))
  )
  
}


if(FALSE){
  
  library(shiny)
  
  ui <- fluidPage(
    
    sidebarLayout(
      sidebarPanel(numericInputInline("num", "Set seed", value = 1, min = 1, max = 20, step = 1),
                   numericInputInline("num2", "Set seed 2", value = 0, min = 0, max = 20, step = 5),
                   numericInput("num3", "Set seed 3", value = 5, min = 0, max = 20, step = 0.5)),
      mainPanel(fluidRow(verbatimTextOutput("numout")),
                fluidRow(verbatimTextOutput("numout2")),
                fluidRow(verbatimTextOutput("numout3")))
    )
    
  )
  
  server <- function(input, output, session) {
    output$numout <- renderPrint(input$num)
    output$numout2 <- renderPrint(input$num2)
    output$numout3 <- renderPrint(input$num3)
  }
  
  shinyApp(ui, server)
}
