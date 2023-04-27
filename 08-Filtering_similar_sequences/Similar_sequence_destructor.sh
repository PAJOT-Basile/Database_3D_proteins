#! /bin/sh

#SBATCH --time=24:00:00
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --array=1-2000%15
#SBATCH --output=./logs/output_order.%a.out

DATA_PATH=$1

# The second argument is a threshold value. If it is not needed, the default value is 0. It can be used to filter the files that have 
# more than the selected threshold to not load all the files into the physamp program. If it is not needed, the default value is 0, 
# therefore taking all the files
THRESH_NB_SEQ=${3:-0}

LIST_FAMILIES="List_gene_families.txt"


SSeqDest(){

    # Variable input
    DATA_PATH=$1
    FAMILY_PATH=$2
    THRESH_NB_SEQ=$3
    FAMILY_NAME=$(echo $FAMILY_PATH | cut -d"/" -f2)
    echo $FAMILY_NAME

    # The gene family folders that have a "03-Better_quality" folder are the ones that have passed the gap score filtering. Therefore, we will apply 
    # the analysis to these gene families
    if [ -d "$DATA_PATH$FAMILY_PATH/03-Better_quality/" ]; then

            # We count the number of sequences in the file to compare it to the threshold
            NB_SEQ=$(grep -c "^>" $DATA_PATH$FAMILY_PATH/03-Better_quality/$FAMILY_NAME.fasta)
            if [[ $NB_SEQ -gt $THRESH_NB_SEQ ]]; then


                # The physam program takes only absolute paths so the three next variables are made to get the absolute path to the input and output
                # files used in the physam program
                INPUT_SEQ_PATH=$(readlink -f $DATA_PATH$FAMILY_PATH/03-Better_quality/$FAMILY_NAME.fasta)
                INPUT_TREE_PATH=$(readlink -f $DATA_PATH$FAMILY_PATH/04-Similar_sequences_removed/$FAMILY_NAME.tree)
                OUTPUT_PATH=$(echo $(readlink -f $DATA_PATH$FAMILY_PATH/04-Similar_sequences_removed)/$FAMILY_NAME.fasta)
                
                # We use the physam program to take out identical sequences in the gene family files and wait for it to have finished
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

FAMILY_PATH=$(cat $LIST_FAMILIES | head -n $SLURM_ARRAY_TASK_ID | tail -n1)
echo $FAMILY_PATH
# For each gene family folder, we apply the SSeqDest function using sem allowing us to use several cpus at once
SSeqDest ${DATA_PATH} ${FAMILY_PATH} ${THRESH_NB_SEQ}


