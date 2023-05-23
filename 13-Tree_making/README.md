# 13-Tree_making

This step is a phylogeny step. We use the previously created phylip file to do use PhyML to do a phylogenetic tree of each gene family using a LG model.

We used [PhyML version 3.3.20220408](https://github.com/stephaneguindon/phyml). 

As this is a long job, it is run on a cluster using the same method as in the Alignment and the filtration on the sequence files. We make a `List_gene_family.xtxt` that will be iterated over using the slurm array.

For every gene family, a new file is created and the tree as well as the stats are stored in this file.

To run this step, set your working directory to this folder and run the `Tree_maker.sh` script:

```
cd Database_3D_proteins/13-Tree_making/
sbatch Tree_maker.sh ../Database/
```