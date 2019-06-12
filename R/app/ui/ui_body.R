ui_body <- function(){
  dashboardBody(
    tabItems(

      tabItem(
        tabName = "item1",
        fluidRow(
          box(title = "Upload datasets", width = 4, status = "success", getData2UI("getData")),
          box(title = "Variables in datasets", width = 8, status = "info", variableInfoUI("varInfo"))
        )
      ),

    tabItem(
      tabName = "item2",
      fluidRow(
        tabBox(title = "Prepare data", id = "prep",
               width = 4,
               tabPanel("Bind by row", stackerUI("stack")),
               tabPanel("Filter (continuous)", filterDogUI("filterDog")),
               tabPanel("Filter (categorical)", filterCatUI("filterCat"))),

        box(title = "Data", width = 8, status = "primary", dataTableOutput("data_prep"))
        )
      ),

    tabItem(
      tabName = "item3",

      box(title = "Control widgets", width = 4, status = "warning",
          # column(width = 6, gglogUI("logy", lab = "Change y axis to log scale")),
          # column(width = 6, gglogUI("logx", lab = "Change x axis to log scale")),
          spaghettiUI("noodle")
          ),

      box(title = "Spaghetti plot", width = 8, status = "info",
          plotOutput("p_noodle"))
    )

    )
  )
}
