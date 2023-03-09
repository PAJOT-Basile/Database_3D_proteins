This folder contains the R script to transform the ACNUC files in the Acnuc_sequences_Genbank folder.

It uses multithreading for big datasets, but can be deactivated if you choose a smaller dataset.
To deactivate the multithreading, you can simply replace the end line :

`mclapply(file, extract, mc.cores = 7)` by `lapply(file, extract)`

This script takes the ACNUC files and creates a table containing the IDs, taxonomy and sequence extracted from the ACNUC database.

The only two conditions for this to work are to:
  1. Have the files extracted from ACNUC under the Genbank format (".gb" files)
  2. Have these data files located in the beforementionned storage folder (*Acnuc_sequences_Genbank*)
