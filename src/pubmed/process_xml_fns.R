

# --- Define function to decompress and read single XML file --------- #
prep_xml <- function(xml_path){
  
  # Read XML file
  xml <- read_xml(xml_path)
  
  # Convert to vector of individual article XMLs
  articles <- xml_children(xml)
  articles
}



# --- Define function to process a single article ----------- #
process_article <- function(article){
  # Convert to list
  article <- as_list(article)
  
  # Extract Pubmed ID
  pmid <- article$MedlineCitation$PMID[[1]]
  
  # Extract data
  article <- article$MedlineCitation$Article
  title <- article$ArticleTitle %>% unlist %>% paste(collapse = "")
  issn <- article$Journal$ISSN[[1]]
  pub_yr <- article$Journal$JournalIssue$PubDate$Year[[1]]
  pub_mo <- article$Journal$JournalIssue$PubDate$Month[[1]]
  pub_day <- article$Journal$JournalIssue$PubDate$Day[[1]]
  pub_season <- article$Journal$JournalIssue$PubDate$Season[[1]]
  pub_medline_date <- article$Journal$JournalIssue$PubDate$MedlineDate[[1]]
  
  # Format article data in tibble
  tibble(
    pmid = pmid,
    title = ifelse(is.null(title), NA_character_, title), 
    issn = ifelse(is.null(issn), NA_character_, issn),
    authors = list(article$AuthorList),
    pub_yr = ifelse(is.null(pub_yr), NA_character_, pub_yr),
    pub_mo = ifelse(is.null(pub_mo), NA_character_, pub_mo),
    pub_day = ifelse(is.null(pub_day), NA_character_, pub_day),
    pub_season = ifelse(is.null(pub_season), NA_character_, pub_season),
    pub_medline_date = ifelse(is.null(pub_medline_date), NA_character_, pub_medline_date)
  )
}



# --- Define function to read + process a single compressed XML file ---- #
process_xml <- function(xml_path, 
                        verbose = FALSE,
                        subset = NULL){
  
  # Unzip + read data
  articles <- prep_xml(xml_path)
  
  # If specified, process only subset of data
  if(!is.null(subset)) articles <- articles[subset]
  n_articles <- length(articles)
  
  # Process all articles in XML file and return tibble
  i <- 0
  data <- map_dfr(articles, function(article){
    i <<- i + 1
    if(verbose == TRUE){
      cat("\r", i, "/", n_articles)
    }
    process_article(article)
  })
  
  # message("Finished ", xml_path)
  return(data)
}


# --- Define wrapper to loop over XML files and report progress ---- #
process_files <- function(xml_paths,
                          subset = NULL) {
  p <- progressor(along = xml_paths)
  y <- future_map_dfr(xml_paths, function(path){
    p(sprintf("%s", path))
    data <- process_xml(path, subset = subset)
    data
  })
}








