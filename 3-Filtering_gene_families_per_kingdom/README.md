# 3-Filtering_gene_families_per_kingdom

This folder contains the scripts and the resulting data of the filtering of gene families according to the Super-Kingdoms we consider.

The files we obtained in the previous folder [2-Extracting_families_per_kingdom](https://github.com/BasilePajot/Database_3D_proteins/tree/main/2-Extracting_families_per_kingdom) contain all the sequences for each of the gene families. But all the sequences in these files are not part of the considered Super-Kingdom.
Therefore, we will iterate over each line in each file containing the sequences of each gene family and check each time if it corresponds to a sequence in the corresponding ".mne" file.

Given the amount of lines to go through, we built launchers to multithread tasks. 
The first one (`Array_maker.sh`) iterates over each file in each Super-Kingdom in the selected folder. It starts running batches of `Python_launcher.sh` files in parallel. The batch size is to be chosen. It is an argument of the file. (I chose to run with 10).

To run this script, you simply write:
`
bash Array_maker.sh ../2-Extracting_families_per_kingdom NUMBER_OF_JOBS
`
> with NUMBER_OF_JOBS being the desired number of jobs that are run in parallel.

Finaly, the `Python_launcher.sh` script just starts the python script called `Isolating_sequences_per_kingdom.py`.
It takes as arguments the name of the file to analyse, the path to the ".mne" file in the previous folder and the name of the directory in which to find the file to analyse.
It uses the same principle as the python file in the previous folder to go throuh all the sequences in the file and extract only the ones we need.
