# 02-Extracting_families_per_kingdom

This folder is the first folder in which we will be executing some scripts.

The first step is to take the names of the gene families for each Super-Kingdom we are working with and extract the correcponding files from the archive file.
To do this, the script `Family_extractor.py` will iterate over the lines in the archive file and compare each family name to the ones that are in the `FamiliesKINGDOM.fam` files.
> KINGDOM being the Super-Kingdom we are working with.

It will make one file per gene family name. It will store the files from each Super-Kingdom in the corresponding folder (created when the script is started).
Each gene family file contains all the sequences in the gene family.
To run this script, set your working directory to this folder and write
```
cd Database_3D_proteins/02-Extracting_families_per_kingdom/
python3 Family_extractor.py ../01-AcnucFamilies/
``` 
This step is a long one. It takes a lot of time (8h).



Later, we will also add three files to this folder. We need to extract the `KINGDOM_sequences.mne` files from the ACNUC database usnng the same recovery program as in step 01. It contains all the names of the sequences that are present in each Super-Kingdom.
To get these files, follow this protocol:
First, open the `raa_qurey` software by typing in your terminal:
```
raa_query
```
Then select the database to work with by typing its code. In our case,
```
9
```

Then select the Super-Kingdom we are working with by typing
```
select
sp=ARCHAEA
```
This makes a list containing 547198 sequences.
This is the list we will save. To do this, type:
```
save
list1
Archaea_sequences.mne
```
It will have saved the list in the folder you were working in. Now you can close the recovery program and do the same for the other Super-Kingdoms.
These three files are necessary for the next step.
