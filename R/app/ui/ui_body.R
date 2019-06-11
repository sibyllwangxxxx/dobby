ui_body <- function(){
  bs4DashBody(
    bs4TabItems(
      bs4TabItem(
        tabName = "item1",
            bs4Box(
              height = "1200px",
              title = "Variables, number of unique values, missing",
              fluidRow(
              variableInfoUI("varInfo"))
            )
      ),

    bs4TabItem(
      tabName = "item2"
    ),

    bs4TabItem(
      tabName = "item3"
    )

    )
  )
}
