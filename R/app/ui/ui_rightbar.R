ui_rightbar <- function(){
  bs4DashControlbar(
    skin = "light",
    width = 300,
    title = "Uplaod data",
    getData2UI("getData")
  )
}
