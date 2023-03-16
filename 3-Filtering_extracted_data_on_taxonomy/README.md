# 3-Filtering_extracted_data_on_taxonomy

This folder contains a script used to fillter the data from the previously extracted data (stored in the parallel folder: 
2-Parsing_extracted_data_from_Genbank). 

As the previously saved files each contain sequences from  Bacteria, Eukaryota, Archaea and other super-kingdoms, we filter them to put all the Bacteria in one file, all the Eukaryota in another and all the Archaea in another. The rest is kept in a last file that contains the rest. 

In this script, we also check if there are some duplicates that would have ended up in the same or different csv files in the previous step. 
If there are any duplicates, they ae now in the same file (same taxonomy) and we remove the duplicates if there are any.

This script is written to be executed on a cluster. Therefore, if you want to use it on a local computer, supress the first line.

To use this script, you can simply write `sbash Isolate_superkingdoms.sh ../2-Parsing_extracted_data_from_Genbank` (`bash Isolate_superkingdoms.sh ../2-Parsing_extracted_data_from_Genbank` if you run it on a local machine)and it will work. It takes the csv files in the parallel folder and creates 4 new csv files in this folder (Bacteria, Eukaryota, Archaea and the rest).
