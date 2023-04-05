#! /bin/sh

# We save the default IFS here for this script given we will modify it
DEFAULT_IFS=$IFS

# If run before, we clean up the working environment to not mix everything up
rm -R Archaea Bacteria Eukaryota

# This script takes into account the path to the folder to filter and the minimal number of sequences per gene family to keep
DATA_PATH=$1
LIMIT_NUMBER_SEQUENCES=$(( $2 - 1 ))
# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"

# We iterate over each Super-Kingdoms to test the number of sequences. If there are enough, we copy the gene family file from the previous folder to this one
cat $LIST_ORDERS | while read ORDER; do

    echo $ORDER
    # We create a folder for each Super-Kingdom.
    mkdir $ORDER

    # We consider the previously created csv file contining the number of sequences per gene family to filter. We iterate over the lines and test each one
    FILE_TO_FILTER="${DATA_PATH}Stats/${ORDER}_number_of_sequences_per_family.csv"
    cat $FILE_TO_FILTER | while read LINE; do 
        
        # If the line starts with "Family_name", it is the header, so we continue
        if [[ $LINE = "Family_name"* ]]; then
            continue
        # Otherwise, we set the IFS to ";" (csv file) and make each line an array to extract only the part with the sequence number
        else
            IFS=";"
            read -a readline <<< "$LINE"
            FAM_NAME="${readline[0]}"
            NUM_SEQ="${readline[1]}"

            # If the line number is greater than the selected number, we copy the corresponding file
            if [[ $(($NUM_SEQ)) -gt $LIMIT_NUMBER_SEQUENCES ]]; then
                cp ${DATA_PATH}${ORDER}/\#${FAM_NAME}\#sequences_filtered.fasta ./${ORDER}
            else
                continue
            fi
        fi

    done
done

# We reset the default IFS
IFS=$DEFAULT_IFS

# Start the new stats scripts to see the number of sequences after filtering
bash ../3-Filtering_gene_families_per_kingdom/Stats/Stats.sh "After"