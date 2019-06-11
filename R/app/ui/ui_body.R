ui_body <- function(){
  dashboardBody(
    tabItems(

      tabItem(
        tabName = "item1",
        fluidRow(
          box(title = "Upload datasets", width = 3, status = "success", getData2UI("getData")),
          box(title = "Variables in datasets", width = 9, status = "info", variableInfoUI("varInfo"))
        )
      ),

    tabItem(
      tabName = "item2"
    )

    )
  )
}
