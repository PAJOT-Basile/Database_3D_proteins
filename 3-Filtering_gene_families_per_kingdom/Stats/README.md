# Stats

This folder contains the scripts and the produced data to make basic calculations on the sequences that were extracted in the previous step.

The `Stats.sh` script goes through the extracted files in the parent folder to count the number of sequences, the number of families for each Super-Kingdom.
It creates four csv files. One containing the total number of gene families and sequences per Super-Kingdom and three containing a detailled count of sequences per gene-family per Super-Kingdom. This script also executes the Rscript `Stats.R`.
The `Stats.R` script plots the csv files made by the `Stats.sh` script to make them easily visible. It also creates 4 png captures of the graphs. One contains the overall number gene families and sequences for each Super-Kingdom and the others contain the number of sequences for each gene family. We also made a simulation depending on the number of sequences to filter to see which proportion of the dataset we conserve (see the README.md file for the next folder: [README.md](https://github.com/BasilePajot/Database_3D_proteins/tree/main/4-Filtering_on_number_of_sequences_per_family/README.md)).