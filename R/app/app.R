source("~/dobby/R/global.R")
lapply(paste0("~/dobby/R/app/ui/", list.files("~/dobby/R/app/ui/")), source)
lapply(paste0("~/dobby/R/modules/", list.files("~/dobby/R/modules/")), source)

ui <- bs4DashPage(
  old_school = FALSE,
  sidebar_collapsed = TRUE,
  controlbar_collapsed = FALSE,
  title = "Basic Dashboard",
  #navbar = ui_navbar(),
  navbar = bs4DashNavbar(),
  sidebar = ui_sidebar(),
  controlbar = ui_rightbar(),
  footer = ui_footer(),
  body = ui_body()
)


server <- function(input, output) {

  ## returns a list of datasets
  data_list <- reactive(callModule(getData2, "getData"))

  ## show tabs with tables of variable information
  observe(callModule(variableInfo, "varInfo", data_lst = data_list()))

}


shinyApp(ui, server)



