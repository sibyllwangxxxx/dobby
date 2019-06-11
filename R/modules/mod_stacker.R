## --------------------------------------------------------------------
## Program: mod_stacker.R
## Date: 06/08/2019
## Author: bwang4
## Project: SMA Shiny
## Purpose: Shiny module for stacking datasets with similar structure
## Input: a list of datasets
## Output: side effects + a stacked dataset
## --------------------------------------------------------------------

stackerUI <- function(id){
  ns <- NS(id)

  tagList(
    verbatimTextOutput(ns("tmp")),
    uiOutput(ns("intersectUI")),
    br(),
    uiOutput(ns("vars")),
    actionButton(ns("update"), "Bind data")
  )


}

stacker <- function(input, output, session, data_lst){

  ns <- session$ns

  varnames <- reactive(col_party(data_lst()))
  lst <- reactive(seq_along(varnames()$unique_in_datasets))

  output$intersectUI <- renderUI({
    selectizeInput(ns("intersect_names"), "Common variable names",
                   choices = varnames()$intersect_names,
                   selected = varnames()$intersect_names,
                   multiple = TRUE)
  })

  output[["vars"]] <- renderUI({

    lapply(lst(), function(i) {
      id <- paste0("vars", i)
      selectizeInput(ns(id), paste0("Select unique variable in dataset ", i),
                     choices = varnames()$unique_in_datasets[[i]],
                     selected = varnames()$unique_in_datasets[[i]],
                     multiple = TRUE)
    })
  })

  return(eventReactive(input$update, {
    vars <- c(input$intersect_names, sapply(lst(), function(i)input[[paste0("vars", i)]]) %>% unlist())
    bind_rows(data_lst())[,vars]
  }))

}



if(FALSE){
  ui<-pageWithSidebar(
    headerPanel = headerPanel(title = ""),
    sidebarPanel = sidebarPanel(
                    getData2UI("getData"),
                    stackerUI("stack")),
    mainPanel = mainPanel(tableOutput("tb"))
  )

  server<-function(input, output, session){
    data_list <- reactive(callModule(getData2, "getData"))
    data_bind <- callModule(stacker, "stack", data_lst = data_list())

    output$tb <- renderTable(data_bind())
  }

  shinyApp(ui, server)

}


