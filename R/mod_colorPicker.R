## --------------------------------------------------------------------
## Program: colorPicker.R
## Date: 06/12/2019
## Author: bwang4
## Project: dobby
## Purpose: Module to add colorPickers; default to ggplot2 palette
## Input: # of colors
## Output: string of color names
## --------------------------------------------------------------------

colorPickerUI<-function(id, lab="Pick colors"){
  ns<-NS(id)

  tagList(
    tipify(checkboxInput(ns("pick"), lab), placement="bottom",
           "Show a pop-up window to customize colors for groups. When unclicked, default colors are applied.")
  )
}


colorPicker<-function(input, output, session, ncolor=3, default="black"){

  ## pop-up window for picking colors
  observe({
    ns<-session$ns

    if(isTRUE(input$pick))
      showModal(
        modalDialog(
          lapply(1:isolate(ncolor()), function(i) {
            id<-paste0("col", i)
            label<-paste0("Select color ", i)
            colourpicker::colourInput(ns(id), label, palette="limited", value=default)
          }),
          footer=modalButton("Done"),
          easyClose=TRUE
        )
      )
  })



  palette<-reactive({
    ## if "pick" is checked, use user input colors
    if(isTRUE(input$pick)){
      pal<-c()
      for(i in 1:isolate(ncolor())){
        pal<-c(pal, input[[paste0("col", i)]])
      }
      ## an arbitrary (5 here) number of default colors
      ## are added to remind users when increasing "num",
      ## more colors need to be selected
      c(pal, rep(default, 5))
    }else{
      ## if "pick" is unchecked, use scales::hue_pal() colors
      scales::hue_pal()(ncolor())
    }
  })

  return(reactive({palette()}))

}


## shiny
if(TRUE){
library(shiny)
library(shinyWidgets)
library(shinyBS)

ui<-fluidPage(
  introjsUI(),
  titlePanel("Shiny module colorPicker demo"),
  br(),
  actionButton("btn","Press me"),
  textOutput("palette"),
  colorPickerUI("pickcolors"),
  numericInput("num", "Number of colors", min=1, max=10, value=5),
  actionButton("update", "Update plot"),
  plotOutput("plot")
  )

server<-function(input, output, session){

  palette<-callModule(colorPicker, "pickcolors", ncolor=reactive(input$num))

  p <- eventReactive(input$update,{
    plot(1:input$num, rep(5, input$num), cex=5, col=palette(), pch=19,
         main="Demo plot", xlab="", ylab="")
  })

  output$plot<-renderPlot(p())

  output$palette<-renderPrint({
    palette()
  })



  steps <- reactive(data.frame(element = c(NA,
                                           "#btn",
                                           "#num",
                                           "#pickcolors-pick"),

                               intro = c("This is a help page",
                                         "This is a button",
                                         "Number of colors",
                                         "Check to pick colors")))

  observeEvent(input$btn,{
    introjs(session, options = list(steps=steps()))

  })


}

shinyApp(ui=ui, server=server)
}
