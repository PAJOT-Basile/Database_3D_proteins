# 08-Organising_raw_data_in_database

This folder does not contain any data. It only contains scripts that allow us to organise the files containing the sequences we will work on into the final database.
In the final database, each Super-Kingdom has a dedicated folder.

We create these folders and their architectures using the following scripts. The first step of the construction is the one in this folder.
For each Super-Kingdom, we create a folder per family in which we will store all the data produced in the next steps.
First, we have to store the raw data. To do this, we create a `1-Raw_data` folder in each family folder, where we copy the fasta file containing all the sequences from the considered family. This is done using the `Raw-data_organiser.sh` script that allows to  create this architecture.
The `Raw-data_organiser.sh` script also runs the `csv_maker.sh` script in this folder that converts the fasta file containing the sequences into a csv file containig more informations (sequence name, sequence, sequence length). This shall be improved if needed.

To execute this organisation, you simply have to place your working directory in this folder: `cd Database_3D_proteins/7-Organising_raw_data_in_database`
And then run the scripts: `bash ./Raw-data_organiser.sh ../4-Filtering_on_number_of_sequences_per_family`.

This step lasts for 

You just need to have created the `Database` folder first using the `mkdir Database` while in the `Database_3D_proteins` folder.