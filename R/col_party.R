col_party <- function(...){

  list_names <- lapply(list(...), names)
  union_names <- Reduce(dplyr::union, list_names)
  intersect_names <- Reduce(dplyr::intersect, list_names)
  unique_in_datasets <- lapply(list_names, function(vec)vec[!vec %in% intersect_names])

  res <- list(list_names = list_names,
              union_names = union_names,
              intersect_names = intersect_names,
              unique_in_datasets = unique_in_datasets)

  return(res)

}

col_party(mtcars, iris)
