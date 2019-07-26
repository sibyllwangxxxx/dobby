## --------------------------------------------------------------------
## Program: mod_editTitle.R
## Date: 06/12/2019
## Author: bwang4
## Project: dobby
## Purpose: Module for editting plot titles/labs
## Input:
## Output: text
## --------------------------------------------------------------------

editTitleUI<-function(id, label="Edit plot title"){
  ns<-NS(id)

  tagList(
    checkboxInput(ns("edit"), label),
    uiOutput(ns("titleUI")))
}


editTitle<-function(input, output, session, val = "Default"){

  ns<-session$ns

  output$titleUI<-renderUI({
    if(isTRUE(input$edit)){
      textInput(ns("titleIn"), "", placeholder="Type here", value = val)
    }
  })

  return(reactive({if(isTRUE(input$edit)) input$titleIn else NULL}))
}

## shiny
if(FALSE){
ui<-pageWithSidebar(headerPanel("Demo"),
                    sidebarPanel(
                      editTitleUI("title"),
                      editTitleUI("xlab", "Edit x-axis label")
                    ),
                    mainPanel(
                      plotOutput("plot")
                    ))

server<-function(input, output, session){

  title_default <- "Scatterplot of horse power vs mpg in mtcars"
  title_module<-callModule(editTitle, "title", val = title_default)
  title<-reactive(ifelse(is.null(title_module()), title_default, title_module()))

  xlab_module<-callModule(editTitle, "xlab", val = "hp")
  xlab<-reactive(ifelse(is.null(xlab_module()), "hp", xlab_module()))

  output$plot<-renderPlot({
    ggplot(data=mtcars, aes(hp, mpg)) +
      geom_point() +
      ggtitle(title()) +
      labs(x = xlab()) +
      theme(plot.title=element_text(hjust=0.5))
  })

}

shinyApp(ui, server)
}
