# 03-Filtering_gene_families_per_kingdom

This folder contains the scripts and the resulting data of the filtering of gene families according to the Super-Kingdoms we consider.

The files we obtained in the previous folder [2-Extracting_families_per_kingdom](https://github.com/BasilePajot/Database_3D_proteins/tree/main/2-Extracting_families_per_kingdom) contain all the sequences for each of the gene families. But all the sequences in these files are not part of the considered Super-Kingdom.
Therefore, we will iterate over each line in each file containing the sequences of each gene family and check each time if it corresponds to a sequence in the corresponding ".mne" file.

The `launcher.sh` script iterates over the Super-Kingdoms, and executing the `Isolating_sequences_per_kingdom.py` script for each one. It also starts the `Stats/Stats.sh` script.

The `Isolating_sequences_per_kingdom.py` script iterates over each sequence in each gene family file to extract only the ones in the reference files (".mne" files).

To execute the scripts, you just need to write:
`bash launcher.sh ../2-Extracting_families_per_kingdom`.
This step takes a few moments. Especially for the Bacteria Super-Kingdom which is very voluminous. The total duration of the scritp is a little over 2h30.

This script will create as many folders as there are Super-Kingdoms in your analyse. These folders contain the gene family sequences that have been filtered with this script. It also creates one file per Super-Kingdom in the parallel folder [2-Extracting_families_per_kingdom](https://github.com/BasilePajot/Database_3D_proteins/tree/main/2-Extracting_families_per_kingdom) containing all the sequences IDs that we have in the gene-family files for each Super-Kingdom in this folder.

In addition, the `Stats` foler conntains some basic statistical values about the number of gene families that we have, the number of sequences per family and what would happen if we chose to filter on a certain number of sequences. It also contains the scripts to do this (count the number of sequences and gene families and plots).
