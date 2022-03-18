library(tidyverse)
library(rvest)
library(stringr)

filepath <-
  "href.list.RData"

url_seed <- 
  "https://commons.wikimedia.org/w/index.php?title=File:2022_Russian_invasion_of_Ukraine.svg&dir=prev#filehistory"


if (!file.exists(filepath)) {
  
  href.list <-
    list()
  
  this_url <- 
    url_seed
  
} else {
  
  load(filepath)
  
  last_offset <-
    names(href.list)[length(href.list)]
  
  this_url <- 
    gsub("dir=prev", paste0("dir=prev&", last_offset), url_seed)
  
}

while(TRUE) {
  
  offset <- 
    stringr::str_extract(this_url, "offset=[0-9]+")
  
  print(offset)
  
  if (is.na(offset)) {
    offset <- 'seed'
  }
  
  this_html <- 
    read_html(this_url) 
  
  href <- 
    this_html %>%
    html_node(xpath = '//*/table[@class="wikitable filehistory"]') %>%
    html_nodes("a") %>% 
    html_attr('href')
  
  href <- 
    unique(href[grepl("2022_Russian_invasion_of_Ukraine\\.svg", href)])
  
  href.list[[offset]] <- 
    href
  
  this_url <-
    this_html %>%
    html_node(xpath = '//*/a[text()="newer 10"]') %>% 
    html_attr('href')
  
  this_url <-
    paste0("https://commons.wikimedia.org/", this_url)

  save(href.list, file = filepath)
  
  Sys.sleep(10)
  
}



