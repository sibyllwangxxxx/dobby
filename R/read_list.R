## --------------------------------------------------------------------
## Program: read_list.R
## Date: 06/10/2019
## Author: bwang4
## Project: dobby
## Purpose: read a list of datasets
## Input path:
## Output path:
## --------------------------------------------------------------------

read_list <- function(list_of_datasets, read_func){

  read_and_assign <- function(dataset, read_func){
    dataset_name <- as.name(dataset)
    dataset_name <- read_func(dataset)
  }

  # invisible is used to suppress the unneeded output
  output <- invisible(
    sapply(list_of_datasets,
           read_and_assign, read_func = read_func, simplify = FALSE, USE.NAMES = TRUE))

  # Remove the extension at the end of the data set names
  names_of_datasets <- c(unlist(strsplit(list_of_datasets, "[.]"))[c(T, F)])
  names(output) <- names_of_datasets
  return(output)
}

if(FALSE){
files <- list.files("/camhpc/home/bwang4/dobby/data/sas")
data <- read_list(paste0("/camhpc/home/bwang4/dobby/data/sas/", files), haven::read_sas) %>%
        setNames(., nm = str_remove(files, ".sas7bdat"))

list2env(data, envir = .GlobalEnv)
}
