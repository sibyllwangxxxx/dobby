## --------------------------------------------------------------------
## Program: sourcesub.R
## Date: 06/27/2019
## Author: bwang4
## Project: dobby
## Purpose: source all files in a subfolder
## --------------------------------------------------------------------

sourcesub <- function(path) {
  lapply(paste0(path, list.files(path)), source)
}






