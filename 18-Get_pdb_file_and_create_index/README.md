# 18-Get_pdb_file_and_create_index

This folder contains the script to make a pdb index on the alignment of sequences. This index contains the alignment positions of the reference residues in the best selected PDB reference and the best chain in said PDB reference. 

The `PDB_obtainer.sh` script iterates over the gene families in each Super-Kingdom to run the `sged-create-structure-index.py` script from the [sgedtools package](https://github.com/jydu/sgedtools/tree/master).
The `PDB_obtainer.sh` script takes as input variables the path to the database and the format of the PDB reference files to get.
The format can be one of "pdb" or "mmCif".

So, to run the script, set your working directory in this folder and run the script by typing:
```
cd Database_3D_proteins/18-Get_pdb_file_and_create_index/
bash PDB_obtainer.sh ../Database/ mmCif
```