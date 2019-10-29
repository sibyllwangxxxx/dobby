## --------------------------------------------------------------------
## Program: error_style.R
## Date: 06/12/2019
## Author: bwang4
## Project: dobby
## Purpose: Shiny validation error style
## Input:
## Output:
## --------------------------------------------------------------------

error_style <- function(){
       tags$head(tags$style(HTML("
                      .shiny-output-error-validation {
                          color: red;
                          font-size: 20px;
                          }
                          ")))
}
