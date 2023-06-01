# 09-First_alignment_of_sequences

This folder contains the scripts to align the sequences after modifying them. This folder contains several files.

## List of input variables

The first one is `List_maker.sh`. It lists all the gene families for each Super-Kingdom in the database. As this step is run on a remote cluster, the produced file `List_superkingdoms.xtxt` serves as a list of input variables for the alignment script. To run this script, place your working directory to this folder and type:
```
cd Database_3D_proteins/09-First_alignment/
bash List_maker.sh ../Database/
```

## Align

Once the `List_superkingdoms.xtxt` is made, we use the `Align.sh` script to align the sequences in the gene family files after filtration and optimisation of the fasta file.
The goal here is to take the consensus of two alignment methods. Therefore, the `Align.sh` script was designed to take the alignment method as input and run the according alignment method on the selected data. Therefore, to run the script on a cluster, type
```
sbatch Align.sh ../Database/ METHOD
```
> With `METHOD` being one of MAFFT [^1], MUSCLE [^2] or PRANK [^3]. This list of methods can be implemented with new ones if needed.
In our project, we first run this using 
```
sbatch Align.sh ../Database/ MUSCLE
```
And then used the PRANK method as a second alignment method using:
```
sbatch Align.sh ../Database/ PRANK
```
As this step is run on a cluster using a slurm array, as for step [08](../08-Filtering_similar_sequences/README.md), the `List_superkingdoms.xtxt` file has to be modified once the first 2000 jobs have been run. To this end, before running the PRANK alignment step, you must regenerate the `List_superkingdoms.xtxt` file.
In this project, the name of the output file was also modified to separate runs accross the database.

Finaly, as PRANK sometimes does not work on some files, we used MAFFT to complete the files that did not work. To do this, the same process as for the previous alignment methods is used, meaning you must generate a list to iterate over to use the MAFFT alignment method.
To do this, use the `List_mafft.sh` script. It iterates over the log files to detecte errors in these files to get the name of the corresponding gene family and list it in a new file called `List_gene_families_for_mafft.xtxt`. 

The logs folder contains the log files of all the runs.
The other scripts are optional. They are made to time the alignment process and add the results in the `Alignment_speeds.csv` file. If you wish to not use them, comment out lines 101 and 103 of the script.

This step creates a new directory per alignment method used in the database. Therefore folders in the database shall have at the end of this step one `06-Muscle_alignment` folder and either a `06-Prank_alignment` or a `06-Mafft_alignment` folder.

:warning: If the Prank alignment method did not work, you will have to remove the create `06-Prank_alignment` folder for these files. You can do this by modifying the `rename.sh` script in the general folder (parent to this one).



> [^1] Kazutaka Katoh and others, MAFFT: a novel method for rapid multiple sequence alignment based on fast Fourier transform, Nucleic Acids Research, Volume 30, Issue 14, 15 July 2002, Pages 3059–3066, https://doi.org/10.1093/nar/gkf436
> [^2] Edgar RC. MUSCLE: multiple sequence alignment with high accuracy and high throughput. Nucleic Acids Res. 2004 Mar 19;32(5):1792-7. doi: 10.1093/nar/gkh340. PMID: 15034147; PMCID: PMC390337.
> [^3] Löytynoja A. Phylogeny-aware alignment with PRANK. Methods Mol Biol. 2014;1079:155-70. doi: 10.1007/978-1-62703-646-7_10. PMID: 24170401.
