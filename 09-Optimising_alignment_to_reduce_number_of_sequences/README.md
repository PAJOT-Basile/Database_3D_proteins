# 09-Optimising_alignment_to_reduce_number_of_sequences

This folder contains the script to optimise the alignments produced at the end of the previous step ([08-Filtering_similar_sequences](../08-Filtering_similar_sequences/README.md)). To do so, it iterates over the gene families that have passed the previous step and optimises their alignment using the [BppAlnOptim program](https://jydu.github.io/physamp/).

The `Optimiser.sh` script iterates over each gene family in every Super-Kingdom to use the BppAlnOptim program. Therefore, it optimises the files having more sequences than a user-defined threshold value. The folders having less sequences are just copied. If this threshold value is not given here, the script will ask for it. Here, we used 400 sequences as a filtering threshold.
Another parameter that can be added when the script is called is the wanted proportion of covered sites to conserve in the optimised alignment. If it is not given by the user, the script will ask for it and if no value is given, it will by default chose to conserve 90% of covered sites.

Once this is done, several scripts are run to do some statistical analyses. As for the previous step ([08-Filtering_similar_sequences](../08-Filtering_similar_sequences/README.md)), the scripts used here produce the same outputs as the ones that have the same names in the previous folders, but are modified to this folder.

To start all this cascade of scripts, set your working directory in this folder and write: 
```
cd Database_3D_proteins/09-Optimising_alignment_to_reduce_number_of_sequences/
bash ./Optimiser.sh ../Database SEQ_THRESHOLD COVERAGE_PROPORTION
```
> With SEQ_THRESHOLD being the user-defined threshold to use for the filtration on the number of sequences per file (400 here)
>  and COVERAGE_PROPORTION being the proportion of covered spots to conserve in the optimised fasta file (0.9 here). 

This step creates the `05-Optimised_alignment` in the database.