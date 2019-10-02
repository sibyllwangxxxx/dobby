library(plotly)
library(shiny)
library(dplyr)

fakebm <- function(paramname){
  data.frame(id = rep(c(101, 102, 103, 104), c(4, 5, 2, 5)),
             param = rep(paramname, sum(c(4, 5, 2, 5)))) %>% 
    mutate(sex = case_when(id %in% c(101, 102) ~ "Female",
                           id %in% c(103, 104) ~ "Male")) %>% 
    group_by(id) %>% 
    mutate(time = 1:n()) %>% 
    ungroup() 
}

bm <- bind_rows(fakebm("A"), fakebm("B")) %>% 
      mutate(val = c(rnorm(sum(c(4, 5, 2, 5)), 100, 10), rnorm(sum(c(4, 5, 2, 5)), 10, 1)))

ui <- fluidPage(
  mainPanel(
    plotlyOutput("scatter1"),
    plotlyOutput("scatter2")
  ),
  verbatimTextOutput("selection")
)

server <- function(input, output, session) {
  output$scatter1 <- renderPlotly({
    dat <- filter(bm, param == "A")
    ggplotly(ggplot(dat, aes(x=time, y=val, group = id, customdata = id)) + geom_point() + geom_line())
  })
  
  output$selection <- renderPrint({
    s <- event_data("plotly_click")
    if (length(s) == 0) {
      "Click on a cell in the line plot to display a line plot"
    } else {
      cat("You selected: \n\n")
      s$customdata
    }
  })

  output$scatter2<- renderPlotly({
    s <- event_data("plotly_click")
    if (length(s) == 0) {
      ggplotly(ggplot())
    } else {
      dat <- filter(bm, param == "B", id == s$customdata)
      ggplotly(ggplot(dat, aes(x=time, y=val, customdata = id)) + geom_point() + geom_line())
    }
  })
  
}

shinyApp(ui, server)