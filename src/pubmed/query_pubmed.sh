

# Pull MPN ids
mpn_path=./data/raw/pubmed/mpn/mpn_ids.txt
cancer_path=./data/raw/pubmed/cancer/cancer_ids.txt

esearch -db pubmed -query "(Polycythemia Vera|Essential thrombocythemia|Primary myelofibrosis) & cancer[sb]" | efetch -format uid > $mpn_path

# Count number of MPN IDs
echo "MPN ID Count"
wc -l $mpn_path

# Pull all cancer ids
esearch -db pubmed -query "cancer[sb]" | efetch -format uid > $cancer_path
wc -l $cancer_path

