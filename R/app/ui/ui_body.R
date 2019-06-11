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
      tabName = "item2",
      fluidRow(
        box(title = "Select variables", width = 3, status = "success", stackerUI("stack")),
        box(title = "Data bound by row", width = 9, status = "primary", tableOutput("data_bind"))
      )
    )

    )
  )
}
