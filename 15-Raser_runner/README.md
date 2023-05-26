# 15-Raser_runner

This folder is used to run the [Raser program](https://www.tau.ac.il/~penn/raser.html). It is a likelihood based method for testing and detecting site-specific evolutionary rate shifts. It takes into account a tree and a multiple sequence alignment.

The `Raser_runner.sh` script iterates over the gene families in each Super-Kingdom to run the Raser program on the gene families that have a tree previously re-formated to take out the bootstraps. The Raser program takes as input a parameter file that is created by the `Raser_paramfile_maker.sh` script. It is run directly when needed from the `Raser_runner.sh` script, but can be run separately if given the path to the database, the name of the order and the name of the wanted gene family.

The only input variable needed to run the `Raser_runner.sh` script is the relative path to the database.

This step is a very time consuming one. Therefore, it was run on a cluster. Thus, to be able to iterate over all the files in a slurm array, a list of the gene family folders to run Raser on was made using the `List_maker.sh` script.

To run these scripts, set your working directory in this folder and execute the `Raser_runner.sh` script as follows:
```
cd Database_3D_proteins/15-Raser_runner/
sbatch Raser_runner.sh ../Database/
```