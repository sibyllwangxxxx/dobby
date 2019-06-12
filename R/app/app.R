source("C:/Users/bwang4/dobby/R/global.R")
lapply(paste0("C:/Users/bwang4/dobby/R/app/ui/", list.files("C:/Users/bwang4/dobby/R/app/ui/")), source)
lapply(paste0("C:/Users/bwang4/dobby/R/modules/", list.files("C:/Users/bwang4/dobby/R/modules/")), source)

ui <- dashboardPage(
        error_style(),
        header = dashboardHeader(title = "Biomarker explorer"),
        sidebar = ui_sidebar(),
        body = ui_body()
)


server <- function(input, output) {

  DATA <- reactiveValues(data = NULL)


# item 1 ------------------------------------------------------------------

  ## returns a list of datasets
  data_list <- callModule(getData2, "getData")
  observe(DATA$data <- data_list)

  ## show tabs with tables of variable information
  observe(callModule(variableInfo, "varInfo", data_lst = DATA$data))



# item 2 ------------------------------------------------------------------

  ## return row bound data
  data_bind <- callModule(stacker, "stack", data_lst = DATA$data)

  ## filters
  data_filterDog <- callModule(filterDog, "filterDog", dat = data_bind)
  data_filterCat <- callModule(filterCat, "filterCat", dat = data_filterDog)

  output$data_prep <- renderDataTable(data_filterCat(), options = list(scrollX = TRUE))


# item 3 ------------------------------------------------------------------

  ## base spaghetti plot
  p_noodle <- callModule(spaghetti, "noodle", dat = data_filterCat)

  output$p_noodle <- renderPlot(p_noodle()$p)

}


shinyApp(ui, server)



