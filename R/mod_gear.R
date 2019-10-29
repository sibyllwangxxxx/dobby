## --------------------------------------------------------------------
## Program: mod_gear.R
## Date: 06/12/2019
## Author: bwang4
## Project: dobby
## Purpose: Module for change title, asix labels, footnote, size of point, thickness of line, dimension of plot
## Input path:
## Output path:
## --------------------------------------------------------------------

gearUI <- function(id){
  ns <- NS(id)

  tagList(
    ## title, footnote
    fluidRow(column(width=6, editTitleUI(ns("editPlotTitle"))),
             column(width=6, editTitleUI(ns("editFootnote"), "Edit Footnote"))),

    fluidRow(column(width=6, editTitleUI(ns("editXlab"), "Edit x label")),
             column(width=6, editTitleUI(ns("editYlab"), "Edit Y label"))),

    fluidRow(column(width = 6, numericInput(ns("pointsize"), "Point size", value=1, min=0.5, step=0.5, max=5)),
             column(width = 6)),

    fluidRow(column(width=6, sliderInput(ns("width"), "Width", step=10, min=400, max=1200, value=900)),
             column(width=6, sliderInput(ns("height"), "Height", step=10, min=400, max=1200, value=650)))
  )

  # shinyWidgets::dropdownButton(
  #   tags("Edit appearance"),
  #   fluidRow(column(width = 6),
  #            column(width = 6)),
  #   circle = TRUE,
  #   status = "danger",
  #   icon = icon("gear"),
  #   width = "300px",
  #   tooltip = tooltipOptions(title = "Edit title, asix labels, footnote, size of point, thickness of line, dimension of plot"))


}

gear <- function(input, output, session){

  ns <- session$ns

  userTitle <- callModule(editTitle, "editPlotTitle")
  userXlab <- callModule(editTitle, "editXlab")
  userYlab <- callModule(editTitle, "editYlab")
  userFootnote <- callModule(editTitle, "editFootnote")

  return(reactive(list(
          userTitle = userTitle(),
          userXlab = userXlab(),
          userYlab = userYlab(),
          userFootnote = userFootnote(),
          pointsize = input$pointsize,
          width = input$width,
          height = input$height
  )))


}


if(FALSE){

  ui<-fluidPage(
    gearUI("gear"),
    verbatimTextOutput("text")
  )

  server<-function(input, output, session){
    res <- callModule(gear, "gear")

    output$text <- renderPrint(res())
  }

  shinyApp(ui, server)


}
