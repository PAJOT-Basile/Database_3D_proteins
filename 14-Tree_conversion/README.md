# 14-Tree_conversion

This folder is made to transform the output file from the PhyML program into a format compatible with the Raser program. That means that we have to take out the bootstraps from the tree file.

To do this, we iterate over the gene families that have a PhyML tree and use the `Converter.R` script that allows to remove the bootstraps from the tree file. We create a new directory to save the output in the database.

To run this, place your working directory in this folder and run the laucher like so:
```
cd Database_3D_proteins/14-Tree_conversion/
bash Launcher.sh ../Database/
```

The `launcher.sh` script iterates over each gene family for each Super-Kingdoms in the database and if the gene family has a tree file, it runs the `Converter.R` script that removes the bootstraps. It only requires that we give the relative path to the database.