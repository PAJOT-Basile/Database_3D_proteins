# 06-Taking_out_gaps_in_sequences

This folder is one where we will transform the sequences for each gene family folder. They are pre-aligned in the Acnuc database. But as we filtered the sequences we wanted to keep in each Super-Kingdom in [step 03](../03-Filtering_gene_families_per_kingdom/README.md), we have fasta files with plenty of empty sites. Therefore, in this step, we remove the sites containing only gaps in the sequences.
To do this, we use the BppSeqMan program from the [BppSuite package](https://github.com/BioPP/bppsuite)[^1]. We used the [2.3.2 version](https://github.com/BioPP/bppsuite/releases/tag/v2.3.2) given it can compile itself on its own.

For this project, we placed the program in the folder `~/Downloads`. Thus, the path to the program that is specified in the `Gap_remover.sh` script is to be changed if the installation is done somewhere else.

The `Gap_remover.sh` script iterates over each gene family folder in every Super-Kingdom. It takes the corresponding file in the `01-Raw_data` folder in the database as input of the program and creates a matching-named output file containing the sequences without the gaps in a newly created folder (`02-Gaps_removed`).
To run this script, set your working directory in this folder and run the script:
```
cd Database_3D_proteins/06-Taking_out_gaps_in_sequences/
bash ./Gap_remover.sh ../Database/
```

This steps lasts for 1h45 with the considered dataset.

The `params.pbb` file is a parameter file taken as input variable by the BppSeqMan program. It is used to define some of the variables that do not change in the script. [You can find an example of how to organise this file here.](https://github.com/BioPP/bppsuite/blob/master/Examples/SequenceManipulation/SeqMan.bpp)

```
[^1] 
```