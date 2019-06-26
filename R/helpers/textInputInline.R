## --------------------------------------------------------------------
## Program: textInputInline.R
## Date: 06/21/2019
## Author: bwang4
## Project: Go/No-Go
## Purpose: textInput with inline label on the left using css style and HTML
## Input: 
## Output: 
## Note: https://stackoverflow.com/questions/20850483/how-to-put-a-box-and-its-label-in-the-same-row-shiny-package
## --------------------------------------------------------------------

textInputInline <- function(inputId, label, value = "", placeholder = NULL, bold = FALSE, label_width = 45, blank_width = 0){
  
  lb_width <- paste0(label_width, "%")
  blk_width <- paste0(blank_width, "%")
  ui_width <- paste0(100-label_width-blank_width, "%")
  
  tagList(
    
    tags$head(
      tags$style(type="text/css", "#inline label{ display: table-cell; text-align: left; vertical-align: middle; } 
                                   #inline .form-group { display: table-row;}")
    ),
    
    tags$div(id = "inline", 
             tags$table(
               tags$tr(width = "100%",
                       tags$td(width = lb_width, if(bold) div(style = "font-weight:bold;", label) else div(label)),
                       tags$td(width = blk_width),
                       tags$td(width = ui_width, textInput(inputId, label = NULL, 
                                                           value = value, width = "100%", 
                                                           placeholder = placeholder)))
             ))
  )
  
}


if(FALSE){

library(shiny)

ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(textInputInline("txt", "Set seed", value = 1, placeholder = "Enter a numeric value"),
                 textInputInline("txt2", "Set seed 2", value = 1, placeholder = "Enter a numeric value"),
                 textInput("txt3", "Set seed 3", value = 1, placeholder = "Enter a numeric value")),
    mainPanel(fluidRow(textOutput("txtout")),
              fluidRow(textOutput("txtout2")),
              fluidRow(textOutput("txtout3")))
  )
  
)

server <- function(input, output, session) {
  output$txtout <- renderText(input$txt)
  output$txtout2 <- renderText(input$txt2)
  output$txtout3 <- renderText(input$txt3)
}

shinyApp(ui, server)
}