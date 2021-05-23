DROP TABLE IF EXISTS authors;
CREATE TABLE authors(pmid, last, first, init, suffix, identifier);
.mode csv
.import ./data/intermediate/pubmed/authors.csv authors

DROP TABLE IF EXISTS pubs;
CREATE TABLE pubs(pmid, title, issn, pub_yr, pub_mo, pub_day, pub_season, pub_medline_date);
.mode csv
.import ./data/intermediate/pubmed/pubs.csv pubs

select "Finished without errors!";

