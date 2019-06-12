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

gglog <- function(input, output, session, p, axis = "y"){

  ns <- session$ns

  output$scaleUI <- renderUI({
    selectInput(ns("scale"), "Choose scale", choices = c("log2", "log10", "natural log"))
  })

  return(eventReactive(input$check, {
    if(input$check){
      if(axis == "y") p() + scale_y_continuous(trans = input$scale) else p() + scale_x_continuous(trans = input$scale)
    }else{
      p()
    }
  }))

}



