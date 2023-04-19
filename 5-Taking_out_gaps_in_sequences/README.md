# 5-Taking_out_gaps_in_sequences

This folder is one where we will transform the sequences gene family files. They are pre-aligned in the Acnuc database. But as we filtered the sequences we wanted to keep in each Super-Kingdom in step 3, we have fasta files with plenty of empty sites. Therefore, in this step, we remove the sites containing only gaps in the sequences.
To do this, we use the (BppSeqMan program)[https://github.com/BioPP/bppsuite] from the BppSuite. We used the (2.3.2 version)[https://github.com/BioPP/bppsuite/releases/tag/v2.3.2] given it can compile itself on its own.

For this project, we placed the program in the folder `~/Downloads`. Thus, the path to the program that is specified in the `Gap_remover.sh` script is to be changed if the installation is done somewhere else.

The `Gap_remover.sh` script iterates over each gene family file in every Super-Kingdom. It takes the corresponding file as input of the program and creates a matching-named output file containing the sequences without the gaps.
The script also defines a gap keeping threshold to eliminate only empty sites.
This script creates one folder per Super-Kingdom containing all the modified gene family files of said Super-Kingdom.
It takes as input the relative path to the parallel folder where the gene family files are stored.

To run this script, simply write:
`
bash ./Gap_remover.sh ../4-Filtering_on_number_of_sequences_per_family
`

This steps lasts for 1h45 with the considered dataset.