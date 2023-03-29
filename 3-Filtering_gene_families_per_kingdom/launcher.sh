#! /bin/sh


# This script takes into account the path to the previous directory and the number of jobs to run in parallel.
DATA_PATH=$1

# It then makes a list of all the directories in that folder to extract the names of all the Super-Kingdoms.
LIST_ORDERS="Archaea Bacteria Eukaryota"
# Then, we iterate over the Super-Kingdoms to execute the "Python_launcher.sh" for each family in each Super-Kingdom.
for ORDER in $LIST_ORDERS; do
    
    echo $ORDER
    python3 Isolating_sequences_per_kingdom.py $ORDER $DATA_PATH
    
done
