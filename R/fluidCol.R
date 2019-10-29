## --------------------------------------------------------------------
## Program: fluidCol.R
## Date: 06/21/2019
## Author: bwang4
## Project: Go/No-Go 
## Purpose: You'll see
## Input path: 
## Output path: 
## --------------------------------------------------------------------

fluidCol <- function(obj) {
  fluidRow(column(width = 12, obj))
}

fluidCol2 <- function(obj1, obj2, wleft = 6) {
  fluidRow(column(width = wleft, obj1),
           column(width = 12-wleft, obj2))
}
