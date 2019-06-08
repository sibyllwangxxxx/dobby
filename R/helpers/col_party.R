col_party <- function(...){

  # dots_values() and flatten found in bind_rows()
  # x <- flatten_bindable(dots_values(...))
  x <- rlang::dots_values(...) %>% rlang::flatten()

  list_names <- lapply(x, names)
  union_names <- Reduce(dplyr::union, list_names)
  intersect_names <- Reduce(dplyr::intersect, list_names)
  unique_in_datasets <- lapply(list_names, function(vec)vec[!vec %in% intersect_names])

  res <- list(list_names = list_names,
              union_names = union_names,
              intersect_names = intersect_names,
              unique_in_datasets = unique_in_datasets)

  return(res)

}

if(FALSE){
col_party(list(mtcars, iris))
col_party(mtcars, iris, cars)
all.equal(col_party(mtcars, iris, cars), col_party(list(mtcars, iris, cars)))
}

