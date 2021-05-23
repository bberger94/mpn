


data/intermediate/pubmed/pubmed.db: \
	src/pubmed/create_pubmed_db.sh \
	data/intermediate/pubmed/authors.csv \
	data/intermediate/pubmed/pubs.csv 
	sqlite3 data/intermediate/pubmed/pubmed.db < src/pubmed/create_pubmed_db.sh >& logs/create_pubmed_db.log 

data/intermediate/pubmed/authors.csv data/intermediate/pubmed/pubs.csv logs/process_xml.log: \
	src/pubmed/process_xml.R \
	src/pubmed/process_xml_fns.R \
	data/raw/pubmed/xml/pubmed_baseline_2021/
	Rscript src/pubmed/process_xml.R >& logs/process_xml.log


data/raw/pubmed/xml/pubmed_baseline_2021/: \
	src/pubmed/unzip_xml.sh \
	data/raw/pubmed/xml/pubmed_baseline_2021/*.xml.gz
	./src/pubmed/unzip_xml.sh > logs/unzip_xml.log









