#! /bin/sh
#SBATCH --time=24:00:00
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --array=1-2000%15
#SBATCH --output=./logs/output_order.%a.out

# This script takes into accout the path to the database
DATA_PATH=$1

# The second argument is a threshold value. If it is not needed, the default value is 0. It can be used to filter the files that have 
# more than the selected threshold to not load all the files into the physamp program. If it is not needed, the default value is 0, 
# therefore taking all the files
THRESH_NB_SEQ=${2:-0}

# This file contains a list of all the gene families and the Super-Kingdom they are a part of. We will iterate over it using a slurm array
LIST_FAMILIES="List_gene_families.txt"

# We make a SimilarSequenceDestroyer function that compares the number of sequences in the gene family file it is asked to filter 
# to the threshold value. If the threshold value is higher than the number of sequences in the file, it is just copied. In the other case,
# the file containing the sequences as well as the Fast tree are used as inputs for the PhySamp program that removes phylogenetically related
# sequences. The path to the program may vary depending on the way it is installed on the cluster and may be changed 
SSeqDest(){

    # Variable input
    DATA_PATH=$1
    FAMILY_PATH=$2
    THRESH_NB_SEQ=$3

    # We extract the gene family name from the line of the "List_gene_families.txt" file
    FAMILY_NAME=$(echo $FAMILY_PATH | cut -d"/" -f2)
    echo $FAMILY_NAME

    # The gene family folders that have a "03-Better_quality" folder are the ones that have passed the gap score filtering. Therefore, we will apply 
    # the analysis to these gene families.
    if [ -d "$DATA_PATH$FAMILY_PATH/03-Better_quality/" ]; then

            # We count the number of sequences in the file to compare it to the threshold
            NB_SEQ=$(grep -c "^>" $DATA_PATH$FAMILY_PATH/03-Better_quality/$FAMILY_NAME.fasta)
            if [[ $NB_SEQ -gt $THRESH_NB_SEQ ]]; then


                # The PhySamp program takes only absolute paths so the three next variables are made to get the absolute path to the input and output
                # files used in the PhySamp program
                INPUT_SEQ_PATH=$(readlink -f $DATA_PATH$FAMILY_PATH/03-Better_quality/$FAMILY_NAME.fasta)
                INPUT_TREE_PATH=$(readlink -f $DATA_PATH$FAMILY_PATH/04-Similar_sequences_removed/$FAMILY_NAME.tree)
                OUTPUT_PATH=$(echo $(readlink -f $DATA_PATH$FAMILY_PATH/04-Similar_sequences_removed)/$FAMILY_NAME.fasta)
                
                # We use the PhySamp program to take out identical sequences in the gene family files and wait for it to have finished
                /scratch/users/basile.pajot/Downloads/physamp/bppphysamp alphabet=Protein \
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
                cp $DATA_PATH/$FAMILY_NAME/03-Better_quality/$FAMILY_NAME.fasta $DATA_PATH$FAMILY_PATH/04-Similar_sequences_removed/$FAMILY_NAME.fasta
            fi
        fi
}

# We extract the line number "SLURM_ARRAY_TASK_ID" to use as a gene family path to the gene family file
FAMILY_PATH=$(cat $LIST_FAMILIES | head -n $SLURM_ARRAY_TASK_ID | tail -n1)
echo $FAMILY_PATH

# For each line in the "List_gene_families.txt" file, we apply the SSeqDest function that runs the PhySamp program
SSeqDest ${DATA_PATH} ${FAMILY_PATH} ${THRESH_NB_SEQ}

