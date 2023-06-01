# 13-Tree_making

This step is a phylogeny step. We use the previously created phylip file to do use PhyML [^1] to do a phylogenetic tree of each gene family using a LG model.

We used [PhyML version 3.3.20220408](https://github.com/stephaneguindon/phyml). 

As this is a long job, it is run on a cluster using the same method as in the Alignment and the filtration on the sequence files.
We make a `List_gene_family.xtxt` that will be iterated over using the slurm array. As in steps [08](../08-Filtering_similar_sequences/README.md) and [10](../10-First_alignment_of_sequences/README.md), between two runs in the slurm array, the `List_gene_families.xtxt` file will have to be changed.
It can be generated using 
```
bash List_maker.sh ../Database/
```

Once, the reference list is done, run this step by first setting your working directory to this folder and then running the `Tree_maker.sh` script:

```
cd Database_3D_proteins/13-Tree_making/
sbatch Tree_maker.sh ../Database/
```

This step creates the `09-PhyML_tree` folder in the database.


> [^1]"New Algorithms and Methods to Estimate Maximum-Likelihood Phylogenies: Assessing the Performance of PhyML 3.0."
Guindon S., Dufayard J.F., Lefort V., Anisimova M., Hordijk W., Gascuel O.
Systematic Biology, 59(3):307-21, 2010. 
