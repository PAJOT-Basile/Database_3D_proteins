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
│   ├── List_superkingdoms.txt
│   └── README.md
├── 02-Extracting_families_per_kingdom
│   ├── Archaea
│   ├── Bacteria
│   ├── Eukaryota
│   ├── Family_extractor.py
│   └── README.md
├── 03-Filtering_gene_families_per_kingdom
│   ├── Archaea
│   ├── Bacteria
│   ├── Eukaryota
│   ├── Isolating_sequences_per_kingdom.py
│   ├── launcher.sh
│   ├── README.md
│   └── Stats
│       ├── Number of sequences per family for Archaea.png
│       ├── Number of sequences per family for Bacteria.png
│       ├── Number of sequences per family for Eukaryota.png
│       ├── README.md
│       ├── Stats per Super-Kingdom.png
│       ├── Stats.R
│       ├── Stats.Rproj
│       └── Stats.sh
├── 04-Filtering_on_number_of_sequences_per_family
│   ├── Archaea
│   ├── Bacteria
│   ├── Eukaryota
│   ├── filter.sh
│   ├── README.md
│   └── Stats
│       ├── Number of sequences per family for Archaea.png
│       ├── Number of sequences per family for Bacteria.png
│       ├── Number of sequences per family for Eukaryota.png
│       ├── README.md
│       ├── Stats per Super-Kingdom after filtration.png
│       ├── Stats per Super-Kingdom.png
│       ├── Stats.R
│       └── Stats.Rproj
├── 05-Organising_raw_data_in_database
│   ├── csv_maker.sh
│   ├── Raw_data_organiser.sh
│   └── README.md
├── 06-Taking_out_gaps_in_sequences
│   ├── Gap_remover.sh
│   ├── params.bpp
│   └── README.md
├── 07-Filtering_sequences_on_their_quality
│   ├── csvs
│   ├── Distribution gap score Archaea_simple.png
│   ├── Distribution gap score Bacteria_simple.png
│   ├── Distribution gap score Eukaryota_simple.png
│   ├── distribution.R
│   ├── Gap_score = f(Number_sequences) Archaea.png
│   ├── Gap_score = f(Number_sequences) Bacteria.png
│   ├── Gap_score = f(Number_sequences) Eukaryota.png
│   ├── launcher.sh
│   ├── Quality_evaluator.py
│   └── README.md
├── 08-Filtering_similar_sequences
│   ├── csvs
│   ├── Distribution gap score Archaea_simple.png
│   ├── Distribution gap score Bacteria_simple.png
│   ├── Distribution gap score Eukaryota_simple.png
│   ├── Distribution number of sequences per superkingdom.png
│   ├── distribution.R
│   ├── Fasttree_maker.sh
│   ├── launcher.sh
│   ├── List_gene_families.txt
│   ├── List_maker.sh
│   ├── logs
│   ├── Quality_evaluator.py
│   ├── README.md
│   ├── See_distribution_nb_seq_family.R
│   ├── Similar_sequence_destructor.sh
│   ├── Stats
│   │   ├── Number of sequences per family for Archaea.png
│   │   ├── Number of sequences per family for Bacteria.png
│   │   ├── Number of sequences per family for Eukaryota.png
│   │   └── Stats per Super-Kingdom.png
│   └── Stats.sh
├── 09-Optimising_alignment_to_reduce_number_of_sequences
│   ├── csvs
│   ├── Distribution gap score Archaea_simple.png
│   ├── Distribution gap score Bacteria_simple.png
│   ├── Distribution gap score Eukaryota_simple.png
│   ├── Distribution number of sequences per superkingdom.png
│   ├── distribution.R
│   ├── launcher.sh
│   ├── Optimiser.sh
│   ├── params.bpp
│   ├── Quality_evaluator.py
│   ├── README.md
│   ├── See_distribution_nb_seq_family.R
│   ├── Stats
│   │   ├── Number of sequences per family for Archaea.png
│   │   ├── Number of sequences per family for Bacteria.png
│   │   ├── Number of sequences per family for Eukaryota.png
│   │   └── Stats per Super-Kingdom.png
│   └── Stats.sh
├── 10-First_alignment_of_sequences
│   ├── Align.sh
│   ├── csv_maker.sh
│   ├── List_maker.sh
│   ├── README.md
│   └── timer.py
├── 11-Take_consensus
│   ├── Consensus.sh
│   └── README.md
├── 12-Verification_scripts
│   ├── README.md
│   ├── verificationscript.sh
│   └── Verif_sequence_length.py
├── Database
│   ├── Archaea
│   │   └── Example
│   │       ├── 01-Raw_data
│   │       ├── 02-Gaps_removed
│   │       ├── 03-Better_quality
│   │       ├── 04-Similar_sequences_removed
│   │       └── 05-Optimised_alignment
│   ├── Bacteria
│   └── Eukaryota
└── README.md

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

This folder contains the script allowing to filter gene family files that have less than a certain number of sequences. In this project, we chose to keep all files that have more than 3 sequences. The script just copies the files containing more than the chosen threshold velue to this folder in the right Super-Kingdom.
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
This step creates the `05-Optimised_alignment` folder in teh database. It contains an optimisation-output fasta file.

## [10-First_alignment_of_sequences](./10-First_alignment_of_sequences/README.md)

This folder contains the scripts allowing to align the optimised sequences from each gene family.
The alignment method can be chosen by the user. For now, only three alignment methods are used in this folder, but other ones may be implemented later. 
The files are aligned using two different methods to later use the consensus of these methods to do a phylogenetic tree of the sequences in each gene family. To do this, we use the same script but with different arguments. It therefore creates two new folders in the database: `06-Muscle_alignment` that we can find in each gene family. The other folder in the gene families can either be `06-Prank_alignment` or `06-Mafft_alignment`. The reason for this is that the Prank method does not work for every file. Therefore, in cases of malfunction, we use the Mafft method instead on these files.
This step is run on a cluster to accelerate the process.

## [11-Take_consensus](./11-Take_consensus/README.md)