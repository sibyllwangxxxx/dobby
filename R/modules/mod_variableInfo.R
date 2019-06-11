## --------------------------------------------------------------------
## Program: mod_variableInfo.R
## Date: 06/11/2019
## Author: bwang4
## Project: DQM
## Purpose: Variable information module
## Input path:
## Output path:
## --------------------------------------------------------------------

variableInfoUI <- function(id){
  ns <- NS(id)

  uiOutput(ns("varsInfo"))

}

variableInfo <- function(input, output, session, data_lst){

  ns <- session$ns

  output[["varsInfo"]] <- renderUI({
    nTabs <- length(data_lst())
    # create tabPanel with table in it
    myTabs <- lapply(seq_len(nTabs), function(i) {
      id <- paste0("varsInfo", i)
      tabPanel(paste0(" Dataset ", i, " "),
               tableOutput(ns(id))
      )
    })
    do.call(shinydashboard::tabBox, myTabs)
  })

  observe({

    for(i in seq_along(data_lst())) {
      local({
        j <- i
        id <- paste0("varsInfo", j)
          output[[id]] <- renderTable({
            varInfo(data_lst()[[j]], lab = T, uniq = T, miss = T, misschar = c("", " "))
          })
      })
    }
  })

}



if(FALSE){
ui<-fluidPage(
  tagList(
  getData2UI("getData"),
  variableInfoUI("varInfo")
  )
)

server<-function(input, output, session){
  data_list <- reactive(callModule(getData2, "getData"))
  callModule(variableInfo, "varInfo", data_lst = data_list())
}

shinyApp(ui, server)

}
