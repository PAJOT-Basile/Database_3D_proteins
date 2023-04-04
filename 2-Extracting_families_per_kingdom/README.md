# 2-Extracting_families_per_kingdom

This folder is the first folder in which we will be executing some scripts.

The first step is to take the names of the gene families for each Super-Kingdom we are working with and extract the correcponding files from the archive file.
Therefore, the script `Family_extractor.py` will iterate over the lines in the archive file and compare each family name to the ones that are in the `FamiliesKINGDOM.fam` files.
> KINGDOM being the Super-Kingdom we are working with.

It will make one file per gene family name. It will store the files from each Super-Kingdom in the corresponding folder (created when the script is started).


Later, we will also add three files to this folder. We need to extract the `KINGDOM_sequences.mne` files from the ACNUC database. It contains all the names of the sequences that are present in each Super-Kingdom.

To run this script, write `python3 Family_extractor.py ../1-AcnucFamilies`. 
This step is a long one. It takes a lot of time (8h).
