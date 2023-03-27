#! /bin/bash

# This script takes into account the path to the previous directory and the number of jobs to run in parallel.
DATA_PATH=$1
NUMBER_OF_JOBS=$2

# It then makes a list of all the directories in that folder to extract the names of all the Super-Kingdoms.
LIST_ORDERS=$(cd $DATA_PATH | ls -d */)

# Then, we iterate over the Super-Kingdoms to execute the "Python_launcher.sh" for each family in each Super-Kingdom.
for ORDER in $LIST_ORDERS; do
    
    # First, we make a folder for each Super-Kingdom
    mkdir $ORDER
    
    # We use a counter here, but it is just to know where we are in the process. The printing of the name of the Super-Kingdom serves the same purpose.
    File_number=1
    echo $ORDER

    # We make a list of all the families in the folder that has the name of the Super-Kingdom.
    LIST_FAMILIES=$(ls "${DATA_PATH}${ORDER}")
    
    # We set $@ to the list of families in the folder.
    set -- $LIST_FAMILIES
    # While we have some file names in the list, we count for the number of parallel jobs we set and each time we have that number of jobs, we wait for these jobs
    # to be done before continuing. It also takes out the files that are done from the list. 
    # We start the Python_launcher.sh script that takes into account the path to the data, the name of the Super-Kingdom and the name of the file to analyse.
    # We also print the file number in the list if it is a multiple of 1000 to keep an idea of where we are.
    while (( $# )); do
        for ((i=0; i<$NUMBER_OF_JOBS; i++)); do
            [[ $1 ]] && python3 Isolating_sequences_per_kingdom.py $DATA_PATH $ORDER "$1" & shift
            if [[ $(File_number % 1000) -eq 0 ]]; do
                echo $File_number
            done
            File_number=$(( File_number + 1 ))
        done
        wait
    done
    
done
