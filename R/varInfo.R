## --------------------------------------------------------------------
## Program: varInfo.R
## Date: 06/10/2019
## Author: bwang4
## Project: DQM
## Purpose: Function to summarize variale informations and out in a table
## Input path:
## Output path:
## --------------------------------------------------------------------

## helper pmissing
pmiss <- function(v, misschar=NULL) sum(is.na(v) | v %in% misschar)/length(v)
if(FALSE){
  pmiss(c(1, "", NA))
  pmiss(c(1, "", NA), "")
}

varInfo <- function(df, lab = FALSE, uniq = FALSE, miss = FALSE, nrw = FALSE, misschar = NULL){
  tb <- NULL

  if(!is.null(df)){
    tb <- tibble(names = names(df))
    tb <- if(lab) tb %>% mutate(labels = unlist(sapply(df, function(col)attr(col, "label")))) else tb
    tb <- if(uniq) tb %>% mutate(`unique values` = sapply(df, function(col)length(unique(col)))) else tb
    tb <- if(nrw) tb %>% mutate(`number of rows` = sapply(df, function(col)length(col))) else tb
    tb <- if(miss) tb %>% mutate(`percent missing` = sapply(df, function(col)paste0(round(pmiss(col, misschar = misschar)*100, 3), "%"))) else tb
  }

  return(tb)
}

if(FALSE)
  varInfo(mtcars, T, T, T, T, c("", " ")) %>% View()

if(FALSE)
  varInfo(nars201_bm1, T, T, T, T, c("", " ")) %>% View()
