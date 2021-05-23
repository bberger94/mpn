# ---------------------------------- #
# Extract data from Pubmed XML files
# ---------------------------------- #

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

# --- Identify uncompressed XML files ------------- #
path <- "data/raw/pubmed/xml/pubmed_baseline_2021"
files <- dir(path, full.names = TRUE)
xml_files <- files[str_detect(files, ".xml$")] 

# --- Loop over XML files -------------- #
# Use half of cores for running loop
plan(multisession, workers = detectCores()/2)

# Specify handlers for progress updates
options(progressr.enable = TRUE)
handlers(global = TRUE)
handlers("debug")

# Run parallelized loop to extract data in data frame
with_progress(pubmed <- process_files(xml_files))
message("Finished processing XMLs.")

# --- Format for csv export -------------- #
# Create table of publication data (minus authors)
pubs <- pubmed %>% 
  select(-authors)

# Create table of publication-author data
authors <- pubmed %>% 
  select(pmid, authors) %>% 
  unnest(authors) %>% 
  mutate(last = map(authors, "LastName"),
         first = map(authors, "ForeName"),
         init = map(authors, "Initials"),
         suffix = map(authors, "Suffix"),
         identifier = map(authors, "Identifier")
  ) %>% 
  select(-authors) %>% 
  # Extract character elements from list columns
  mutate_at(vars(last, first, init, suffix, identifier), 
            function(x){
              x <- x %>% 
                map(1) %>% 
                replace_na(NA_character_) %>% 
                as.character()
            })

# --- Save files ------------ #
message("Writing data to disk.")
write_csv(authors, file = "data/intermediate/pubmed/authors.csv", 
          col_names = FALSE, na = "")
write_csv(pubs, file = "data/intermediate/pubmed/pubs.csv", 
          col_names = FALSE, na = "")

