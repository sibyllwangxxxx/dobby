## --------------------------------------------------------------------
## Program: mod_getData2.R
## Date: 06/08/2019
## Author: bwang4
## Project: SMA Shiny
## Purpose: Shiny module for getting single dataset
## Input: path, pattern
## Output: single dataset
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
              multiple=TRUE, accept=c(".csv", ".xlsx", ".rds", ".sas7bdat"))#,

    #uiOutput(ns("sheetUI"))
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
    file_ext <- toupper(regmatches(input$userFile$name, regexpr(input$userFile$name, pattern='\\.(.+)$')))
    match(file_ext, c('.CSV', '.XLS', '.XLSX', '.RDS', '.SAS7BDAT'))
  })


  # # excel sheet UI ----------------------------------------------------------
  # sheets<-eventReactive(input$userFile, {
  #   if(!is.na(ext()) & ext()%in%2:3) excel_sheets(input$userFile$datapath)
  # })
  #
  # output$sheetUI<-renderUI({
  #   ns<-session$ns
  #   if(!is.na(ext()) & ext()%in%2:3) selectInput(ns("sheet"), "Choose sheet (only for .xlsx)", choices = sheets())
  # })

  # load rds and csv ---------------------------------------------------------
  observeEvent(input$userFile, priority = 10, {

    if (!is.na(ext()))
      if(ext() == 4) { ## rds
        dataHere$uploadData <- readRDS(input$userFile$datapath) %>% as.data.frame()

      }else if(ext() == 1) { ## csv

        dataHere$uploadData <- suppressWarnings(read_csv(input$userFile$datapath, col_names = TRUE,
                                                         trim_ws = FALSE, guess_max = 1000, na=c('', '-', 'NA', 'NULL'))) %>%
          as.data.frame()

      }else if(ext() == 5) { ## sas
        dataHere$uploadData <- haven::read_sas(input$userFile$datapath) %>% as.data.frame()
      }

  })

  # load excel --------------------------------------------------------------
  observe({
    if(!is.null(input$userFile)){

      if (!is.na(ext()) & ext() %in% 2:3)

        dataHere$uploadData <- suppressWarnings(read_excel(input$userFile$datapath, col_names = TRUE, sheet = input$sheet,
                                                           trim_ws = FALSE, guess_max = 1000, na=c('', '-', 'NA', 'NULL'))) %>%
          as.data.frame()

    }

  })




  # everytime sample data updates overwrite dataHere$data to sample data -------------
  observeEvent(input$dataset, {
    ## add URID if needed
    dataHere$data<-lapply(as.list(input$dataset), function(df) if(URID) df %>% mutate(URID = 1:n()) else df)
  })


  # otherwise uoloadData set as dataHere$data
  observe({
    if(!is.null(dataHere$uploadData)){
      dataHere$data<-if(URID) dataHere$uploadData %>% mutate(URID=1:n()) else dataHere$uploadData
    }
  })

  return(reactive(lapply(dataHere$data, function(df) if(tbl) as_tibble(df) else df)))

}

## demo
ui<-fluidPage(
  fluidRow(
    column(width=4, getData2UI("getData")),
    column(width=8,
           textOutput("class"),
           verbatimTextOutput("tmp"),
           uiOutput("data"))
  )
)

server<-function(input, output, session){
  data<-callModule(getData2, "getData")

  output$tmp <- renderPrint(data())

  output$data<-renderUI({
    lapply(as.list(seq_along(input$dataset)), function(i) {
      id <- paste0("data", i)
      DT::dataOutput(id)
    })
  })

  observe({
  for (i in seq_along(input$dataset)) {
    id <- paste0("data", i)
    output[[id]] <- DT::renderDataTable(data()[[i]])
  }
  })


  #output$class <- renderText(class(data()))
}

shinyApp(ui, server)
