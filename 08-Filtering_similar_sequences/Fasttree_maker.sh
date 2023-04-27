#! /bin/sh

# This script takes into accout the path to the database
DATA_PATH=$1

# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"

# We make a Fasttree function that takes as input the path to the database, the name of the Super-Kingdom to analyse and
# the gene family name to run. It will produce a tree using the Fast Tree program. You can find the documentation of this 
# program here: http://www.microbesonline.org/fasttree/
# The produced tree wil be stored in a newly created folder.
Fasttree(){

    # Variable input
    DATA_PATH=$1
    ORDER=$2
    FAMILY_NAME=$3

    # The gene family folders that have a "03-Better_quality" folder are the ones that have passed the gap score filtering. Therefore, we will apply 
    # the analysis to these gene families
    if [ -d "$DATA_PATH$ORDER/$FAMILY_NAME/03-Better_quality/" ]; then

            # If the script was run before, we remove the output to rewrite it. We start by creating a new folder where the newly created files
            # will be stored
            if [ -d "$DATA_PATH$ORDER/$FAMILY_NAME/04-Similar_sequences_removed" ]; then
                rm -r $DATA_PATH$ORDER/$FAMILY_NAME/04-Similar_sequences_removed
            fi
            mkdir $DATA_PATH$ORDER/$FAMILY_NAME/04-Similar_sequences_removed

            # We make a basic fast tree to use later as input for the physam program and wait for the tree to be done before keeping going on
            fasttree $DATA_PATH$ORDER/$FAMILY_NAME/03-Better_quality/$FAMILY_NAME.fasta > $DATA_PATH$ORDER/$FAMILY_NAME/04-Similar_sequences_removed/$FAMILY_NAME.tree
            wait
        fi
}

# We export the Fasttree function so it can be used with the parallel program.
export -f Fasttree

# We iterate over each order
cat $LIST_ORDERS | while read ORDER; do

    echo $ORDER

    # For each Super-Kingdom, we make a list of all the gene family folders in said Super-Kingdom and iterate over them
    LIST_FAMILIES=$(ls $DATA_PATH$ORDER)
    for FAMILY in $LIST_FAMILIES; do
        # For each gene family folder, we apply the Fasttree function using sem allowing us to use several cpus at once
        sem --jobs -0 Fasttree ${DATA_PATH} ${ORDER} ${FAMILY}
    done  
done