# 05-Organising_raw_data_in_database

This folder, as do the folowing with some exceptions, does not contain any data. It only contains scripts that allow us to organise the files containing the sequences we will work on into the final database.
In the final database, each Super-Kingdom has a dedicated folder.

We create these folders and their architectures using the following scripts. The first step of the construction is the one in this folder.
For each Super-Kingdom, we create a folder per gene family in which we will store all the data produced in the next steps.
First, we have to store the raw data. To do this, we create a `01-Raw_data` folder in each family folder, where we copy the fasta file containing all the sequences from the considered family. This is done using the `Raw-data_organiser.sh` script that allows to  create this architecture.

The `Raw-data_organiser.sh` script may also runs the `csv_maker.sh` script if needed, but it takes more time. This script converts the fasta file containing the sequences into a csv file containig more informations (sequence name, sequence, sequence length).

To execute this organisation, you simply have to set your working directory in this folder and run the script: 
```
cd Database_3D_proteins/05-Organising_raw_data_in_database
bash ./Raw-data_organiser.sh ../04-Filtering_on_number_of_sequences_per_family
```

This step lasts for :warning: :warning: with the considered database.