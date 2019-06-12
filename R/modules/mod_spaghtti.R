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
    fluidRow(
      column(width = 6,
             selectInput(ns("xvar"), "Choose X variable", choices = choices()),
             selectInput(ns("yvar"), "Choose Y variable", choices = choices()),
             gglogUI(ns("ylog"), lab = "Change Y scale")),
      column(width = 6,
             selectInput(ns("idvar"), "Choose ID variable", choices = choices()),
             selectInput(ns("grpvar"), "Choose group variable", choices = c("None", choices())),
             colorPickerUI(ns("colors")))

    )
  })

  palette<-callModule(colorPicker, "colors", ncolor=reactive(if(input$grpvar == "None") 1 else lenuniq(dat()[[input$grpvar]])))
  ylog <- callModule(gglog, "ylog")

  datp <- reactive({
            dat() %>%
            mutate(grpvar = if(input$grpvar == "None") "None" else as.character(.[[input$grpvar]]),
                   xvar = .[[input$xvar]],
                   yvar = .[[input$yvar]],
                   idvar = .[[input$idvar]],
                   tooltip = paste0("X = ", xvar, "\n", "Y = ", yvar, "\n", "ID = ", idvar))
          })

  p <- reactive({

        req(input$xvar, input$yvar, input$idvar, input$grpvar)

        validate(
          need(is.numeric(datp()$xvar), "Choose numeric X variable."),
          need(is.numeric(datp()$yvar), "Choose numeric Y variable.")
        )

        x_ticks <- unique(datp()$xvar)
        p <- ggplot(datp(), aes(x = xvar, y = yvar, group = idvar, tooltip = tooltip)) +
                scale_x_continuous(breaks = x_ticks, labels = x_ticks) +
                theme_light() +
                theme(plot.title=element_text(hjust=0.5),
                      text=element_text(size=20),
                      legend.position="bottom") +
                scale_colour_manual(values=palette())

        p <- if(input$grpvar == "None"){
          p + geom_point() + geom_line()
        }else{
          p + geom_point(aes(color = grpvar)) + geom_line(aes(color = grpvar))
        }

        p + ylog()
  })


  gg <- reactive({

    req(input$xvar, input$yvar, input$idvar, input$grpvar)

    validate(
      need(is.numeric(datp()$xvar), "Choose numeric X variable."),
      need(is.numeric(datp()$yvar), "Choose numeric Y variable.")
    )

    x_ticks <- unique(datp()$xvar)
    gg <- ggplot(datp(), aes(x = xvar, y = yvar, group = idvar, tooltip = tooltip)) +
              scale_x_continuous(breaks = x_ticks, labels = x_ticks) +
              theme_light() +
              theme(plot.title=element_text(hjust=0.5),
                    text=element_text(size=20),
                    legend.position="bottom") +
              scale_colour_manual(values=palette()) +
              ylog()

    gg <- if(input$grpvar == "None"){
      gg + geom_point_interactive(aes(tooltip = tooltip)) + geom_line()
    }else{
      gg + geom_point_interactive(aes(color = grpvar, tooltip = tooltip)) + geom_line(aes(color = grpvar))
    }

    gg

  })


  return(reactive(list(yvar = input$yvar,
                        xvar = input$xvar,
                        idvar = input$idvar,
                        grpvar = input$grpvar,
                        p = p(),
                        gg = gg())))

}


if(FALSE){

ui <- fluidPage(
  spaghettiUI("spaghetti"),
  plotOutput("plot"),
  ggiraphOutput("ggiraphplot")
)


server <- function(input, output, session){
  res <- callModule(spaghetti, "spaghetti", dat = reactive(nars201_bm1))

  output$plot <- renderPlot(res()$p)

  output$ggiraphplot <- renderggiraph({
    ggiraph(code = print(res()$gg))
  })
}

shinyApp(ui, server)

}





