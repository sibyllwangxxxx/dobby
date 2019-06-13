ui_sidebar <- function(){
  dashboardSidebar(
  sidebarMenu(
    menuItem("Upload data", tabName = "item1", icon = icon("arrows")),
    menuItem("Prepare data", tabName = "item2", icon = icon("arrows")),
    menuItem("Spaghetti plot", tabName = "item3", icon = icon("arrows")),
    menuItem("Reshape data", tabName = "item4", icon = icon("arrows")),
    actionButton("save_inputs", "Save inputs")
  )
)
}
