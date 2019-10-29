## --------------------------------------------------------------------
## Program: checkPackages.R
## Date: 06/10/2019
## Author: bwang4
## Project: dobby
## Purpose: Check what packages are used in all R files in a directory
## Input path:
## Output path:
## --------------------------------------------------------------------

checkPacks<-function(path){

  ## get all R files in your directory
  ## by the way, extract R code from Rmd: http://felixfan.github.io/extract-r-code/
  files<-list.files(path)[str_detect(list.files(path), ".R$")]

  ## extract all functions and which package they are from
  ## using NCmisc::list.functions.in.file
  funs<-unlist(lapply(paste0(path, "/", files), list.functions.in.file))
  packs<-funs %>% names()

  ## "character" functions such as reactive objects in Shiny
  characters<-packs[str_detect(packs, "^character")]

  ## user defined functions in the global environment
  globals<-packs[str_detect(packs, "^.GlobalEnv")]

  ## functions that are in multiple packages' namespaces
  multipackages<-packs[str_detect(packs, ", ")]

  ## get just the unique package names from multipackages
  mpackages<-multipackages %>%
    str_extract_all(., "[a-zA-Z0-9]+") %>%
    unlist() %>%
    unique()
  mpackages<-mpackages[!mpackages %in% c("c", "package")]

  ## functions that are from single packages
  packages<-packs[str_detect(packs, "package:") & !packs %in% multipackages] %>%
    str_replace(., "[0-9]+$", "") %>%
    str_replace(., "package:", "")

  ## unique packages
  packages_u<-packages %>%
    unique() %>%
    union(., mpackages)

  return(list(packs=packages_u, tb=table(packages)))

}

#checkPacks("H:/DataQualityMonitoring/bwang4")
