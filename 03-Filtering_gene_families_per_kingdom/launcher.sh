#! /bin/sh

# This script takes into account the path to the previous directory
DATA_PATH=$1

# If run before, we clean up the working environment to not mix everything up.
rm -R Archaea Bacteria Eukaryota

# Make a list of the Super-Kingdoms to consider
LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"

# Then, we iterate over the Super-Kingdoms to execute the "Isolating_sequences_per_kingdom.py" for each family in each Super-Kingdom
cat $LIST_ORDERS | while read ORDER; do
    
    echo $ORDER
    # We make a file containing all the sequences that are to be checked in the gene family files
    cat ${DATA_PATH}${ORDER}/* | grep "^>" | cut -d">" -f2 | sort > ${DATA_PATH}${ORDER}_sequences_in_families.txt
    
    # We make a local directory in which to save all the files with the extracted sequences
    mkdir $ORDER
    python3 Isolating_sequences_per_kingdom.py $ORDER $DATA_PATH
    
done

# We execute the Stats.sh script to make some stats on the extracted gene families and sequences.
bash ./Stats/Stats.sh "Before"