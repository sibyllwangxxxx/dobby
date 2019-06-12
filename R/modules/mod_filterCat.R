filterCatUI<-function(id){
  ns<-NS(id)

  tagList(
    actionButton(ns("add"), "Add categorical filter"),
    div(id = "meow"),
    actionButton(ns("rmv"), "Remove categorical filter")
  )

}


filterCat<-function(input, output, session, dat=reactive(iris)){

  ns<-session$ns

  ind<-reactive(input$add-input$rmv)

  observeEvent(input$add, {

    insertUI(
      selector = "#meow",
      where = "beforeBegin",
      ui = ## insertUI in module: https://groups.google.com/forum/#!topic/shiny-discuss/nHJaA79YS3w
        tagList(selectInput(ns(paste0("var", ind())),
                            label=paste0("Select variable ", input$add), choices=names(dat())),

                selectInput(ns(paste0("val", ind())),
                            label=paste0("Select value ", input$add),
                            choices=c(), multiple = TRUE)
        )
    )
  })


  observeEvent(input[[paste0("var", ind())]], {

    var<-input[[paste0("var", ind())]]


    levels<-as.character(unique(dat()[[var]]))
    updateSelectInput(session, paste0("val", ind()), choices=c("", levels), selected = "")



  })




  observeEvent(input$rmv, {

    removeUI(
      selector = paste0("div:has(>> #", ns(""), "var", ind()+1, ")")
    )

    removeUI(
      selector = paste0("div:has(>> #", ns(""), "val", ind()+1, ")")
    )
  })



  data_out<-reactive({

    data_out<-dat()

    if(ind()==0) return(data_out)

    for(i in seq_len(ind())){

      shiny::req(input[[paste0("var", i)]], input[[paste0("val", i)]])

      var<-data_out[[input[[paste0("var", i)]]]]
      val<-input[[paste0("val", i)]]

      if(length(val) == 1 && val == " ") return(data_out)

      data_out<-data_out[var %in% val,]
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
      filterCatUI("filter")
    ),
    mainPanel(
      tableOutput("table")
    )
  )
)

server<-function(input, output, session){

  filtered_data<-callModule(filterCat, "filter", dat=reactive(mtcars))

  output$table<-renderTable({

    if(is.null(filtered_data())) return(invisible())

    filtered_data()
  })

}

shinyApp(ui, server)
}
