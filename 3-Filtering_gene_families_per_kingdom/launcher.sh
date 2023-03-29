#! /bin/sh

# This script takes into account the path to the previous directory.
DATA_PATH=$1

# It then makes a list of all the directories in that folder to extract the names of all the Super-Kingdoms.
LIST_ORDERS=$(cd $DATA_PATH | ls -d */)
# Then, we iterate over the Super-Kingdoms to execute the "Isolating_sequences_per_kingdom.py" for each family in each Super-Kingdom.
for ORDER in $LIST_ORDERS; do
    
    # We make a file containing all the sequences that are to be checked in the gene family files.
    cat "${DATA_PATH}${ORDER}/*" | grep "^>" | cut -d">" -f2 | sort > "${DATA_PATH}${ORDER}_sequences_in_families.txt"
    
    echo $ORDER
    # We make a local directory in which to save all the files with the extracted sequences.
    mkdir $ORDER
    python3 Isolating_sequences_per_kingdom.py $ORDER $DATA_PATH
    
done
