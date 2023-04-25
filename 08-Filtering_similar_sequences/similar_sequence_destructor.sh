#! /bin/sh

# This script takes into accout the path to the database
DATA_PATH=$1

# The second argument is a threshold value. If it is not needed, the default value is 0. It can be used to filter the files that have 
# more than the selected threshold to not load all the files into the physamp program. If it is not needed, the default value is 0, 
# therefore taking all the files
THRESH_NB_SEQ=${2:-0}

# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"

# We make a SimilarSequenceDestructor function that takes as input the path to the database, the name of the Super-Kingdom to analyse and
# the gene family name to run. For the gene families that have passed the filtration filter on the gap score, it will produce a tree using
# the Fast Tree program. You can find the documentation of this program here: http://www.microbesonline.org/fasttree/
# The produced tree as well as the fasta file of said gene family are used as input to run the physam program that removes sequences that are
# similar. The threshold value indicated in the program is the closest distance between sequences to keep. The low value is due to the fact that
# in this step, we only want to keep the entirely identical sequences
SSeqDest(){

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

            # We count the number of sequences in the file to compare it to the threshold
            NB_SEQ=$(grep -c "^>" $DATA_PATH$ORDER/$FAMILY_NAME/03-Better_quality/$FAMILY_NAME.fasta)
            if [[ $NB_SEQ -gt $THRESH_NB_SEQ ]]; then

                # We make a basic fast tree to use later as input for the physam program and wait for the tree to be done before keeping going on
                fasttree $DATA_PATH$ORDER/$FAMILY_NAME/03-Better_quality/$FAMILY_NAME.fasta > $DATA_PATH$ORDER/$FAMILY_NAME/04-Similar_sequences_removed/$FAMILY_NAME.tree
                wait

                # The physam program takes only absolute paths so the three next variables are made to get the absolute path to the input and output
                # files used in the physam program
                INPUT_SEQ_PATH=$(readlink -f $DATA_PATH$ORDER/$FAMILY_NAME/03-Better_quality/$FAMILY_NAME.fasta)
                INPUT_TREE_PATH=$(readlink -f $DATA_PATH$ORDER/$FAMILY_NAME/04-Similar_sequences_removed/$FAMILY_NAME.tree)
                OUTPUT_PATH=$(echo $(readlink -f $DATA_PATH$ORDER/$FAMILY_NAME/04-Similar_sequences_removed)/$FAMILY_NAME.fasta)
                
                # We use the physam program to take out identical sequences in the gene family files and wait for it to have finished
                ~/Downloads/physamp/bppphysamp alphabet=Protein \
                            input.sequence.format=Fasta\(\) \
                            input.sequence.file=$INPUT_SEQ_PATH \
                            input.method=tree \
                            input.tree.file=$INPUT_TREE_PATH \
                            output.sequence.format=Fasta\(\) \
                            output.sequence.file=$OUTPUT_PATH \
                            deletion_method=threshold \
                            threshold=0.01
                wait
            else
                # If the number of sequences is under the selected threshold, we just copy the gene family file
                cp $DATA_PATH$ORDER/$FAMILY_NAME/03-Better_quality/$FAMILY_NAME.fasta $DATA_PATH$ORDER/$FAMILY_NAME/04-Similar_sequences_removed/$FAMILY_NAME.fasta
            fi
        fi
}

# We export the SSeqDest function so it can be used with the parallel program
export -f SSeqDest

# We iterate over each order.
cat $LIST_ORDERS | while read ORDER; do

    echo $ORDER

    # For each Super-Kingdom, we make a list of all the gene family folders in said Super-Kingdom and iterate over them
    LIST_FAMILIES=$(ls $DATA_PATH$ORDER)
    for FAMILY in $LIST_FAMILIES; do
        # For each gene family folder, we apply the SSeqDest function using sem allowing us to use several cpus at once
        sem --jobs -2 SSeqDest ${DATA_PATH} ${ORDER} ${FAMILY}
    done  
done