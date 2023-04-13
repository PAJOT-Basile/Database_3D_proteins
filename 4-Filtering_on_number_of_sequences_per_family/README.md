# 4-Filtering_on_number_of_sequences_per_family

This folder contains the scripts and the resulting data of the filtering of gene families that have more sequences than a selected number.

The files we obtained in the previous folder [3-Filtering_gene_families_per_kingdom](https://github.com/BasilePajot/Database_3D_proteins/tree/main/3-Filtering_gene_families_per_kingdom) contain all the sequences for each of the gene families.
But, some of these files have less than 2 sequences (not enough to align the sequences). Therefore, we chose to select all the families that have more than 3 sequences in this analysis, but we can addapt it to the number of sequences we want.

The `filter.sh` file takes as an input the path to the previous folder [3-Filtering_gene_families_per_kingdom](https://github.com/BasilePajot/Database_3D_proteins/tree/main/3-Filtering_gene_families_per_kingdom) and the minimum number of sequences per gene family and filters the families in the previous folder to return only the ones with at least that number of sequences.
It creates a directory for each Super-Kingdom and copies the file of the gene family. This script also starts running the `Stats.sh` script in the `Stats/` folder.

The `Stats.sh` script counts the number of sequences and families for each Super-Kingdom and returns it in a csv file. It also strats running the `Stats.R` script.

The `Stats.R` script makes a plot with the number of families and sequences in each Super-Kingdom, taking in account the csv files.

To start all these cascade scripts, you can write: `bash filter.sh ../3-Filtering_gene_families_per_kingdom/ 3`