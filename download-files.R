library(tidyverse)

filepath <-
  "href.list.RData"

load(filepath)

urls <- 
  unlist(href.list)

raw_image_dir <- 
  "raw-images/"

# Check for files

existing_files <- 
  list.files(path = raw_image_dir)


for (i in 1:length(urls)) {
  
  print(i)
  
  this_url <- 
    urls[i]
  
  this_file <- 
    gsub("https://upload.wikimedia.org/wikipedia/commons/archive/4/4f/", 
         "",
         this_url)
  
  if (this_file %in% existing_files) next
  
  download.file(this_url, 
                destfile = paste0(raw_image_dir, 
                                  this_file))
  
}