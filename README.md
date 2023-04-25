# Database_3D_proteins

Here is the organisation of the github repository and the architecture of the scripts to use.
Database_3D_proteins
├── 01-AcnucFamilies
│   ├── FamiliesArchaea.fam
│   ├── FamiliesBacteria.fam
│   ├── FamiliesEukaryota.fam
│   ├── final_clusters.isoforms.hogenom7.clu.bz2
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
│       ├── README.md
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
│       ├── README.md
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
│   ├── distribution.R
│   ├── launcher.sh
│   ├── Quality_evaluator.py
│   └── README.md
├── 08-Filtering_similar_sequences
│   ├── Archaea
│   ├── Bacteria
│   ├── README.md
│   ├── similar_sequence_destructor.sh
│   └── Trees
│       ├── Archaea
│       └── Bacteria
├── 09-Optimising_alignment_to_reduce_number_of_sequences
│   ├── Archaea
│   ├── Bacteria
│   ├── bppalnoptim.log
│   ├── logs
│   ├── Optimiser.sh
│   ├── params.bpp
│   └── README.md
├── 10-First_alignment_of_sequences
│   ├── Align.sh
│   ├── measure_seq_length.sh
│   ├── README.md
│   └── timer.py
├── 11-Verification_scripts
│   ├── README.md
│   ├── verificationscript.sh
│   └── Verif_sequence_length.py
├── Database
│   ├── Archaea
│   │   └── Example
│   │       ├── 01-Raw_data
│   │       │   └── Example.fasta
│   │       ├── 02-Gaps_removed
│   │       │   └── Example.fasta
│   │       ├── 03-Better_quality
│   │       │   └── Example.fasta
│   │       └── 04-Similar_sequences_removed
│   │           ├── Example.fasta
│   │           └── Example_tree.tree
│   ├── Bacteria
│   └── Eukaryota
└── README.md

All the folders that have the name Archaea Bacteria or Eukaryota are built in the same way inside the considered directory. Every time the three Super-Kingdoms are in the same folder, they are composed of a list of fasta files containing all the sequences for the different gene families in said Super-Kingdom.
The only exception is the Database folder. In this folder, the Super-Kingdoms have one subdirectory for each gene family divided into several sub-directories, all looking like the `Example` folder in the Archaea Super-Kingdom.
