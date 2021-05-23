
# Load packages
library(R.utils)
library(tidyverse)
library(stringr)
library(xml2)
library(parallel)
library(furrr)
library(progressr)

# Load functions
source("src/pubmed/process_xml_fns.R")


# --- Identify compressed XML files ------------- #
path <- "data/raw/pubmed/xml/pubmed_baseline_2021"
files <- dir(path, full.names = TRUE)
xml_files <- files[str_detect(files, ".xml$")] 



# --- Run Tests -------------- #
# Unit test --- Read in articles from single XML
articles <- prep_xml(xml_files[330])

# Unit test --- Process a single article (w/ missing title)
process_article(articles[21016][[1]]) %>% 
  print

# Unit test --- Read in articles from single XML
articles <- prep_xml(xml_files[506])

# Unit test --- Process a single article (w/ italicized title)
process_article(articles[18426][[1]]) %>% 
  select(title) %>% 
  print

  
# Unit test --- Loop over subset of a file
xml_1_data <- process_xml(xml_files[506], 
                          verbose = TRUE,
                          subset = 1:100
                          )

# Test proper handling of NULL date elements (should return NA)
process_xml(xml_files[76], subset = 15195:15197) %>% 
  print

# --- Loop over XML files -------------- #
# Set number of cores
plan(multisession, workers = 4)
handlers(global = TRUE)
handlers("debug")

# Run parallelized loop to extract data in data frame
with_progress(pubmed_test <- process_files(xml_files[1000:1003],
                                           subset = 1:100))

print(pubmed_test)

