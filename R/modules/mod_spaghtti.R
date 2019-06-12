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
          fluidRow(
            column(width = 6,
                   selectInput(ns("xvar"), "Choose X variable", choices = choices()),
                   selectInput(ns("yvar"), "Choose Y variable", choices = choices()),
                   gglogUI(ns("ylog"), lab = "Change Y scale")),
            column(width = 6,
                   selectInput(ns("idvar"), "Choose ID variable", choices = choices()),
                   selectInput(ns("grpvar"), "Choose group variable", choices = c("None", choices())),
                   colorPickerUI(ns("colors")))),
          fluidRow(
            dropdownButton(
              tags$h3("Edit appearance"),
              circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
              tooltip = tooltipOptions(title = "Click to edit appearance of plot!"),

              gearUI(ns("gear"))))
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



  # appearance from gear ----------------------------------------------------

  gears <- callModule(gear, "gear")

  ggTitle<-reactive({
    ifelse(is.null(gears()$userTitle),
           if(input$grpvar=="None"){
             paste0("Spaghetti plot of ", input$xvar, " vs ", input$yvar)
           }else{
             paste0("Spaghetti plot of ", input$xvar, " vs ", input$yvar, " by ", input$grpvar)
           },
           gears()$userTitle)
  })

  ggXlab<-reactive(if(is.null(gears()$userXlab)) input$xvar else gears()$userXlab)
  ggYlab<-reactive(if(is.null(gears()$userYlab)) input$yvar else gears()$userYlab)
  ggFootnote<-reactive(if(is.null(gears()$userFootnote)) "" else gears()$userFootnote)


  base_p <- reactive({
    x_ticks <- unique(datp()$xvar)
    ggplot(datp(), aes(x = xvar, y = yvar, group = idvar, tooltip = tooltip)) +
      scale_x_continuous(breaks = x_ticks, labels = x_ticks) +
      theme_light() +
      theme(plot.title=element_text(hjust=0.5),
            text=element_text(size=20),
            legend.position="bottom") +
      scale_colour_manual(values=palette()) +
      ylog()
  })


  p <- reactive({

        req(input$xvar, input$yvar, input$idvar, input$grpvar)

        validate(
          need(is.numeric(datp()$xvar), "Choose numeric X variable."),
          need(is.numeric(datp()$yvar), "Choose numeric Y variable.")
        )

        # x_ticks <- unique(datp()$xvar)
        # p <- ggplot(datp(), aes(x = xvar, y = yvar, group = idvar, tooltip = tooltip)) +
        #         scale_x_continuous(breaks = x_ticks, labels = x_ticks) +
        #         theme_light() +
        #         theme(plot.title=element_text(hjust=0.5),
        #               text=element_text(size=20),
        #               legend.position="bottom") +
        #         scale_colour_manual(values=palette()) +
        #         ylog()

        p <- if(input$grpvar == "None"){
          base_p() + geom_point(size=gears()$pointsize) + geom_line()
        }else{
          base_p + geom_point(aes(color = grpvar), size=gears()$pointsize) +
                   geom_line(aes(color = grpvar))
        }

        p + labs(title = ggTitle(), x=ggXlab(), y=ggYlab(), caption=ggFootnote())
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
      gg + geom_point_interactive(aes(tooltip = tooltip), size=gears()$pointsize) + geom_line()
    }else{
      gg + geom_point_interactive(aes(color = grpvar, tooltip = tooltip), size=gears()$pointsize) +
           geom_line(aes(color = grpvar))
    }

    gg  + labs(title = ggTitle(), x=ggXlab(), y=ggYlab(), caption=ggFootnote())

  })




  return(reactive(list(yvar = input$yvar,
                        xvar = input$xvar,
                        idvar = input$idvar,
                        grpvar = input$grpvar,
                        p = p(),
                        gg = gg(),
                        w = gears()$width,
                        h = gears()$height)))

}


if(FALSE){

ui <- fluidPage(
  spaghettiUI("spaghetti"),
  uiOutput("plotUI"),
  ggiraphOutput("ggiraphplot")
)


server <- function(input, output, session){

  res <- callModule(spaghetti, "spaghetti", dat = reactive(nars201_bm1))

  output$plotUI <- renderUI({
    plotOutput("plot",
               width = res()$w,
               height = res()$h)
  })

  output$plot <- renderPlot(res()$p)

  output$ggiraphplot <- renderggiraph({
    ggiraph(code = print(res()$gg),
            width_svg = res()$w/100,
            height_svg = res()$h/100)
  })
}

shinyApp(ui, server)

}





