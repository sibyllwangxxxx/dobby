ui_body <- function(){
  bs4DashBody(
    bs4TabItems(
      bs4TabItem(
        tabName = "item1",

        fluidRow(
          verbatimTextOutput("data")
        ),

        fluidRow(
          lapply(1:3, FUN = function(i) {
            bs4Sortable(
              width = 4,
              p(class = "text-center", paste("Column", i)),
              lapply(1:2, FUN = function(j) {
                bs4Card(
                  title = paste0("I am the ", j,"-th card of the ", i, "-th column"),
                  width = 12,
                  "Click on my header"
                )
              })
            )
          })
        )
      ),
      bs4TabItem(
        tabName = "item2",
        bs4Card(
          title = "Card with messages",
          width = 9,
          userMessages(
            width = 12,
            status = "success",
            userMessage(
              author = "Alexander Pierce",
              date = "20 Jan 2:00 pm",
              src = "https://adminlte.io/themes/AdminLTE/dist/img/user1-128x128.jpg",
              side = NULL,
              "Is this template really for free? That's unbelievable!"
            ),
            userMessage(
              author = "Dana Pierce",
              date = "21 Jan 4:00 pm",
              src = "https://adminlte.io/themes/AdminLTE/dist/img/user5-128x128.jpg",
              side = "right",
              "Indeed, that's unbelievable!"
            )
          )
        )
      )
    )
  )
}
