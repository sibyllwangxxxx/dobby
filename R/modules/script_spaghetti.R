## --------------------------------------------------------------------
## Program: script_spaghetti.R
## Date: 06/12/2019
## Author: bwang4
## Project: dobby
## Purpose: script to get mod_spaghetti results
## Input:
## Output:
## --------------------------------------------------------------------

scr_spaghetti <- function(id, dat = iris, legend_p = "bottom"){

  input <- readRDS("inputs.RDS")

  xvar <- input[[paste0(id, "-xvar")]]
  yvar <- input[[paste0(id, "-yvar")]]
  idvar <- input[[paste0(id, "-idvar")]]
  grpvar <- input[[paste0(id, "-grpvar")]]
  ylog <- input[[paste0(id, "-ylog-check")]]
  pointsize <- input[[paste0(id, "-gear-pointsize")]]
  pal <- if(!input[[paste0(id, "-colors-pick")]]) scale::hue_pal(lenuniq(dat[[grpvar]])) else sapply(str_subset(names(input), paste0(id, "-colors-col[0-9]?")), function(nm)input[[nm]])

  x_ticks <- unique(dat[[xvar]])
  base_p <-  ggplot(dat, aes(x = !!sym(xvar), y = !!sym(yvar), group = !!sym(idvar), color = !!sym(grpvar))) +
                    scale_x_continuous(breaks = x_ticks, labels = x_ticks) +
                    theme_light() +
                    theme(plot.title=element_text(hjust=0.5),
                          text=element_text(size=20),
                          legend.position=legend_p) +
                    #scale_colour_manual(values = pal) +
                    if(ylog) scale_y_continuous(trans = input[[paste0(id, "-ylog-scale")]]) else NULL +
                    labs(color = grpvar)

  p <- if(grpvar == "None"){
          base_p + geom_point(size=pointsize) + geom_line()
       }else{
          base_p + geom_point(size=pointsize) + geom_line()
       }

  p

}

if(FALSE){

lapply(paste0("data/rds/", list.files("data/rds")), readRDS) %>%
    setNames(., nm = str_remove(list.files("data/rds"), ".RDS")) %>%
    list2env(envir = .GlobalEnv)
noodle_data <- bind_rows(list(nars201_bm1, nars201_bm2_csf))


## demo
(p <- scr_spaghetti(id = "noodle", dat = noodle_data))
p + scale_color_manual(values = c("green", "red")) +
    facet_grid(facets = "SEX~.")
str(p)

}
