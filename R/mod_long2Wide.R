## --------------------------------------------------------------------
## Program: mod_long2Wide.R
## Date: 06/12/2019
## Author: bwang4
## Project: dobby
## Purpose: Create wide data from long longitudinal data
## Input:
## Output:
## --------------------------------------------------------------------



long2WideUI <- function(id){
  ns <- NS(id)

  tagList(
    uiOutput(ns("l2wUI")),
    actionButton(ns("magic"), "Reshape data")
  )
}

long2Wide <- function(input, output, session, dat = reactive(iris)){
  ns <- session$ns

  choices <- reactive(names(dat()))
  # dmchoices <- reactive({
  #   req(input$idvar)
  #   choices()[sapply(dat(), lenuniq)==3]
  # })

  output$l2wUI <- renderUI({
      tagList(
          fluidRow(
            column(width = 6,
                   selectizeInput(ns("timevar"),
                                  "Select time point variable",
                                  choices = c(NULL, choices())),
                   selectizeInput(ns("keyvar"),
                                  "Select key variable",
                                  choices = choices(),
                                  multiple = TRUE)),
            column(width = 6,
                   selectizeInput(ns("idvar"),
                                  "Select ID variable",
                                  choices = choices()),
                   selectizeInput(ns("valvar"),
                                  "Select value variable",
                                  choices = choices()))),
          fluidRow(column(width = 12,
                          selectizeInput(ns("dmvar"),
                                         "Select variables to join with wide data",
                                         choices = choices(), multiple = TRUE)))
      )

  })

  ## unite() https://community.rstudio.com/t/spread-with-multiple-value-columns/5378/2
  datw <- eventReactive(input$magic, {
    datw <- dat() %>%
            dplyr::select(!!sym(input$timevar), !!!syms(input$keyvar), !!sym(input$valvar), !!sym(input$idvar)) %>%
            unite(key, !!!syms(input$keyvar)) %>%
            spread(key = key, value = !!sym(input$valvar))
    nrow1 <- nrow(datw)
    datw <- datw %>%
            left_join(dat() %>% dplyr::select(!!!syms(input$dmvar), !!sym(input$idvar)) %>% distinct(.keep_all = T))
    nrow2 <- nrow(datw)

  validate(
    need(nrow1 == nrow2, "Variables selected to join wide table are not unique to each subject.")
  )

  #if(nrow1!=nrow2) warning("Variables selected to join wide table are not unique to each subject.")

    datw
  })


  return(reactive(datw()))

}




if(FALSE){

  #tfs <- bind_rows(tfs3b_bm2, tfs3b_bm1, nars201_bm1)

  #LB <- readRDS("P:/biib092ad/251ad201/dm/data/crt/20190401/RDS/LB.RDS")
  lb <- LB %>% filter(USUBJID %in% sample(unique(LB$USUBJID), size = 10))

  ui<-fluidPage(
    long2WideUI("long2Wide"),
    dataTableOutput("data")
  )

  server<-function(input, output, session){
    data_wide <- callModule(long2Wide, "long2Wide", dat = reactive(lb))

    output$data <- renderDataTable(data_wide())
  }

  shinyApp(ui, server)



}



