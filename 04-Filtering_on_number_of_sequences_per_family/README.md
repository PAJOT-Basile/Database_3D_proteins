# 04-Filtering_on_number_of_sequences_per_family

This folder contains the scripts and the resulting data of the filtering of gene families that have less sequences than a threshold value.

The files we obtained in the previous folder [03-Filtering_gene_families_per_kingdom](../03-Filtering_gene_families_per_kingdom/README.md) contain all the sequences for each of the gene families.
But, some of these files have less than 2 sequences (not enough to align the sequences). Therefore, we chose to select all the families that have more than 3 sequences in this analysis. The number of sequences per file is an input varaible and can therefore be changed if needed.

The `filter.sh` file takes as an input the path to the previous folder [03-Filtering_gene_families_per_kingdom](../03-Filtering_gene_families_per_kingdom/README.md) and the minimum number of sequences per gene family and filters the families in the previous folder to return only the ones with at least that number of sequences.
It creates a directory for each Super-Kingdom and copies the file of the gene family. This script also starts running the `Stats.sh` script in the `Stats/` folder.

The `Stats.sh` script counts the number of sequences and families for each Super-Kingdom and returns it in a csv file. It also strats running the `Stats.R` script.

The `Stats.R` script makes a plot with the number of families and sequences in each Super-Kingdom, taking as input variable the csv files created in the `Stats.sh` script.

To start this cascade of scripts, set your working directory in this folder and run the script:
```
cd Database_3D_proteins/04-Filtering_on_number_of_sequences_per_family/
bash filter.sh ../03-Filtering_gene_families_per_kingdom/ 3
```

You can also chose to run only the `Stats.sh` script separately from the `filter.sh` script. To do this, type
```
bash ../03-Filtering_gene_families_per_kingdom/Stats/Stats.sh "After" # To run the Stats.sh script
Rscript ../04-Filtering_on_number_of_sequences_per_family/Stats/Stats.R # To run the Stats.R script
```