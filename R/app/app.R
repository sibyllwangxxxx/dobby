source("C:/Users/bwang4/dobby/R/global.R")
lapply(paste0("C:/Users/bwang4/dobby/R/app/ui/", list.files("C:/Users/bwang4/dobby/R/app/ui/")), source)
lapply(paste0("C:/Users/bwang4/dobby/R/modules/", list.files("C:/Users/bwang4/dobby/R/modules/")), source)

ui <- dashboardPage(
  header = dashboardHeader(title = "Biomarker explorer"),
  sidebar = ui_sidebar(),
  body = ui_body()
)


server <- function(input, output) {


# item 1 ------------------------------------------------------------------

  ## returns a list of datasets
  data_list <- reactive(callModule(getData2, "getData"))
  ## show tabs with tables of variable information
  observe(callModule(variableInfo, "varInfo", data_lst = data_list()))



# item 2 ------------------------------------------------------------------

  ## return row bound data
  data_bind <- callModule(stacker, "stack", data_lst = data_list())

  ## filterCat
  data_filterCat <- callModule(filterCat, "filterCat", dat = reactive(data_bind()))

  ## dataTableOutput
  output$data_prep <- renderDataTable(data_filterCat(), options = list(scrollX = TRUE))

}


shinyApp(ui, server)



