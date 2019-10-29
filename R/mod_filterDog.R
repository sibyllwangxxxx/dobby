filterDogUI<-function(id){
  ns<-NS(id)

  tagList(
    actionButton(ns("add"), "Add continuous filter"),
    div(id = "woof"),
    actionButton(ns("rmv"), "Remove continuous filter")
  )

}


filterDog<-function(input, output, session, dat=reactive(iris)){

  ns<-session$ns

  ind<-reactive(input$add-input$rmv)

  observeEvent(input$add, {

    insertUI(
      selector = "#woof",
      where = "beforeBegin",
      ui = ## insertUI in module: https://groups.google.com/forum/#!topic/shiny-discuss/nHJaA79YS3w
        tagList(selectInput(ns(paste0("var", ind())),
                            label=paste0("Select variable ", input$add), choices=names(dat())),

                textInput(ns(paste0("txt", ind())),
                          label=paste0("Type condition ", input$add), value = " ")
        )

    )
  })



  observeEvent(input$rmv, {

    removeUI(
      selector = paste0("div:has(>> #", ns(""), "var", ind()+1, ")")
    )

    removeUI(
      selector = paste0("div:has(> #", ns(""), "txt", ind()+1, ")")
    )
  })



  data_out<-reactive({

    data_out<-dat()

    if(ind()==0) return(data_out)

    for(i in seq_len(ind())){

      shiny::req(input[[paste0("var", i)]], input[[paste0("txt", i)]])

      var_name<-input[[paste0("var", i)]]
      txt<-input[[paste0("txt", i)]]

      if(txt==" ") return(data_out)

      tryCatch_fun<-function(code){
        tryCatch(code,
                 error=function(e)"Please type valid condition!")
      }

      tryCatch_fun(data_out<-data_out %>% filter_(paste0(var_name, txt)))

    }

    data_out

  })


  return(reactive(data_out()))



}



## shiny
if(FALSE){
ui<-fluidPage(
  sidebarLayout(
    sidebarPanel(
      filterDogUI("filter")
    ),
    mainPanel(
      tableOutput("table")
    )
  )
)

server<-function(input, output, session){

  filtered_data<-callModule(filterDog, "filter", dat=reactive(mtcars))

  output$table<-renderTable({

    if(is.null(filtered_data())) return(invisible())

    filtered_data()
  })

}

shinyApp(ui, server)
}
