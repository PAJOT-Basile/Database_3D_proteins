#! /bin/sh

# We clean up everything if it has been run before
rm -r ../0-tests/Database/*/*/2-* ./Alignment_speeds.csv

# We take into account the path to the parallel folder that contains the files to organise in the database
DATA_PATH=$1
# We take into account the method we want to use to make one script able to all the wanted alignments
METHOD=$(echo $2 | tr '[:lower:]' '[:upper:]')

# We create a progress bar function to show how we advance in the progress as it is a long process
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
    printf "\rAligning : [${_fill// /#}${_empty// / }] ${_progress}%%; doing file number ${1}/$((total_files-1))."

}

# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"
cat ${LIST_ORDERS} | while read ORDER; do
    
    printf "\n$ORDER"

    # We make a list of the gene families we are going to be iterating over 
    LIST_FAMILIES=$(ls ${DATA_PATH}${ORDER}/)

    # The two following variables are used to define and use the progress bar
    data_length=$(wc -l $LIST_FAMILIES)
    counter=1

    # We iterate over each gene family folder in the database
    for FAMILY in ${LIST_FAMILIES}; do

        # We implement the progress bar to the code
        ProgressBar ${counter} ${data_length}

        # We create a directory where the aligned sequences will be stored
        mkdir ${DATA_PATH}${ORDER}/${FAMILY}/2-Rough_alignment

        # We create a csv file containing all the parameters of the alignment. The number of sequences, the sequence lengths, the time it took to
        # align all these sequences and the sequence length after the alignment. If the following csv file exists, we continue. Otherwise,
        # we create it and add a header
        if test -f "./Alignment_speeds.csv"; then
            continue
        else
            echo "Number_sequences;Minimum_seq_length;Maximum_seq_length;Mean_seq_length;Time;Method;Seq_length_after_alignment" >> ./Alignment_speeds.csv
        fi

        # Here, we select the alignment method asked in the command line. Each time, we measure the time before and after the alignment to calculate the
        # time it took to align the sequences. We also wait for each alignment process to finish before we keep on going

        # Mafft
        if [[ $METHOD = "MAFFT" ]]; then
            # We store the date in a varible to count the elapsed time for the alignment process
            time_before=$(date "+%d%H%M%S")
            # We start the alignment on the appropriate fasta file using the right method in the database and add the output to the newly created folder
            # We wait for the alignment process to be done before carrying on.
            mafft ${DATA_PATH}${ORDER}/${FAMILY}/1-Raw_data/${FAMILY}.fasta > ${DATA_PATH}${ORDER}/${FAMILY}/2-Rough_alignment/${FAMILY}_aligned.fasta
            wait
            # We measure the time after the process to know how long it took to align the data
            time_ater=$(date "+%d%H%M%S")
        
        # Muscle
        elif [[ $METHOD = "MUSCLE" ]]; then
            time_before=$(date "+%d%H%M%S")
            muscle -in ${DATA_PATH}${ORDER}/${FAMILY}/1-Raw_data/${FAMILY}.fasta -out ${DATA_PATH}${ORDER}/${FAMILY}/2-Rough_alignment/${FAMILY}_aligned.fasta
            wait
            time_ater=$(date "+%d%H%M%S")

        # Clustal Omega
        elif [[ $METHOD = "CLUSTAL_OMEGA" ]]; then
            time_before=$(date "+%d%H%M%S")
            clustalo --in=${DATA_PATH}${ORDER}/${FAMILY}/1-Raw_data/${FAMILY}.fasta --out=${DATA_PATH}${ORDER}/${FAMILY}/2-Rough_alignment/${FAMILY}_aligned.fasta
            wait
            time_ater=$(date "+%d%H%M%S")

        # ClustalW
        elif [[ $METHOD = "CLUSTALW" ]]; then
            time_before=$(date "+%d%H%M%S")
            clustalw -INFILE=${DATA_PATH}${ORDER}/${FAMILY}/1-Raw_data/${FAMILY}.fasta -OUTFILE=${DATA_PATH}${ORDER}/${FAMILY}/2-Rough_alignment/${FAMILY}_aligned.fasta -OUTPUT=FASTA
            wait
            time_ater=$(date "+%d%H%M%S")

        # Prank
        elif [[ $METHOD = "PRANK" ]]; then
            time_before=$(date "+%d%H%M%S")
            prank -d=${DATA_PATH}${ORDER}/${FAMILY}/1-Raw_data/${FAMILY}.fasta -o=${DATA_PATH}${ORDER}/${FAMILY}/2-Rough_alignment/${FAMILY}_aligned.fasta
            wait
            time_ater=$(date "+%d%H%M%S")

        # T-coffee
        elif [[ $METHOD = "T_COFFEE" ]]; then
            time_before=$(date "+%d%H%M%S")
            t_coffee -in=${DATA_PATH}${ORDER}/${FAMILY}/1-Raw_data/${FAMILY}.fasta -output=${DATA_PATH}${ORDER}/${FAMILY}/2-Rough_alignment/${FAMILY}_aligned.fasta
            wait
            time_ater=$(date "+%d%H%M%S")
        else
            printf "Method $METHOD is not known. Please choose one of the following: MAFFT, MUSCLE, CLUSTAL_OMEGA, CLUSTALW, PRANK, T_COFFEE"
            break 2
        fi

        # We measure the time difference between the beginning and the end of the alignment process
        time_difference=$(( time_after - time_before ))
        
        # We run the "timer.py" python script that will analyse the time difference and complete the csv file created earlier 
        python3 timer.py ${DATA_PATH}${ORDER}/${FAMILY}/ $time_difference $METHOD
        
    done
done