# 12-Format_change_Mase_to_Phylip

This step is simply a conversion step. It converts the consensus mase file into a phylip file to be used in the PhyML program to have a maximum likelihood tree.

The `Phylip_maker.sh` script takes as an argument the path to the database and iterates over the orders and the gene families to transform the mase file into a phylip file if the mase file exists.
To run this step, simply set your working directory to this file and run the script:
```
cd Database_3D_proteins/12-Format_change_Mase_to_Phylip/
bash Phylip_maker.sh ../Database/
```

This step creates the `08-Phylip_file` folder in the database.