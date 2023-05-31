# 19-Structure_information

This folder uses the previously created index and SGED files and creates a SGED file containing the translated coordinates of the reference PDB chain onto the gene family consensus alignment. 
It is then used to get some structural information on the proteins on these sites. 

The `Coordinate_translator_and_structure_info_extractor.sh` script iterates over the gene families in each Super-Kingdom to runs both the `sged-translate-coords.py` script and the `sged-structure-infos.py` script from the [SGED package](https://github.com/jydu/sgedtools). It takes as argument the path to the database.


To run `Coordinate_translator_and_structure_info_extractor.sh`, set your working directory to this folder and type:
```
cd Database_3D_proteins/19-Structure_information/
bash Coordinate_translator_and_structure_info_extractor.sh ../Database/
``` 