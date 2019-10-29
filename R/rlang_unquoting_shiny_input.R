library(shiny)

ui <- fluidPage(
  selectInput("var", "Select var", choices=names(iris), selected=names(iris)[1]),
  textInput("newname", "Type new var name", value="newvar"),
  verbatimTextOutput("txt"),
  tableOutput("tb")
)

server <- function(input, output, session) {

  output$txt<-renderText(input$newname)

  output$tb<-renderTable({
    library(rlang)
    iris %>% mutate(!!input$newname:=10+!!rlang::sym(input$var))
  })

}

if(FALSE)
shinyApp(ui, server)
