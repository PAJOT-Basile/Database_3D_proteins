#! /bin/sh

# We save the default IFS here for this script given we will modify it
DEFAULT_IFS=$IFS

# If run before, we clean up the working environment to not mix everything up
rm -R Archaea Bacteria Eukaryota

# This script takes into account the path to the folder to filter and the minimal number of sequences per gene family to keep
DATA_PATH=$1
LIMIT_NUMBER_SEQUENCES=$(( $2 - 1 ))
# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"

# Create a progress bar function to show how we advance in the progress as it is a long process
function ProgressBar {
    # The first variable is the total number of files to iterate over
    total_files=${2}
    # The first variable calculates the percentage of advancement of the process taking into account the beginning and the end of the 
    # process to follow
    let _progress=(${1}*100/$((total_files-1))*100)/100
    # The second variable transforms the advancement of the progress into a number between 1 and 40 to represent it using "#" in the 
    # progress bar
    let _done=(${_progress}*10)/10
    # The _left variable takes the complementary number to 40 to be able to fill the empty spots with "-" when the progress bar is loaded
    let _left=100-$_done
    # The "_fill" and "_empty" variables are used to get the number of times we will print each character
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

    # Once all of this is done, we print the progress bar
    printf "\rProgress : |${_fill// /█}${_empty// / }| ${_progress}%%; doing file number ${1}/$((total_files-1))."

}

# We iterate over each Super-Kingdoms to test the number of sequences. If there are enough, we copy the gene family file from the previous 
# folder to this one
cat $LIST_ORDERS | while read ORDER; do

    printf "\n$ORDER\n"
    # We create a folder for each Super-Kingdom
    mkdir $ORDER

    # We consider the previously created csv file contining the number of sequences per gene family to filter. We iterate over the lines 
    # and test each one
    FILE_TO_FILTER="${DATA_PATH}Stats/${ORDER}_number_of_sequences_per_family.csv"
    
    # The two following variables are used to define and use the progress bar
    data_length=$(cat $FILE_TO_FILTER | wc -l)
    counter=1

    cat $FILE_TO_FILTER | while read LINE; do 
        
        # We implement the progress bar to the code
        ProgressBar ${counter} ${data_length}

        # If the line starts with "Family_name", it is the header, so we continue
        if [[ $LINE = "Family_name"* ]]; then
            continue
        # Otherwise, we set the IFS to ";" (csv file) and make each line an array to extract only the part with the sequence number
        else
            IFS=";"
            read -a readline <<< "$LINE"
            FAM_NAME="${readline[0]}"
            NUM_SEQ="${readline[1]}"

            # If the line number is greater than the selected number, we copy the corresponding file.
            if [[ $(($NUM_SEQ)) -gt $LIMIT_NUMBER_SEQUENCES ]]; then
                cp ${DATA_PATH}${ORDER}/\#${FAM_NAME}\#sequences_filtered.fasta ./${ORDER}
            else
                continue
            fi
        fi
    done
    ((counter+=1))
done

# We reset the default IFS
IFS=$DEFAULT_IFS

# Start the new stats scripts to see the number of sequences after filtering
bash ../03-Filtering_gene_families_per_kingdom/Stats/Stats.sh "After"