## --------------------------------------------------------------------
## Program: mod_long2Wide.R
## Date: 06/12/2019
## Author: bwang4
## Project: dobby
## Purpose: Create wide data from long longitudinal data
## Input:
## Output:
## --------------------------------------------------------------------

tfs <- bind_rows(tfs3b_bm2, tfs3b_bm1, nars201_bm1)
tfs_wide <- tfs %>% dplyr::select(VISIT, USUBJID, PARAM, AVAL)
tfs_wide <- tfs_wide %>% spread(key = PARAM, value = AVAL)
tfs_wide <- tfs_wide %>% left_join(tfs %>% select(AGE, SEX, TYPE, USUBJID) %>% distinct(.keep_all = T))


long2WideUI <- function(id){
  ns <- NS(id)

  tagList(

  )
}

long2Wide <- function(input, output, session, dat = reactive()){
  ns <- session
}




if(FALSE){
  ui<-fluidPage(
    long2WideUI("long2Wide")
  )

  server<-function(input, output, session){
    callModule(long2Wide, "long2Wide")
  }

  shinyApp(ui, server)



}



