library(shiny)
library(dplyr)
library(ggplot2)
library(rlang)
library(stringr)
library(tidyr)
library(shinyWidgets)
library(shinyBS)
library(shinydashboard)
library(kableExtra)
library(scales)
library(colourpicker)
library(ggiraph)

library(NCmisc) ## checkPackages.R
library(Hmisc)

library(readr)
library(readxl)
library(xlsx)
library(haven)
#library(data.table)


# source all helper files -------------------------------------------------

lapply(paste0("C:/Users/bwang4/dobby/R/helpers/", list.files("C:/Users/bwang4/dobby/R/helpers/")), source)

lapply(paste0("C:/Users/bwang4/dobby/data/rds/", list.files("C:/Users/bwang4/dobby/data/rds")), readRDS) %>%
  setNames(., nm = str_remove(list.files("C:/Users/bwang4/dobby/data/rds"), ".RDS")) %>%
  list2env(envir = .GlobalEnv)

