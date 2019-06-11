ui_sidebar <- function(){
  dashboardSidebar(
  sidebarMenu(
    menuItem("Upload data", tabName = "item1", icon = icon("arrows")),
    menuItem("Bind data by row", tabName = "item2", icon = icon("arrows")),
    menuItem("Reshape data", tabName = "item3", icon = icon("arrows"))
  )
)
}
