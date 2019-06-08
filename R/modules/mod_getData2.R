## --------------------------------------------------------------------
## Program: mod_getData1.R
## Date: 06/08/2019
## Author: bwang4
## Project: SMA Shiny
## Purpose: Shiny module for getting single dataset
## Input: path, pattern
## Output: single dataset
## --------------------------------------------------------------------

source("R/global.R")


getDataUI<-function(id){

  ns<-NS(id)

  fluidPage(
    selectInput(ns("dataset"), "Select a dataset", choices=c("iris", "mtcars")),

    strong("OR"),
    br(),

    fileInput(ns("userFile"), label="Upload file",
              buttonLabel="Upload", placeholder="CSV - Excel - RDS - SAS",
              multiple=FALSE, accept=c(".csv", ".xlsx", ".rds", ".sas7bdat")),

    uiOutput(ns("sheetUI"))
  )

}



getData<-function(input, output, session){

  dataHere<-reactiveValues(data=NULL,
                           sampleData=NULL,
                           uploadData=NULL)

  observe(priority = 10, {

    req(input$dataset)

    dataHere$sampleData<-lapply(c("mtcars", "iris"), function(txt)eval(parse(text=txt)))

  })


  sheets<-eventReactive(input$userFile, {

    if(!is.null(input$userFile)){

      file_ext <- toupper(regmatches(input$userFile$name, regexpr(input$userFile$name, pattern='\\.(.+)$')))
      ext_i <- match(file_ext, c('.CSV', '.XLS', '.XLSX', '.RDS'))

      if(!is.na(ext_i)&ext_i%in%2:3)
        excel_sheets(input$userFile$datapath)
    }
  })

  output$sheetUI<-renderUI({
    ns<-session$ns

    if(!is.null(input$userFile)){

      file_ext <- toupper(regmatches(input$userFile$name, regexpr(input$userFile$name, pattern='\\.(.+)$')))
      ext_i <- match(file_ext, c('.CSV', '.XLS', '.XLSX', '.RDS'))

      if(!is.na(ext_i)&ext_i%in%2:3)
        selectInput(ns("sheet"), "Choose sheet (only for .xlsx)", choices = sheets())
    }
  })


  observeEvent(input$userFile, priority = 10, {

    file_ext <- toupper(regmatches(input$userFile$name, regexpr(input$userFile$name, pattern='\\.(.+)$')))

    ext_i <- match(file_ext, c('.CSV', '.XLS', '.XLSX', '.RDS'))

    if (!is.na(ext_i))
      if (ext_i > 3) {
        dataHere$uploadData <- readRDS(input$userFile$datapath) %>% as.data.frame() # %>% stringsAsFactors()
      } else if (ext_i == 1) {
        #read_FUN <- if (ext_i == 1) { read_csv } else { read_excel }

        dataHere$uploadData <- suppressWarnings(read_csv(input$userFile$datapath, col_names = TRUE,
                                                         trim_ws = FALSE, guess_max = 1000, na=c('', '-', 'NA', 'NULL'))) %>%
          as.data.frame() #%>% stringsAsFactors()

      }

  })



  observe({
    if(!is.null(input$userFile)){

      file_ext <- toupper(regmatches(input$userFile$name, regexpr(input$userFile$name, pattern='\\.(.+)$')))

      ext_i <- match(file_ext, c('.CSV', '.XLS', '.XLSX', '.RDS'))

      if (!is.na(ext_i) & ext_i %in% 2:3)

        dataHere$uploadData <- suppressWarnings(read_excel(input$userFile$datapath, col_names = TRUE, sheet = input$sheet,
                                                           trim_ws = FALSE, guess_max = 1000, na=c('', '-', 'NA', 'NULL')#,
                                                           #.name_repair = "unique"
        )) %>%
        as.data.frame()


    }

  })




  observeEvent(input$dataset, {
    dataHere$data<-dataHere$sampleData %>% mutate(URID=1:n())
  })

  observe({
    if(!is.null(dataHere$uploadData)){
      data_cleanname<-dataHere$uploadData
      names(data_cleanname)<-gsub(" ", "_", names(data_cleanname))
      names(data_cleanname)<-gsub("-", "_", names(data_cleanname))
      names(data_cleanname)<-gsub("%", "P_", names(data_cleanname))
      #data_cleanname<-as.data.frame(lapply(data_cleanname, function(v)gsub("/", ".", v)))
      #data_cleanname<-as.data.frame(lapply(data_cleanname, function(v)gsub("[a-zA-Z]+-[a-zA-Z]", ".", v)))

      dataHere$data<-data_cleanname %>% mutate(URID=1:n())
    }
  })

  return(reactive(dataHere$data))

}














ui<-fluidPage(
  getData1UI("stack")
)

sever<-function(input, output, session){
  callModule(getData1, "stack")
}

shinyApp(ui, server)




