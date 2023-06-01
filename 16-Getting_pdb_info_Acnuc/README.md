# 16-Getting_pdb_info_Acnuc

The `.dat` files are extracted from the ACNUC database. They contain all the Genbank format sequences from every gene family in the considered Super-Kingdom. Here, we want to extract the PDB information for each sequence that we have in the database.
To extract these folders from the ACNUC database using the command line, do:
```
raa_query
```
This opens the query program.
Then, select the database number corresponding to what you want `9`
then type
```
select
sp=ARCHAEA
```
then type 
```
modify
list1
7
y
DR

n
PDB;
```
This step allows to scan all the anotations of the first list to select only the families that have a PDB.
Finaly, extract the sequences using 
```
extract
list2
y
3
Archaea_seqfile.dat
1
```
This extracts all the sequences and annotations from said Super-Kingdom that have a PDB in the Genbank format allowing you to continue. 

The `General_PDB_extractor.sh` program iterates over the lines in the `.dat` files and extracts all the references of each PDB structure for each Super-Kingdom. It creates a csv file containing the name of the gene family and sequence to which the PDB corresponds, the PDB reference and the resolution of the 3D measurement.

The `Filter_on_Pdb.py` script iterates over the gene families in each Super-Kingdom to extract the pdb information of said gene family from the csv that was built. It runs the `Copier.sh` script that saves these informations in a newly created folder in the database.

To run these scripts, first set your working directory in this folder then run them by doing:
```
cd Database_3D_proteins/16-Getting_pdb_info_Acnuc
# First run the General_PDB_extractor.sh script
bash General_PDB_extractor.sh ../Database/

# Then run the python script
python3 Filter_on_Pdb.py ../Database/
```
This step creates the `12-Pdb_information` folder in the database.
