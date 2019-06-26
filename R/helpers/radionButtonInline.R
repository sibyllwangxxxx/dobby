## --------------------------------------------------------------------
## Program: radioButtonsInline.R
## Date: 06/21/2019
## Author: bwang4
## Project: Go/No-Go
## Purpose: radioButtons with inline label on the left using css style and HTML
## Input: 
## Output: 
## Note: https://stackoverflow.com/questions/20850483/how-to-put-a-box-and-its-label-in-the-same-row-shiny-package
## --------------------------------------------------------------------

radioButtonsInline <- function(inputId, label, choices = NULL, selected = NULL, inline = FALSE, 
                               choiceNames = NULL, choiceValues = NULL, bold = FALSE,
                               label_width = 45, blank_width = 0){
  
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
                       tags$td(width = ui_width, radioButtons(inputId, label = NULL, choices = choices, selected = selected, inline = inline, 
                                                   width = "100%", choiceNames = choiceNames, choiceValues = choiceValues)))
             ))
  )
  
}


if(FALSE){
  
  library(shiny)
  
  ui <- fluidPage(
    
    sidebarLayout(
      sidebarPanel(radioButtonsInline("txt", "Set seed", choices = letters[1:3], selected = NULL, inline = TRUE, blank_width = 5),
                   radioButtonsInline("txt2", "Set seed 2", choices = LETTERS[1:3], selected = NULL, inline = FALSE),
                   radioButtons("txt3", "Set seed 3", choices = letters[15:18], selected = NULL, inline = FALSE)),
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