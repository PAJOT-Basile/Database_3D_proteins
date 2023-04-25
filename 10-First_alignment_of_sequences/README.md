# 09-First_alignment_of_sequences

This folder contains the scripts to do the first alignment of the raw data. This is a fast alignment of all the sequences. We use the _____ alignment method.

This method is chosed for its alignment speed over precision given we have a lot of files with lots of sequences (16 897 with more than 100 000 sequences in several).

This step is done to do a first alignment of the sequences to be able to cluster the close ones, therefore making it easy for us in the next step to align the sequences using a more precise alignment method.

The `Align.sh` script aligns the sequences using the _____ method. It iterates over each folder for each Super-Kingdom in the database and takes the fasta file of each gene family to align it.



To run: `bash ./Align.sh ../Database/ "METHOD"`
> with `METHOD` being one of MAFFT, MUSCLE, CLUSTAL_OMEGA, T_COFFEE, CLUSTALW or PRANK