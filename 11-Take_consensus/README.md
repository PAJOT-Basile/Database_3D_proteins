# 11-Take_consensus

This step is made to take the consensus of two alignment methods that were performed in the previous step.
This is done using the [BppAlnScore program from the BppSuite](https://github.com/BioPP/bppsuite/tree/master).

We iterate over the gene families that were aligned previously and take the consensus of two alignment methods. For most gene families, we will take the consensus of Muscle and Prank alignment methods, but for some files for which Prank did not work, we will take the Mafft alignment instead.

The `Consensus.sh` script takes as arguments the path to the database and a threshold value to know which proportion of coverage per sites to conserve in the consensus file.

To run this script, set your working directory in this folder and run the bash script:
```
cd Database_3D_proteins/11-Take_consensus/
bash Consensus.sh ../Database/ 0.8
```

This step creates the `07-Consensus` folder in the database.