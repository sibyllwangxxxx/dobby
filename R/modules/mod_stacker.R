## --------------------------------------------------------------------
## Program: mod_stacker.R
## Date: 06/08/2019
## Author: bwang4
## Project: SMA Shiny
## Purpose: Shiny module for stacking datasets with similar structure
## Input path:
## Output path:
## --------------------------------------------------------------------

source("R/global.R")

stackerUI <- function(id, path){
  ns <- NS(id)


  tagList(

      selectInput()
  )

}

stacker <- function(input, output, session, path){

}



ui<-fluidPage(
  stackerUI("stack")
)

sever<-function(input, output, session){
  callModule(stacker, "stack")
}

shinyApp(ui, server)




