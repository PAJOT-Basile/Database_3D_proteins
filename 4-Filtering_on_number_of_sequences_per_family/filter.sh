#! /bin/sh

DEFAULT_IFS=$IFS

# If run before, clean up
rm -R Archaea Bacteria Eukaryota

DATA_PATH=$1
LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"


cat $LIST_ORDERS | while read ORDER; do

    echo $ORDER
    mkdir $ORDER

    FILE_TO_FILTER="${DATA_PATH}Stats/${ORDER}_number_of_sequences_per_family.csv"
    cat $FILE_TO_FILTER | while read LINE; do 
        
        if [[ $LINE = "Family_name" ]]; then
            continue
        else
            IFS=";"
            read -a readline <<< "$LINE"
            FAM_NAME="${readline[0]}"
            NUM_SEQ="${readline[1]}"

            if [[ $(($NUM_SEQ)) -gt 3 ]]; then
                cp ${DATA_PATH}${ORDER}/\#${FAM_NAME}\#sequences_filtered.fasta ./${ORDER}
            else
                continue
            fi
        fi

    done
done


IFS=$DEFAULT_IFS

# Start the new stats scripts to see after filtering on the number of sequences.

bash ./Stats.sh