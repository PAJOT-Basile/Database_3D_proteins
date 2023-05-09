# 10-First_alignment_of_sequences

This folder contains the scripts to do the alignment of the raw data. The alignment method to be used is to be chosen by the user. You can chose one of MAFFT, MUSCLE or PRANK.

We used this to do two alignments of the gene families (Muscle & Prank or Muscle & Mafft for the files that did not work with Prank) to select the consensus of these two alignments.

The `Align.sh` script aligns the sequences using one of the following methods: MAFFT, MUSCLE or PRANK. It iterates over each folder for each Super-Kingdom in the database and takes the fasta file after being optimised in the previous steps for each gene family to align it.

The `csv_maker.sh` script is run from the `Align.sh` script. It converts the fasta file into a csv file to measure some parameters on the sequences. It is used afterwards for the `timer.py` script.

The `timer.py` script is also run from the `Align.sh` script. It transforms the measured alignment time and adds it to a csv file.

Finaly, as the job is run on a cluster (just like in step [08-Filtering_similar_sequences](../08-Filtering_similar_sequences/README.md)), the same method is used and so, the `List_maker.sh` script is to be run before the use of the `Align.sh` script. It makes a list of all the files in the database to iterate over in a slurm array.

To run everythong, first place your working directory in this folder, then run the `List_maker.sh` script and finaly, run the `Align.sh` script like so: 
```
cd Database_3D_proteins/10-First_alignment_of_sequences/
bash ./List_maker.sh ../Database/
sbatch ./Align.sh ../Database/ METHOD SEQ_TRHESHOLD
```
> with `METHOD` being one of MAFFT, MUSCLE or PRANK
> with `SEQ_THRESHOLD` being the limit number of sequences in each file to consider (100 here)