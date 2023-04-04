# 5-Verification_scripts

This folder contains the scripts that allow to do some verifications on the sequences once they are aligned.

The `verificationscript.sh` script is a bash script that transforms the aligned sequences into a csv file extracting every sequence and pasting all the bits on the same line. It also counts the length of the sequence and adds it to the csv. It also starts running the `Verif_sequence_length.py` script.

## Length verification

The `Verif_sequence_length.py` script verifies it any sequence in the alignment has a different length compared to the others. If one does, it prints the sequence name.