#! /bin/sh

# We take as input the relative path to the database and the code to use
DATA_PATH=$1
CODE=$2

# Create a progress bar function to show how we advance in the progress as it is a long process
function ProgressBar {
    # The first variable is the total number of files to iterate over
    total_files=${2}
    # The second variable calculates the percentage of advancement of the process taking into account the beginning and the end of the process to follow
    let _progress=(${1}*100/$((total_files))*100)/100
    # The third variable transforms the advancement of the progress into a number between 1 and 40 to represent it using "#" in the progress bar
    let _done=(${_progress}*10)/10
    # The _left variable takes the complementary number to 40 to be able to fill the empty spots with "-" when the progress bar is loaded
    let _left=100-$_done
    # The "_fill" and "_empty" variables are used to get the number of times we will print each character
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    

    # Once all of this is done, we print the progress bar
    printf "\rCopying : |${_fill// /█}${_empty// / }| ${_progress}%%; doing file number ${1}/$((total_files))"

}

# We iterate over the Super-Kingdoms in the downloaded database
for ORDER in $(ls ${DATA_PATH}); do

    printf "\n${ORDER}\n"
    # The two following variables are used to define and use the progress bar
    data_length=$(ls ${DATA_PATH}${ORDER} | wc -l)
    counter=1

    # We iterate over the gene families in the Super-Kingdoms
    for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
        
        # We implement the ProgressBar to follow progress
        ProgressBar ${counter} ${data_length}

        # Create the gene family folder if it does not exist.
        if [[ ! -d "Database/${ORDER}/${FAMILY}/" ]]; then
            mkdir Database/${ORDER}/${FAMILY}/
        fi

        # Copy all the folders in the gene family folder to copy them to the database
        cp -ra ${DATA_PATH}${ORDER}/${FAMILY}/* Database/${ORDER}/${FAMILY}/
        ((counter+=1))
    done
done
printf "\nDone\n"