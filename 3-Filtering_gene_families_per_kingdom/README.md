# 3-Filtering_gene_families_per_kingdom

This folder contains the scripts and the resulting data of the filtering of gene families according to the Super-Kingdoms we consider.

The files we obtained in the previous folder [2-Extracting_families_per_kingdom](https://github.com/BasilePajot/Database_3D_proteins/tree/main/2-Extracting_families_per_kingdom) contain all the sequences for each of the gene families. But all the sequences in these files are not part of the considered Super-Kingdom.
Therefore, we will iterate over each line in each file containing the sequences of each gene family and check each time if it corresponds to a sequence in the corresponding ".mne" file.

Given the amount of lines to go through, we built launchers. 
The first one (`Array_maker.sh`) iterates over each file in each Super-Kingdom (given in the script) in the selected folder. For each file, it starts the 
