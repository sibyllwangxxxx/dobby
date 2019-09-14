source(paste0(getwd(), "/R/global.R"))
lapply(paste0(getwd(), "/R/app/ui/", list.files(paste0(getwd(), "/R/app/ui/"))), source)
lapply(paste0(getwd(), "/R/modules/", list.files(paste0(getwd(), "/R/modules/"))), source)

appFun <- function(tool = TRUE, stack = TRUE){

ui <- dashboardPage(
        error_style(),
        header = dashboardHeader(title = "Biomarker explorer"),
        sidebar = ui_sidebar(),
        body = ui_body(tool = tool, stack = stack)
)


server <- function(input, output) {

# item 1 ------------------------------------------------------------------

  ## returns a list of datasets
  data_list <- callModule(getData2, "getData")

  ## show tabs with tables of variable information
  observe(callModule(variableInfo, "varInfo", data_lst = data_list))



# item 2 ------------------------------------------------------------------

  ## return row bound data
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
  data_bind <- if(stack){
                  callModule(stacker, "stack", data_lst = data_list)
               }else{
                  reactive(bind_rows(data_list()))
               }
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

  ## filters
  data_filterDog <- callModule(filterDog, "filterDog", dat = data_bind)
  data_filterCat <- callModule(filterCat, "filterCat", dat = data_filterDog)

  output$data_prep <- renderDataTable(data_filterCat(), options = list(scrollX = TRUE))




# item 3 ------------------------------------------------------------------

  ## base spaghetti plot
  p_noodle <- callModule(spaghetti, "noodle", dat = data_filterCat)

  output$p_noodleUI <- renderUI(plotOutput("p_noodle", width = p_noodle()$w, height = p_noodle()$h))

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
  if(tool){
    output$ggiraphplot <- renderggiraph(ggiraph(code = print(p_noodle()$gg),
                                        width_svg =p_noodle()$w/100,
                                        height_svg = p_noodle()$h/100))
  }else{
    output$p_noodle <- renderPlot(p_noodle()$p)
  }
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#




# item 4 ------------------------------------------------------------------

  data_wide <- callModule(long2Wide, "l2w", dat = data_filterCat)

  output$widetb <- renderDataTable(data_wide())



# item 5 ------------------------------------------------------------------

  ## base spaghetti plot
  p_scatter <- callModule(scatter, "scatter", dat = data_wide)

  output$p_scatterUI <- renderUI(plotOutput("p_scatter", width = p_scatter()$w, height = p_scatter()$h))

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
  if(tool){
    output$scatterggiraphplot <- renderggiraph(ggiraph(code = print(p_scatter()$gg),
                                                width_svg = p_scatter()$w/100,
                                                height_svg = p_scatter()$h/100))
  }else{
    output$p_scatter <- renderPlot(p_scatter()$p)
  }
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#



# save input --------------------------------------------------------------
  observeEvent(input$save_inputs,{
    saveRDS( reactiveValuesToList(input) , file = "inputs.RDS")
  })

}


shinyApp(ui, server)
}

if(FALSE){

  lapply(paste0("data/rds/", list.files("data/rds")), readRDS) %>%
    setNames(., nm = str_remove(list.files("data/rds"), ".RDS")) %>%
    list2env(envir = .GlobalEnv)

  appFun(tool = TRUE, stack = TRUE)
}



