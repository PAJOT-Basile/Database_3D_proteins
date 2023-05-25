#! /bin/sh

# If the script was run before, we remove the output to prevent having several times the same information 
rm *csv

# Create a progress bar function to show how we advance in the progress as it is a long process
function ProgressBar {
    # The first variable is the total number of files to iterate over
    total_files=${2}
    # The second variable calculates the percentage of advancement of the process taking into account the beginning and the end of the 
    # process to follow
    let _progress=(${1}*100/$total_files*100)/100
    # The third variable transforms the advancement of the progress into a number between 1 and 100 to represent it using "#" in the progress 
    # bar
    let _done=(${_progress}*10)/10
    # The _left variable takes the complementary number to 100 to be able to fill the empty spots with "-" when the progress bar is loaded
    let _left=100-$_done
    # The "_fill" and "_empty" variables are used to get the number of times we will print each character
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    

    # Once all of this is done, we print the progress bar
    printf "\rExtracting : |${_fill// /█}${_empty// / }| ${_progress}%%; doing file number ${1}/$total_files"

}

# This file contains the list of all the Super-Kingdoms to analyse here
LIST_ORDERS="../01-AcnucFamilies/List_superkingdoms.txt"

# We iterate over the Super-Kingdoms
cat $LIST_ORDERS | while read ORDER; do
    printf "\n${ORDER}\n"

    # These variables are used to define and follow the progress of the progress bar.
    data_length=$(wc -l ${ORDER}_seqfile.dat | cut -d" " -f1)
    counter=1

    # We create a header for the csv file containing the pdb informations from the genbank folders
    echo "Gene_family;Sequence_id;PDB;Resolution" >> ${ORDER}_pdbs.csv

    # We iterate over each line of the corresponding `.dat` file
    cat ${ORDER}_seqfile.dat | while read LINE; do
        # We implement a progress bar to the code to follow the progress
        ProgressBar ${counter} ${data_length}

        # If the line starts with "ID", then it means it is where the sequence id is stored
        if [[ "${LINE}" = "ID "* ]]; then
            ID=$(echo ${LINE} | cut -d" " -f2)
        
        # If the line starts with "CC   -!- G", this line contains the gene family code of this protein
        elif [[ "${LINE}" = "CC   -!- G"* ]]; then
            FAMILY=$(echo "${LINE}" | cut -d":" -f2 | sed "s/ //g" | sed "s/\.//g")
        
        # If the line starts with "DR   PDB;", then it contains the PDB reference and the resolution of the measurement
        elif [[ "${LINE}" = "DR   PDB;"* ]]; then
            PDB=$(echo ${LINE} | cut -d";" -f2 | sed "s/ //g")
            RESOLUTION=$(echo ${LINE} | cut -d";" -f4 | sed "s/ //g" | sed "s/A//g")
            # Once we strored every information in a variable, we print them out in the csv file
            echo "${FAMILY};${ID};${PDB};${RESOLUTION}" >> ${ORDER}_pdbs.csv
        fi
        ((counter+=1))
    done

done