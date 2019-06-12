## --------------------------------------------------------------------
## Program: mod_gglog.R
## Date: 06/11/2019
## Author: bwang4
## Project: DQM
## Purpose: Module to add to ggplots for log transfer
## Input: ggplot object
## Output: ggplot object
## --------------------------------------------------------------------

gglogUI <- function(id, lab = "Change y axis to log scale"){
  ns <- NS(id)

  tagList(
    checkboxInput(ns("check"), lab),
    uiOutput(ns("scaleUI"))
  )

}

gglog <- function(input, output, session, axis = "y"){

  ns <- session$ns

  output$scaleUI <- renderUI({
    if(input$check)
      selectInput(ns("scale"),
                  "Choose scale",
                  choices = c("Natural log" = "log",
                              "Log base 2" = "log2",
                              "Log base 10" = "log10",
                              "Sqaure root" = "sqrt"))
  })

  return(reactive({
    if(!is.null(input$check))
    if(input$check){
      if(axis == "y") scale_y_continuous(trans = input$scale) else scale_x_continuous(trans = input$scale)
    }else{
      NULL
    }
  }))

}



