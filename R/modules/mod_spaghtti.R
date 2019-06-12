## --------------------------------------------------------------------
## Program: mod_spaghetti.R
## Date: 06/11/2019
## Author: bwang4
## Project: DQM
## Purpose: Base spaghetti module
## Input: data
## Output: ggplot2 obj
## --------------------------------------------------------------------

spaghettiUI <- function(id){
  ns <- NS(id)

  uiOutput(ns("varsUI"))

}

spaghetti <- function(input, output, session, dat = reactive(iris)){

  ns <- session$ns

  choices <- reactive(names(dat()))

  output$varsUI <- renderUI({
    tagList(
      selectInput(ns("yvar"), "Choose Y variable", choices = choices()),
      selectInput(ns("xvar"), "Choose X variable", choices = choices()),
      selectInput(ns("grpvar"), "Choose group variable", choices = choices())
    )
  })

  p <- reactive({
        yvar <- sym(input$yvar)
        xvar <- sym(input$xvar)
        grpvar <- sym(input$grpvar)
        x_ticks <- unique(dat()[[input$xvar]])

        ggplot(dat(), aes_string(x = input$xvar, y = input$yvar, group = input$grpvar)) +
          geom_point() +
          geom_line() +
          scale_x_continuous(breaks = x_ticks, labels = x_ticks) +
          theme_light()
  })

  return(reactive(list(yvar = input$yvar,
                        xvar = input$xvar,
                        grpvar = input$grpvar,
                        p = p())))

}


if(FALSE){

ui <- fluidPage(
  spaghettiUI("spaghetti"),
  plotOutput("plot")
)


server <- function(input, output, session){
  res <- callModule(spaghetti, "spaghetti", dat = reactive(nars201_bm1))
  output$plot <- renderPlot(res()$p)
}

shinyApp(ui, server)

}





