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
    nTabs <- length(data_lst)
    # create tabPanel with datatable in it
    myTabs <- lapply(seq_len(nTabs), function(i) {
      id <- paste0("varsInfo", i)
      tabPanel(paste0("Variables Info: ", names(data_lst)[i]),
               dataTableOutput(ns(id))
      )
    })
    #https://stackoverflow.com/questions/39276104/r-shiny-how-to-add-data-tables-to-dynamically-created-tabs
    do.call(tabsetPanel, myTabs)
  })

  observe({

    for(i in seq_along(data_lst)) {
      local({
        j <- i
        id <- paste0("varsInfo", j)
          output[[id]] <- renderDataTable({
            varInfo(data_lst[[j]], lab = F, uniq = T, miss = T, misschar = c("", " "))
          })
      })
    }
  })






}


ui<-fluidPage(
  variableInfoUI("varInfo")
)

server<-function(input, output, session){
  callModule(variableInfo, "varInfo", data_lst = list(mtcars = mtcars, iris = iris))
}

shinyApp(ui, server)





