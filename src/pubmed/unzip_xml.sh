#!/bin/bash

path=./data/raw/pubmed/xml/pubmed_baseline_2021
files_gz=$(ls $path/*.xml.gz)

for file_gz in $files_gz
do
	file_xml=${file_gz%.*}
	echo Unzipping $file_gz
	gunzip -c $file_gz > $file_xml
done
