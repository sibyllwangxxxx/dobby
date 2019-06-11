ui_sidebar <- function(){
  bs4DashSidebar(
  skin = "light",
  status = "primary",
  title = "Biomarker exploratory",
  brandColor = "primary",
  # url = "https://www.google.fr",
  # src = "https://adminlte.io/themes/AdminLTE/dist/img/user2-160x160.jpg",
  elevation = 3,
  opacity = 0.8,
  bs4SidebarMenu(
    bs4SidebarHeader("Header 1"),
    bs4SidebarMenuItem(
      "Item 1",
      tabName = "item1",
      icon = "sliders"
    ),
    bs4SidebarMenuItem(
      "Item 2",
      tabName = "item2",
      icon = "id-card"
    )
  )
)
}
