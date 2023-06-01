# 17-Transforming_raser_output_to_sged

This folder converts the raser output into a SGED file from the [sgedtools package](https://github.com/jydu/sgedtools/tree/master).

The `launcher.sh` script iterates over each gene family in each Super-Kingdom to start the converter. It takes into account the path to the database to work.

The `sged-raser2sged.py` script is the converter. It takes as input variables a raser output file, the alignment on which the raser program was run, the alignment format and an output path. You can also chose the output format using the `-c` option. The `-c` options sets the ouptut format to csv. The default value is tsv.

To run this step, set your working directory in this folder and run the launcher as follows:
```
cd Database_3D_proteins/17-Transforming_raser_output_to_sged/
bash launcher.sh ../Database/
```
This step does not create any new folder in the database but adds the output of the `sged-raser2sged.py` script in the `12-Pdb_information` folder in the database.