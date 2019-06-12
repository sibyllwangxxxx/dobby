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
        tabBox(title = "Prepare data", id = "prep",
               width = 4,
               tabPanel("Bind by row", stackerUI("stack"), id = "byrow"),
               tabPanel("Filter (continuous)", filterDogUI("filterDog"), id = "ollie"),
               tabPanel("Filter (categorical)", filterCatUI("filterCat"), id = "denny")
               ),
        box(title = "Data", width = 8, status = "primary", dataTableOutput("data_prep"))
        )
      )
    )
  )
}
