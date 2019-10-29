## --------------------------------------------------------------------
## Program: fss.R
## Date: 07/24/2019
## Author: bwang4
## Project: dobby
## Purpose: Find people who possess fen shen shu
## Parameters: data, id_var
## Product: data filtered to only include entries from individuals who have fen shen shu
## --------------------------------------------------------------------
fss <- function(data, id_var){
  id_var <- enquo(id_var)
  fss_id <- data %>%
              group_by(!!id_var) %>%
              summarise(n = n()) %>%
              filter(n > 1) %>%
              pull(!!id_var)
  data %>%
    filter(!!id_var %in% fss_id) %>%
    arrange(!!id_var)
}

if (FALSE){
  fss(tibble(id = c("a", "a", "b", "c", "d", "d"),
             val = sample(1:100, 6)), id)
}
