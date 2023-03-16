# 4-Making a fasta file

This folder contains the script to transform the newly-created csv files in the parallel folder (3-Filtering_extracted_data_on_taxonomy) 
containing the data that was filtered according to the sequences taxonomy into a fasta file.

This script is written to be executed on a cluster. Therefore, if you want to use it on a local computer, supress the first line.

To use this script, you can simply write `sbash Fasta_maker.sh ../3-Filtering_extracted_data_on_taxonomy` 
(`bash Fasta_maker.sh ../3-Filtering_extracted_data_on_taxonomy` if you run it on a local machine) and it will work.
It takes the csv files in the parallel folder and creates 4 new fasta files in this folder (Bacteria, Eukaryota, Archaea and the rest).
