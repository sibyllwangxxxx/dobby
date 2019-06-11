## --------------------------------------------------------------------
## Program: mod_getData2.R
## Date: 06/09/2019
## Author: bwang4
## Project: SMA Shiny
## Purpose: Shiny module for getting datasets of same format
## Input:
## Output: list of datasets
## Note: only take first sheet of Excel by default
## --------------------------------------------------------------------


getData2UI<-function(id){

  ns<-NS(id)

  fluidPage(
    selectInput(ns("dataset"), "Select a dataset", choices=c("iris", "mtcars"),
                selected = c("iris"), multiple = TRUE),

    strong("OR"),
    br(),
    br(),

    fileInput(ns("userFile"), label="Upload file",
              buttonLabel="Upload", placeholder="CSV - Excel - RDS - SAS",
              multiple=TRUE, accept=c(".csv", ".xlsx", ".rds", ".sas7bdat"))
  )

}



getData2<-function(input, output, session, URID = FALSE, tbl = TRUE){

  dataHere<-reactiveValues(data=NULL, sampleData=NULL, uploadData=NULL)


  # get sample data ---------------------------------------------------------
  observe(priority = 10, {
    req(input$dataset)
    dataHere$sampleData<-lapply(input$dataset, function(df)eval(parse(text = df)))
  })


  # get file extension ------------------------------------------------------
  ext <- eventReactive(input$userFile, {
    file_ext <- toupper(regmatches(input$userFile$name[1], regexpr(input$userFile$name[1], pattern='\\.(.+)$')))
    match(file_ext, c('.CSV', '.XLS', '.XLSX', '.RDS', '.SAS7BDAT'))
  })


  # load rds and csv ---------------------------------------------------------
  observeEvent(input$userFile, priority = 10, {

    if (!is.na(ext()))
      if(ext() == 4) { ## rds
        dataHere$uploadData <- lapply(input$userFile$datapath, function(path) readRDS(path) %>% as.data.frame())

      }else if(ext() == 1) { ## csv

        dataHere$uploadData <- lapply(input$userFile$datapath, function(path) {
                                      suppressWarnings(read_csv(path, col_names = TRUE,
                                                                guess_max = 1000, na=c('', '-', 'NA', 'NULL'))) %>% as.data.frame()
                               })

      }else if(ext() == 5) { ## sas
        dataHere$uploadData <- lapply(input$userFile$datapath, function(path) haven::read_sas(path) %>% as.data.frame())
      }

  })

  # load excel --------------------------------------------------------------
  observe({
    if(!is.null(input$userFile)){

      if (!is.na(ext()) & ext() %in% 2:3)

        dataHere$uploadData <- lapply(input$userFile$datapath, function(path) {
                                      suppressWarnings(read_csv(path, col_names = TRUE,
                                                       guess_max = 1000, na=c('', '-', 'NA', 'NULL'))) %>% as.data.frame()
                               })
    }

  })




  # everytime sample data updates overwrite dataHere$data to sample data -------------
  observeEvent(input$dataset, {
    ## add URID if needed
    dataHere$data<-lapply(dataHere$sampleData, function(df) if(URID) df %>% mutate(URID = 1:n()) else df)
  })


  # otherwise uoloadData set as dataHere$data
  observe({
    if(!is.null(dataHere$uploadData)){
      dataHere$data<-lapply(dataHere$uploadData, function(df) if(URID) df %>% mutate(URID = 1:n()) else df)
    }
  })

  return(reactive(lapply(dataHere$data, function(df) if(tbl) as_tibble(df) else df)))
  #return(reactive(dataHere$data))

}

## demo
ui<-fluidPage(
  fluidRow(
    column(width=4, getData2UI("getData")),
    column(width=8,
           textOutput("class"),
           #uiOutput("dt"),
           verbatimTextOutput("tmp"))
  )
)

server<-function(input, output, session){
  data<-callModule(getData2, "getData")

  output$tmp <- renderPrint(data())

  # output$dt<-renderUI({
  #   lapply(as.list(seq_along(data())), function(i) {
  #     id <- paste0("dt", i)
  #     tableOutput(id)
  #   })
  # })
  #
  # observe({
  #   counter <- 0
  #     for (i in seq_along(data())) {
  #       id <- paste0("dt", i)
  #       counter <- counter + 1
  #       output[[id]] <- renderTable(data()[[counter]])
  #     }
  # })

  #output$class <- renderText(class(data()))
}

shinyApp(ui, server)
