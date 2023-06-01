# Database_3D_proteins

The goal of this project is to build a database of protein sequences containing only gene families that have at least one sequence of an experimentally solved 3D structure available. 

To do so, we extract sequences from the ACNUC database using the query retrieval program of this database.
Once the sequences are extracted, we perform several analysis and filtration tests on the sequences before adding them to the database. 
The different steps are depicted in the different folders of this repository. The numbers in the folders names indicate the order in the steps we took.
Each folder has a README.md file presenting a detailed explanation of the files in this folder, what they do and how to execute them. However, this file should give you an overview of the way the repository is built and the organisation of the final database through example files.

Here is how the repository is organised and the steps that were followed during the project.
```
Database_3D_proteins
├── 01-AcnucFamilies
│   └── List_superkingdoms.txt
├── 02-Extracting_families_per_kingdom
│   ├── Archaea
│   ├── Bacteria
│   ├── Eukaryota
│   └── Family_extractor.py
├── 03-Filtering_gene_families_per_kingdom
│   ├── Archaea
│   ├── Bacteria
│   ├── Eukaryota
│   ├── Isolating_sequences_per_kingdom.py
│   ├── launcher.sh
│   └── Stats
│       ├── Stats.R
│       └── Stats.sh
├── 04-Filtering_on_number_of_sequences_per_family
│   ├── Archaea
│   ├── Bacteria
│   ├── Eukaryota
│   ├── filter.sh
│   └── Stats
│       └── Stats.R
├── 05-Organising_raw_data_in_database
│   ├── csv_maker.sh
│   └── Raw_data_organiser.sh
├── 06-Taking_out_gaps_in_sequences
│   ├── Gap_remover.sh
│   └── params.bpp
├── 07-Filtering_sequences_on_their_quality
│   ├── csvs
│   ├── distribution.R
│   ├── launcher.sh
│   └── Quality_evaluator.py
├── 08-Filtering_similar_sequences
│   ├── csvs
│   ├── distribution.R
│   ├── Fasttree_maker.sh
│   ├── launcher.sh
│   ├── List_maker.sh
│   ├── Quality_evaluator.py
│   ├── See_distribution_nb_seq_family.R
│   ├── Similar_sequence_destructor.sh
│   ├── Stats
│   └── Stats.sh
├── 09-Optimising_alignment_to_reduce_number_of_sequences
│   ├── csvs
│   ├── distribution.R
│   ├── launcher.sh
│   ├── Optimiser.sh
│   ├── params.bpp
│   ├── Quality_evaluator.py
│   ├── See_distribution_nb_seq_family.R
│   ├── Stats
│   └── Stats.sh
├── 10-First_alignment_of_sequences
│   ├── Align.sh
│   ├── csv_maker.sh
│   ├── List_gene_families_for_mafft.xtxt
│   ├── List_gene_families.xtxt
│   ├── List_mafft.sh
│   ├── List_maker.sh
│   └── timer.py
├── 11-Take_consensus
│   └── Consensus.sh
├── 12-Format_change_Mase_to_Phylip
│   └── Phylip_maker.sh
├── 13-Tree_making
│   ├── List_gene_families.xtxt
│   ├── List_maker.sh
│   └── Tree_maker.sh
├── 14-Tree_conversion
│   ├── Converter.R
│   └── Launcher.sh
├── 15-Raser_runner
│   ├── List_gene_families.xtxt
│   ├── List_maker.sh
│   ├── Raser_paramfile_maker.sh
│   └── Raser_runner.sh
├── 16-Getting_pdb_info_Acnuc
│   ├── Archaea_seqfile.dat
│   ├── Bacteria_seqfile.dat
│   ├── Copier.sh
│   ├── Eukaryota_seqfile.dat
│   ├── Filter_on_Pdb.py
│   └── General_PDB_extractor.sh
├── 17-Transforming_raser_output_to_sged
│   ├── launcher.sh
│   └── sged-raser2sged.py
├── 18-Get_pdb_file_and_create_index
│   ├── PDB_obtainer.sh
│   └── sged-create-structure-index.py
├── 19-Structure_information
│   └── Coordinate_translator_and_structure_info_extractor.sh
├── 20-Structure_analysis
│   ├── Analysis.R
│   └── Data_puller.R
└── Database
    ├── Archaea
    │   └── Example
    │       ├── 01-Raw_data
    │       ├── 02-Gaps_removed
    │       ├── 03-Better_quality
    │       ├── 04-Similar_sequences_removed
    │       ├── 05-Optimised_alignment
    │       ├── 06-Muscle_alignment
    │       ├── 06-Prank_or_Mafft_alignment
    │       ├── 07-Consensus
    │       │   ├── Example.mase
    │       │   └── Example_scores.txt
    │       ├── 08-Phylip_file
    │       │   └── Example.phylip
    │       ├── 10-Tree_without_bootstrap
    │       ├── 11-Raser_outputs
    │       │   ├── Example_log_file.txt
    │       │   ├── Example_nodes_results_file.txt
    │       │   ├── Example_out_tree.namesBS.ph
    │       │   ├── Example_out_tree.txt
    │       │   ├── Example.params
    │       │   └── Example_results_file.txt
    │       ├── 12-Pdb_information
    │       │   └── Example_pdbref.pdb
    │       └── 13-Structure_info
    ├── Bacteria
    └── Eukaryota
```

All the folders that have the name Archaea Bacteria or Eukaryota are built in the same way inside the considered directory. Every time the three Super-Kingdoms are in the same folder, they are composed of a list of fasta files containing all the sequences for the different gene families in said Super-Kingdom.
The only exception is the Database folder. In this folder, the Super-Kingdoms have one subdirectory for each gene family divided into several sub-directories, all looking like the `Example` folder in the Archaea Super-Kingdom.

## [01-AcnucFamilies](01-AcnucFamilies/README.md)

In this repository, you will only find a text file with three Super-Kingdom names on the github repository. It is normal given it is the directory in which you will store all your raw data extracted from the ACNUC database. You will need one family file per Super-Kingdom and the ACNUC database archive to get all the sequences we need for the rest of the project.

## [02-Extracting_families_per_kingdom](02-Extracting_families_per_kingdom/README.md)

In this repository, you will find only a python script. It's role is to iterate over the archive file in the [01-AcnucFamilies](01-AcnucFamilies/README.md) directory to create the one Super-Kingdom folder you see in the current directory on the illustrative tree above. These folders contain all the fasta files of the sequences extracted from the ACNUC archive file. One fasta file is created for each gene family. 
This folder will have to be completed manualy to add some files containing all the sequence names of a Super-Kingdom using the ACNUC retrieval program.

## [03-Filtering_gene_families_per_kingdom](03-Filtering_gene_families_per_kingdom/README.md)

This folder is a little bit bigger than the previous ones. As the gene family files we extracted earlier are composed of sequences from all Super-Kingdoms, we have to take out the sequences that are not part of this Super-Kingdom. Two scripts work together on this purpose. The `launcher.sh` script starts the process. It also calls some other scripts allowing to make some statistical analyses on the extracted sequences per Super-Kingdom. These are the scripts you find in the `Stats` folder in this directory. They also allow to plot the results of these analyses using R.

## [04-Filtering_on_number_of_sequences_per_family](04-Filtering_on_number_of_sequences_per_family/README.md)

This folder contains the script allowing to filter gene family files that have less than a certain number of sequences. In this project, we chose to keep all files that have more than 3 sequences. The script just copies the files containing more than the chosen threshold value to this folder in the right Super-Kingdom.
We also re-use the scripts in the previous folder allowing to do basic stats on the sequence files.

## [05-Organising_raw_data_in_database](05-Organising_raw_data_in_database/README.md)

This folder contains scripts to create the architecture of the final database. It also contains the `csv_maker.sh` script that was not used here to win some time, but which can be implemented to transform fasta files into csv files and adding more informations. For now, the only information added was the sequence length, but as said earlier, it can be implemented if needed.
These scripts simply organise the data from the previous folder into the final database that will be implemented as the steps in the project advance.
This is the step that creates the `01-Raw_data` folders in the database.

## [06-Taking_out_gaps_in_sequences](06-Taking_out_gaps_in_sequences/README.md)

In this folder, we go through the sequences in the database and remove some empty sites that are in the gene family files. As these files were aligned by family and that in step 03, we took out sequences from each gene family because it was not in the selected Super-Kingdom, the gene family files have some empty sites. We use a program to take out these empty sites.
In this step, we create the `02-Gaps_removed` folders in the database. this new folder contains the sequences without the empty sites.

## [07-Filtering_sequences_on_their_quality](07-Filtering_sequences_on_their_quality/README.md)

This folder contains the scripts allowing to evaluate a gap score on each gene family file in the database and filter these files according to this gap score value to keep only files that have less gaps and that may be aligned.
This step creates the csvs folder you can see on the illustrative tree above, but also some distribution plots of this gap score across the gene family files in the three Super-Kingdoms.
This step also generates the `03-Better_quality` folder in the database. It only exists for gene families that have a good gap score according to the filtering process.

## [08-Filtering_similar_sequences](08-Filtering_similar_sequences/README.md)

This folder contains the scripts allowing to make a Fast Tree of each gene family file and filter the sequences in said file to take out the sequences that are identical. We use a program to remove phylogenetically identical sequences.
This step is run first on a local machine, then on a cluster to accelerate the process.
This step creates the `04-Similar_sequences_removed` folder in the database. It contains a tree file and a fasta file of the output of the filtering program.

## [09-Optimising_alignment_to_reduce_number_of_sequences](./09-Optimising_alignment_to_reduce_number_of_sequences/README.md)

In this folder, we iterate over the sequence files for each gene family that has a filtered sequence file from the previous step and we take out sequences that are phylogenetically redundant. The optimisation stops when the number of sequences in the considered file is smaller than the user-selected threshold number of sequences or when the proportion of sites matching the requested coverage is at least the user-selected coverage threshold value. 
This step creates the `05-Optimised_alignment` folder in the database. It contains an optimisation-output fasta file.

## [10-First_alignment_of_sequences](./10-First_alignment_of_sequences/README.md)

This folder contains the scripts allowing to align the optimised sequences from each gene family.
The alignment method can be chosen by the user. For now, only three alignment methods are used in this folder, but other ones may be implemented later. 
The files are aligned using two different methods to later use the consensus of these methods to do a phylogenetic tree of the sequences in each gene family. To do this, we use the same script but with different arguments. It therefore creates two new folders in the database: `06-Muscle_alignment` that we can find in each gene family. The other folder in the gene families can either be `06-Prank_alignment` or `06-Mafft_alignment`. The reason for this is that the Prank method does not work for every file. Therefore, in cases of malfunction, we use the Mafft method instead on these files.
This step is run on a cluster to accelerate the process.

## [11-Take_consensus](./11-Take_consensus/README.md)

This folder contains the scripts allowing to select the consensus of the two previously run alignment methods. To do this, we iterate over the gene families in each Super-Kingdom that have an alignment file  and use the BppAlnScore program from the BppSuite to select the consensus. 
This step creates the `07-Consensus` folder in the database. It contains a consensus mase file.

## [12-Format_change_Mase_to_Phylip](./12-Format_change_Mase_to_Phylip/README.md)

This folder contains the scripts to change the format of the consensus file from Mase to Phylip to be able to run PhyML on it. We use the BppSeqMan program from the BppSuite to do this conversion.
This step iterates over the gene families that have a consensus file and creates a phylip file.
This step creates the `08-Phylip_file` in the database. It contains a phylip consensus file.

## [13-Tree_making](./13-Tree_making/README.md)

This folder contains the scripts to make a phylogenetic tree using PhyML[^1].
This step iterates over the gene families that have a Phylip file and ceate a PhyML tree.
This step creates the `09-PhyML_tree` folder in the database. It constains a tree file and a detailled statistical file of the tree processing.

## [14-Tree_conversion](./14-Tree_conversion/README.md)

This folder contains the scripts to change the tree format to be raser compatible. The trees from the PhyML output have a bootstrap value that will be removed in this folder. So we iterate over the folders in the database that have a phyml tree output to convert it.
This step creates the `10-Tree_without_bootstrap` folder in the database.

## [15-Raser_runner](./15-Raser_runner/README.md)

This folder contains the scripts to run RASER[^2] on the files that have a tree without bootstraps. We iterate over the folders that have this newly created tree file to create a Raser parameter file. Once the parameter file is written, we run raser on these files.
This step creates the `11-Raser_outputs` folder in the database. It contains all the outputs of the raser run and the parameter file that was used to run this step.

## [16-Getting_pdb_info_Acnuc](./16-Getting_pdb_info_Acnuc/README.md)

This folder contains the scripts and data to extract all the PDB references from the ACNUC database and cross gene family references with the ones we have at this stage of the pipeline. This step requires to extract some information using the ACNUC recovery program.
Once we have the data extracted from the ACNUC database, we extract all the PDB references from it for each gene family and compiles it to a csv file that is then separated into each gene family.
This step creates the `12-Pdb_information` folder. It contains a csv file that has the PDB references for the gene family and the resolution of the measurement.

## [17-Transforming_raser_output_to_sged](./17-Transforming_raser_output_to_sged/README.md)

This folder contains the scripts used to convert the raser output file to SGED format to make it compatible with the SGED package programs. We iterate over the folders that have a raser output file and transform these output files to SGED files.
This step adds the SGED file to the `12-Pdb_information` folder in the database (a csv file).

## [18-Get_pdb_file_and_create_index](./18-Get_pdb_file_and_create_index/README.md)

This folder contains the scripts allowing us to get the PDB files using their references and selecting the best one for our alignment. We iterate over the gene family folders and extract the PDB files for the ones that have a `12-Pdb_information` folder. Once this is done, we select the best PDB reference by comparing this to the alignment we used to run RASER and create an index of this reference sequence.
This step adds the PDB files and the index to the `12-Pdb_information` folder in the database.

## [19-Structure_information](./19-Structure_information/README.md)

This folder contains the script to translate the coordinates of the index file into alignment positions and in a second step, calculate some relative solvent accessibility (Rsa) and infer the secondary structure of the protein.
We iterate over the folders that have an index file in the `12-Pdb_information` folder and translate the index coordinates into alignment coordinates. Then, we run the calculations to get some site-specific Rsa values and secondary structure of the protein.
This creates the `13-Structure_information` folder in the database. It contains the translated coordinates in SGED format and the structure information in csv format.

## [20-Structure_analysis](./20-Structure_analysis/README.md)

This folder contains the scripts to pull all the structure information that was infered in the previous step and combining it into a csv file. It also allows to do some small structural analysis on these files.
We iterate over the gene families that have a strucutral information SGED file and bind this with all the previous ones to combine them.
This step creates a csv file in the Super-Kingdom folder in the database.


## General useful tools

### The rename script 

The `rename.sh` script has been used to monitor the output of the scripts and more particularly to count the number of outputs after running a step.To run this script, set your working directory to this folder and type
```
bash rename.sh ./Database/ 09
```
This example will iterate over the gene family folders in the database and count how many of these gene families have a `09-PhyML_tree` folder. It will then print out the results.

### The zipper/unzipper scripts

When copying the database to the clusters, as the whole database can not be copied, you have to select only the parts that you need to copy.
The `zipper.sh` will make a copy of the local database, but only with the parts you need for the considered step. For example, in step [11](./11-Take_consensus/README.md), we need the files from folder `10-Tree_without_bootstrap` and the files from the `07-Consensus` folder. In this case, the `zipper.sh` script will create a copy of the database containing the folders 10 and 07 called `Database10` so that you can copy it to the cluster.
The other way around is also taken into account: once you ran the steps on the cluster, to copy the database, if you want to copy just the output of the step you just ran into a new database so that you can transfer it to a local folder on your computer, you can use this script by adding `_1` suffix to the code, as shown in the following accepted codes. 
To run this script, set your working directory to this folder and type
```
bash zipper.sh ./Database/ 10
```
It takes as input the path to the database and a code reference to copy the files in the appropriate folders. The possible codes are the following:
```
08 = To copy files necessary to run step 08-Filtering_similar_sequences
08_1 = To copy the output of the 08-Filtering_similar_sequences step
10 = To copy files necessary to run step 10-First_alignment_of_sequences
10_1 = To copy the output of the 10-First_alignment_of_sequences step
13 = To copy files necessary to run step 13-Tree_making
13_1 = To copy the output of the 13-Tree_making step
15 = To copy files necessary to run step 15-Raser_runner
15_1 = To copy the output of the 15-Raser_runner
```

The `unzipper.sh` script works in the other way. Once you have run the wanted step on the cluster, use the `zipper.sh` script to make a copy database, copy it on this local computer, in this folder and then run the `unzipper.sh` script. It will copy all the folders from the database that was copied from the cluster to the database we are working with. In the same way, to run it, type for example
```
bash unzipper.sh ./Database11_1/
```
It takes as input the path to the database to copy.




# Citations

> [^1] "New Algorithms and Methods to Estimate Maximum-Likelihood Phylogenies: Assessing the Performance of PhyML 3.0." Guindon S., Dufayard J.F., Lefort V., Anisimova M., Hordijk W., Gascuel O. Systematic Biology, 59(3):307-21, 2010. 
> [^2] Penn O, Stern A, Rubinstein ND, Dutheil J, Bacharach E, Galtier N., Pupko T. 2008. Evolutionary Modeling of Rate Shifts Reveals Specificity Determinants in HIV-1 Subtypes. PLoS Computational Biology 4(11): e1000214.
