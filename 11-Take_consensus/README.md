# 11-Take_consensus

This step is made to take the consensus of two alignment methods that were performed in the previous step.
This is done using the [BppAlnScore program from the BppSuite](https://github.com/BioPP/bppsuite/tree/master).

We iterate over the gene families that were aligned previously and take the consensus of two alignment methods. For most gene families, we will take the consensus of Muscle and Prank alignment methods, but for some files for which Prank did not work, we will take the Mafft alignment instead.

To run this script, place your working directory in this folder and run the bash script:
```
cd Database_3D_proteins/11-Take_consensus/
bash Consensus.sh ../Database/
```