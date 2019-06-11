source("~/dobby/R/global.R")
source("~/dobby/R/app/ui/ui_sidebar.R")

ui <- bs4DashPage(
  old_school = FALSE,
  sidebar_collapsed = TRUE,
  controlbar_collapsed = FALSE,
  title = "Basic Dashboard",
  navbar = bs4DashNavbar(),
  sidebar = ui_sidebar(),
  #controlbar = bs4DashControlbar(),
  footer = bs4DashFooter(),
  body = bs4DashBody()
)


server <- function(input, output) {}


shinyApp(ui, server)



