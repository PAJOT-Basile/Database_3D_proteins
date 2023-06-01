# 01-AnucFamilies


This folder is a storage folder. It contains all the names of the gene families from the three Super-Kingdoms (Archaea, Bacteria and Eukaryota).
The files inside must be named `FamiliesKDNAME.fam`.
> with KDNAME is the kingdom name of the corresponding super-kingdom.

The names ".fam" files are to be extracted from the ACNUC[^1] retreival software `raa_query.win`, or by using the `raa-query` software in command line format.
To extract these files in command line, follow the following steps:

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
The next step is to select only the sequences that have a PDB reference in this list. To do this, type:
```
modify
list1
7
y
DR

n
PDB;
```
(the empty line after the "DR" is normal, it is here because you have to hit enter twice to select the anotations you want to filter.)
This step gives a second list containing 1436 sequences (the step can be a little bit long depending on the number of sequences in the first list).

Then, we have to select all the gene families that contain these sequences. To do this, type:
```
select
pk list2
```
This creates a new list of 7273 keywords

Then type 
```
find
gene_family

```
(In the same way, the blank line is normal, you have to hit return twice to start the command).
It creates a new list containing 1 keyword.

Then type:
```
select
kd list4
```
This makes a 3558752 keyword list.
Then, we have to take the intersection of these lists so we type:
```
select
list3 et list5
```
This makes a 1035 keyword list. This is the list we want to save, so we type
```
save
list6
FamiliesArchaea.fam
```
It will have saved the list in the folder you were working in. Now you can close the recovery program and do the same for the other Super-Kingdoms.


The `01-AcnucFamilies` folder shall also contain an archive folder called `final_cluster.isoforms.hogenom7.clu.bz2`. This archive file can be found at the folllowing link:
 >     ftp://pbil.univ-lyon1.fr/pub/hogenom/release_07/
      
      
The archive file contains all the sequences form the HOGENOM7 database. The first step will be to extract the files for the family names of each superkingdom (Archaea, Bacteria and Eukaryota).

The `List_superkingdoms.txt` file contains a list of the different kingdoms to run the analyses on.

All the scripts in the following folders (follow the numbers) use the ressource in this folder as a base to run.



```
[^1] Gouy M. & Delmotte S. (2008) Remote access to ACNUC nucleotide and protein sequence databases at PBIL. Biochimie 90:555-562. 
```