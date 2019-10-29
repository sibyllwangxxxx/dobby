## --------------------------------------------------------------------
## Program: script_getData2.R
## Date: 06/12/2019
## Author: bwang4
## Project: dobby
## Purpose: script to get mod_getData results
## Input:
## Output:
## --------------------------------------------------------------------

scr_getData2<- function(id, path, URID = TRUE, tbl = TRUE) {

  input <- readRDS("inputs.RDS")

  dataHere<-list(data=NULL, sampleData=NULL, uploadData=NULL)


  # get sample data ---------------------------------------------------------

    dataHere$sampleData<-lapply(input[[paste0(id, "-dataset")]], function(df)eval(parse(text = df)))

  if(is.null(input[[paste0(id, "-userFile")]])){
    dataHere$data <- dataHere$sampleData
  }else{

    # get file extension ------------------------------------------------------
    file_ext <- toupper(regmatches(input[[paste0(id, "-userFile")]]$name[1], regexpr(input[[paste0(id, "-userFile")]]$name[1], pattern='\\.(.+)$')))
    ext <- match(file_ext, c('.CSV', '.XLS', '.XLSX', '.RDS', '.SAS7BDAT'))


    # load rds and csv ---------------------------------------------------------
    load_path <- paste0(path, input[[paste0(id, "-userFile")]]$name)
    if(ext == 4) { ## rds
      dataHere$uploadData <- lapply(load_path, function(path) readRDS(path) %>% as.data.frame())

    }else if(ext == 1) { ## csv

      dataHere$uploadData <- lapply(load_path, function(path) {
        read_csv(path, col_names = TRUE, guess_max = 1000, na=c('', '-', 'NA', 'NULL')) %>% as.data.frame()
      })

    }else if(ext == 5) { ## sas
      dataHere$uploadData <- lapply(load_path, function(path) haven::read_sas(path) %>% as.data.frame())
    }

    dataHere$data <- dataHere$uploadData

  }

  return(dataHere$data)

}

if(FALSE)
scr_getData2("getData", path = "C:/Users/bwang4/dobby/data/rds/")



