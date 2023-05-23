#! /bin/sh

#SBATCH --time=48:00:00
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --array=1-3%3
#SBATCH --output=./logs/Prank/run9/slurm_%j_%a.out


# We take into account the path to the database
DATA_PATH=$1
# We take into account the method we want to use to make one script able to all the wanted alignments
if [ -z "$2" ]; then
    read -r -p "Please indicate the alignment method to use. It shall be one of MAFFT, MUSCLE, PRANK.
    " METHOD
else
    METHOD=$(echo $2 | tr '[:lower:]' '[:upper:]')
fi

# We will filter the files that have less than the sected threshold of sequences. This value can be chosen by the user
THRESH_SEQ=${3:-2}
method_lower=$(echo $METHOD | tr '[:upper:]' '[:lower:]')
method=$(echo ${method_lower^})



Align(){

    DATA_PATH=$1
    ORDER=$2
    FAMILY=$3
    METHOD=$4
    THRESH_SEQ=$5


    # Clean up the created directory if run before
    if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/06-${method}_alignment" ]; then
        rm -r ${DATA_PATH}${ORDER}/${FAMILY}/06-${method}_alignment
    fi

    # If the previous folder exists, we execute the following 
    if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/05-Optimised_alignment" ]; then

        # We measure the number of sequences in the considered file and compare it to the selected threshold
        NSEQ=$(grep -c "^>" ${DATA_PATH}${ORDER}/${FAMILY}/05-Optimised_alignment/${FAMILY}.fasta)
        if [[ $NSEQ -gt $THRESH_SEQ ]]; then
            # We create a directory where the aligned sequences will be stored
            mkdir ${DATA_PATH}${ORDER}/${FAMILY}/06-${method}_alignment

            # We create a csv file containing all the parameters of the alignment. The number of sequences, the sequence lengths, the time it took to
            # align all these sequences and the sequence length after the alignment. If the following csv file exists, we continue. Otherwise,
            # we create it and add a header
            if [ ! -f "./Alignment_speeds.csv" ]; then
                echo "Order;Family_name;Number_sequences;Minimum_seq_length;Maximum_seq_length;Mean_seq_length;Time;Method;Seq_length_after_alignment" >> ./Alignment_speeds.csv
            fi

            # Here, we select the alignment method asked in the command line. Each time, we measure the time before and after the alignment to calculate the
            # time it took to align the sequences. We also wait for each alignment process to finish before we keep on going

            # Mafft
            if [[ $METHOD = "MAFFT" ]]; then
                # We load the module
                module load mafft
                # We store the date in a varible to count the elapsed time for the alignment process
                time_before=$(date "+%d%H%M%S")
                # We start the alignment on the appropriate fasta file using the right method in the database and add the output to the newly created folder
                # We wait for the alignment process to be done before carrying on.
                mafft ${DATA_PATH}${ORDER}/${FAMILY}/05-Optimised_alignment/${FAMILY}.fasta > \
                ${DATA_PATH}${ORDER}/${FAMILY}/06-${method}_alignment/${FAMILY}.fasta
                wait
                # We measure the time after the process to know how long it took to align the data
                time_after=$(date "+%d%H%M%S")
            
            # Muscle
            elif [[ $METHOD = "MUSCLE" ]]; then
                module load muscle
                time_before=$(date "+%d%H%M%S")
                muscle -in ${DATA_PATH}${ORDER}/${FAMILY}/05-Optimised_alignment/${FAMILY}.fasta \
                -out ${DATA_PATH}${ORDER}/${FAMILY}/06-${method}_alignment/${FAMILY}.fasta
                wait
                time_after=$(date "+%d%H%M%S")

            # Prank
            elif [[ $METHOD = "PRANK" ]]; then
                module load prank
                time_before=$(date "+%d%H%M%S")
                prank -d=${DATA_PATH}${ORDER}/${FAMILY}/05-Optimised_alignment/${FAMILY}.fasta \
                -o=${DATA_PATH}${ORDER}/${FAMILY}/06-${method}_alignment/${FAMILY}.fasta
                wait
                time_after=$(date "+%d%H%M%S")

            else
                printf "Method $METHOD is not known. Please choose one of the following: MAFFT, MUSCLE, PRANK"
                break 2
            fi

            # We measure the time difference between the beginning and the end of the alignment process
            time_difference=$(echo "$time_after-$time_before" | bc)
            # We create a csv file from the aligned sequence file
            bash ./csv_maker.sh ${DATA_PATH} ${ORDER} ${FAMILY} 06-${method}_alignment ${METHOD}
            # We run the "timer.py" python script that will analyse the time difference and complete the csv file created earlier 
            python2.7 timer.py ${DATA_PATH}${ORDER}/${FAMILY}/06-${method}_alignment/ $time_difference $METHOD
        else
            echo "Family $family does not contain enough sequences to be aligned. Nb_seq = $NSEQ"
        fi
    fi
}





# This file contains a list of all the gene families and the Super-Kingdom they are a part of. We will iterate over it using a slurm array
LIST_FAMILIES="List_gene_families.xtxt"

FAMILY_PATH=$(cat $LIST_FAMILIES | head -n $SLURM_ARRAY_TASK_ID | tail -n1)
echo $FAMILY_PATH
ORDER=$(echo $FAMILY_PATH | cut -d"/" -f1)
FAMILY=$(echo $FAMILY_PATH | cut -d"/" -f2)
echo $FAMILY

Align ${DATA_PATH} ${ORDER} ${FAMILY} ${METHOD} ${THRESH_SEQ}

echo "Done!"