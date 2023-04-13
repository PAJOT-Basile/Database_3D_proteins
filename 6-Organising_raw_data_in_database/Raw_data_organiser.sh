#! /bin/sh

# We take into account the path to the parallel folder that contains the files to organise in the database
DATA_PATH=$1

# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"

# We iterate over all the orders to do several actions to organise the files in the database
cat $LIST_ORDERS | while read ORDER; do

    # First, we make a folder for each Super-Kingdom. We will fill them in the following steps
    echo $ORDER
    mkdir ../Database/$ORDER

    # We use this file we made in the previous step to extract all the family names
    DATA="$DATA_PATH/Stats/${ORDER}_number_of_sequences_per_family.csv"

    # We iterate over the lines in the csv file containing all the family names
    cat $DATA | while read line; do

        # If the line is the first one,, it is a header. Therefore, there is no information in this line so we skip it
        if [[ $line = "Family_name"* ]]; then 
            continue

        # Otherwise, we extract the family name from the line and create two new directories in the order folder. One is the one 
        # where all the information about one family will be stored and is named after the family. The other one only contains the
        # raw data (fasta file and a csv file that we make containing the name of the sequence, the sequence and the length of this sequence)
        else
            FAMILY_NAME=$(echo $line | cut -d";" -f1)
            mkdir ../Database/$ORDER/$FAMILY_NAME
            mkdir ../Database/$ORDER/$FAMILY_NAME/1-Raw-data

            # Once these directories are created, we copy the fasta file from the parallel folder where we stored it previously in the according folder in the database.
            cp $DATA_PATH/$ORDER/#$FAMILY_NAME#sequences_filtered.fasta ../Database/$ORDER/$FAMILY_NAME/1-Raw-data/$FAMILY_NAME.fasta

            # Finaly, we run the `csv_maker.sh` script that transforms a fasta file into a csv file with some chosen parameters
            bash ./csv_maker.sh ../Database/$ORDER/$FAMILY_NAME/1-Raw-data/ $FAMILY_NAME.fasta
        fi
    done
done
