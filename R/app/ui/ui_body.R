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
        tabBox(title = "Prepare data",
               width = 4,
               tabPanel("Bind by row", stackerUI("stack")),
               tabPanel("Filter (categorical)", filterCatUI("filterCat"))
               ),
        box(title = "Data", width = 8, status = "primary", dataTableOutput("data_prep"))
        )
      )
    )
  )
}
