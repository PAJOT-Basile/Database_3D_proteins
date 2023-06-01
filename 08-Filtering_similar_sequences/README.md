# 08-Filtering_similar_sequences

This folder contains several scripts and a text file. They are the files allowing us to filter the sequences in each gene family file on their similarity. To do this, we will be using the [PhySamp program v1.1.0](https://github.com/jydu/physamp) to remove sequences that are Phylogenetically close in the sequence alignment.

## First step: Make Fast trees
The first step to use this program is to compute phylogenetic trees of the sequences to filter. Therefore, we computed the trees using the [Fast Tree program](http://www.microbesonline.org/fasttree/). To do this on all the gene family files in the database, we use the `Fasttree_maker.sh` script.
It uses parallel work to produce one tree per gene family that has passed the previous filtration process.

To run this script, set your working directory to this folder and run the script:
```
cd Database_3D_proteins/08-Filtering_similar_sequences
bash ./Fasttree_maker.sh ../Database
```
## Second step: Filter sequences

Then, the produced trees and requested fasta files were copied from the database into one database per Super-Kingdom, compressed and copied to a remote cluster.
Once on the cluster, they were uncompressed, and copied to the cluster database to keep the same architecture as the one on this repository. Once in place, the `List_maker.sh` script was run. It made a list of all the gene families in each Super-Kingdom to use as a file to iter onto with the `Similar_sequence_destructor.sh` script. It produces the `List_gene_families.txt` file.

To run this, type:
```
bash List_maker.sh ../Database/
```

Finaly, the last step is to run the `Similar_sequence_destructor.sh` script on the cluster. It iterates over the files in the `List_gene_families.txt` file to use as input for the PhySamp program. As this script uses slurm arrays, and the maximum array size is 2000, 2000 jobs were started and at the end of this process, the `List_gene_families.txt` file was modified to remove the first 2000 lines. The `Similar_sequence_destructor.sh` script was run until no more sequences were left in the `List_gene_families.txt` file.

To run this script on the cluster, type:
```{bash}
sbatch ./Similar_sequence_destructor.sh ../Database/
```

At the end of this step, the files that do not have a fasta file are the ones for which the sequences in the file are too similar. Even with the selected threshold value for the Physamp program is at 10(^-10), some of these files still do not give any result. Therefore, these files are removed for the next steps.

Some statistical analyses files have been added to this directory, but they are the same as the ones in the previous directories. They are just modified to work in this folder.

This step creates the `04-Similar_sequences_removed` folder in the database.