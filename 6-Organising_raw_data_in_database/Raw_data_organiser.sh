#! /bin/sh

# We take into account the path to the parallel folder that contains the files to organise in the database
DATA_PATH=$1

# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"

# Create a progress bar function to show how we advance in the progress as it is a long process
function ProgressBar {
    # The first variable calculates the percentage of advancement of the process taking into account the beginning and the end of the process to follow
    let _progress=(${1}*100/${2}*100)/100
    # The second variable transforms the advancement of the progress into a number between 1 and 40 to represent it using "#" in the progress bar
    let _done=(${_progress}*4)/10
    # The _left variable takes the complementary number to 40 to be able to fill the empty spots with "-" when the progress bar is loaded
    let _left=40-$_done
    # The "_fill" and "_empty" variables are used to get the number of times we will print each character
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    total_files=${2}

    # Once all of this is done, we print the progress bar
    printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%; doing file number ${1}/$((total_files-1))."

}
# We iterate over all the orders to do several actions to organise the files in the database
cat $LIST_ORDERS | while read ORDER; do

    # First, we make a folder for each Super-Kingdom. We will fill them in the following steps
    echo $ORDER
    mkdir ../Database/$ORDER

    # We use this file we made in the previous step to extract all the family names
    DATA="$DATA_PATH/Stats/${ORDER}_number_of_sequences_per_family.csv"

    # The two following variables are used to define and use the progress bar
    data_length=$(wc -l $DATA)
    counter=1

    # We iterate over the lines in the csv file containing all the family names
    cat $DATA | while read line; do

        # We implement the progress bar to the code
        ProgressBar ${counter} ${data_length}

        # If the line is the first one,, it is a header. Therefore, there is no information in this line so we skip it
        if [[ $line = "Family_name"* ]]; then 
            continue

        # Otherwise, we extract the family name from the line and create two new directories in the order folder. One is the one 
        # where all the information about one family will be stored and is named after the family. The other one only contains the
        # raw data (fasta file and a csv file that we make containing the name of the sequence, the sequence and the length of this sequence)
        else
            FAMILY_NAME=$(echo $line | cut -d";" -f1)
            mkdir ../Database/$ORDER/$FAMILY_NAME
            mkdir ../Database/$ORDER/$FAMILY_NAME/1-Raw_data

            # Once these directories are created, we copy the fasta file from the parallel folder where we stored it previously in the according folder in the database
            cp $DATA_PATH/$ORDER/#$FAMILY_NAME#sequences_filtered.fasta ../Database/$ORDER/$FAMILY_NAME/1-Raw_data/$FAMILY_NAME.fasta

            # Finaly, we run the `csv_maker.sh` script that transforms a fasta file into a csv file with some chosen parameters
            bash ./csv_maker.sh ../Database/$ORDER/$FAMILY_NAME/1-Raw_data/ $FAMILY_NAME.fasta
        fi
        ((counter+=1))
    done
done