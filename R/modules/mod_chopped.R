library(shiny)
library(ggplot2)
library(colourpicker)
library(dplyr)
library(RColorBrewer)
library(DT)
library(stringr)
library(scales)
library(rlang)
library(shinyBS)

source("global.R")
data(iris)

##++++++++++++++ chopped +++++++++++++##
choppedUI<-function(id, data=iris, lab="Create categorical variables from continuous variables"){
  ns<-NS(id)
  
  tagList(
    tipify(checkboxInput(ns("chop"), lab), placement="bottom", 
           "Show a pop-up window to create new categorical variables from continuous variables.")
  )
}


chopped<-function(input, output, session, data=iris){
  
  ns<-session$ns
  
  observe({
    contVars<-names(data)[lapply(data, class) %in% c("numeric", "integer")]
    
    if(isTRUE(input$chop))
      showModal(
        modalDialog(
          
          helpText('Choose a continuous variable and create a categorical variable by "cutting" it. 
                   The cut points should include the min and max of the continuous variable, otherwise 
                   data not in range will not display in the plot. After creating the new categorical 
                   variables, they can be found as subgroup options.'),
          
          selectInput(ns("numvar"), "Select a numeric variable", 
                      choices=contVars, selected=contVars[1]),
          verbatimTextOutput(ns("summary")),
          textInput(ns("cuts"), "Type cut points", value="0,5,10"),
          textInput(ns("newvar"), "Type new variable name", value="newvar"),
          footer=modalButton("Done"),
          easyClose=TRUE
          )
        )
  })
  
  output$summary<-renderPrint({
    summary(unlist(data[,input$numvar]))
  })
  
  dat<-reactive({
    
    if(isFALSE(input$chop)){
      data
      
    }else if(isTRUE(input$chop)){
      
      numvec<-unlist(data[,input$numvar])
      cuts<-as.numeric(unlist(str_extract_all(input$cuts, "[0-9]+")))
      
      if(is.numeric(numvec)&length(cuts)>=2)
        data[[input$newvar]]<-cut(numvec, cuts)
      data
    }
  })
  
  return(reactive({dat()}))
  
}


ui<-fluidPage(
  choppedUI("test"),
  uiOutput("datUI"),
  #tableOutput("tb"),
  plotOutput("p")
)

server<-function(input, output, session){
  dat<-callModule(chopped, "test") 
  
  output$datUI<-renderUI({
    tagList(
      selectInput("contvar", "Select continuous var",
                  choices=names(dat()), selected=names(dat())[1]),
      selectInput("catvar", "Select categorical var",
                  choices=names(dat()), selected=names(dat())[5])
    )
  })
  
  # output$tb<-renderTable({
  #   if(is.character(input$catvar)&is.character(input$contvar))
  #   dat() %>% select(!!rlang::sym(input$catvar), !!rlang::sym(input$contvar))
  # })
  
  output$p<-renderPlot({
    if(is.character(input$catvar)&is.character(input$contvar))
      ggplot(dat(), aes(x=!!rlang::sym(input$catvar), y=!!rlang::sym(input$contvar))) +
      geom_boxplot()
  })
}

shinyApp(ui, server)





