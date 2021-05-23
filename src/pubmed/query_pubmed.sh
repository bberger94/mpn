#!/bin/bash

# Define data path
id_path=./data/raw/pubmed/ids

# Pull MPN ids
echo "Pulling PV IDs"
esearch -db pubmed -query "Polycythemia Vera" | efetch -format uid > $id_path/pv_ids.txt
echo "Pulling ET IDs"
esearch -db pubmed -query "Essential thrombocythemia" | efetch -format uid > $id_path/et_ids.txt
echo "Pulling PMF IDs"
esearch -db pubmed -query "Primary myelofibrosis" | efetch -format uid > $id_path/pmf_ids.txt
echo "Pulling AML IDs"
esearch -db pubmed -query "Acute myeloid leukemia" | efetch -format uid > $id_path/aml_ids.txt
echo "Pulling CML IDs"
esearch -db pubmed -query "Chronic myelogenous leukemia" | efetch -format uid > $id_path/cml_ids.txt

# Pull all cancer ids
while [ -n "$1" ]; do # while loop starts
     case "$1" in
     -all_cancer) {
        echo "Pulling all cancer IDs.";
        esearch -db pubmed -query "cancer[sb]" | efetch -format uid > $id_path/cancer_ids.txt
        };; # Message for -a option
     esac
     shift
done
echo "Finished!"
