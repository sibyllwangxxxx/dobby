ui_navbar <- function(){
  bs4DashNavbar(
  skin = "light",
  status = "white",
  border = TRUE,
  sidebarIcon = "bars",
  controlbarIcon = "th",
  fixed = FALSE,
  leftUi = bs4DropdownMenu(
    show = TRUE,
    align = "left",
    status = "warning",
    menuIcon = "envelope-open",
    src = NULL
  ),
  rightUi = bs4DropdownMenu(
    show = FALSE,
    status = "danger",
    src = "https://www.google.fr",
    bs4DropdownMenuItem(
      text = "message 1",
      date = "today"
    ),
    bs4DropdownMenuItem(
      text = "message 2",
      date = "yesterday"
    )
  )
)
}
