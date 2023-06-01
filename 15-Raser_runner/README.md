# 15-Raser_runner

This folder is used to run the [Raser program](https://www.tau.ac.il/~penn/raser.html)[^1]. It is a likelihood based method for testing and detecting site-specific evolutionary rate shifts. It takes into account a tree and a multiple sequence alignment.

The `Raser_runner.sh` script iterates over the gene families in each Super-Kingdom to run the Raser program on the gene families that have a tree previously re-formated to take out the bootstraps. The Raser program takes as input a parameter file that is created by the `Raser_paramfile_maker.sh` script. It is run directly when needed from the `Raser_runner.sh` script, but can be run separately if given the path to the database, the name of the order and the name of the wanted gene family, like the following example:
```
bash Raser_paramfile_maker.sh ../Database/ Archaea CLU_000422_3_3
```

The only input variable needed to run the `Raser_runner.sh` script is the relative path to the database.

This step is a very time consuming one. Therefore, it was run on a cluster. Thus, to be able to iterate over all the files in a slurm array, a list of the gene family folders to run Raser on was made using the `List_maker.sh` script. Like in the steps [08](../08-Filtering_similar_sequences/README.md), [10](../10-First_alignment_of_sequences/README.md) and [13](../13-Tree_making/README.md), the created `List_superkingdoms.xtxt` file will have to be modified between two runs.
To generate this file, type:
```
bash List_maker.sh ../Database/
```

Once the reference list is generated, run the `Raser_runner.sh` script by first setting your working directory in this folder and then by executing the `Raser_runner.sh` script as follows:
```
cd Database_3D_proteins/15-Raser_runner/
sbatch Raser_runner.sh ../Database/
```

This step creates the new folder `11-Raser_outputs` in the database.

Unfortunately, this step had to be cut short so the number of gene families that have the actual output (the raser result file) is pretty low compared to the number of files generated in the previous steps.


> [^1] Penn O, Stern A, Rubinstein ND, Dutheil J, Bacharach E, Galtier N., Pupko T. 2008.
Evolutionary Modeling of Rate Shifts Reveals Specificity Determinants in HIV-1 Subtypes.
PLoS Computational Biology 4(11): e1000214.
