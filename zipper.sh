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


# We iterate over the Super-Kingdoms in the database
for ORDER in $(ls ${DATA_PATH}); do

    printf "\n${ORDER}\n"

    # The two following variables are used to define and use the progress bar
    data_length=$(ls ${DATA_PATH}${ORDER} | wc -l)
    counter=1
    # We differenciate the codes to use. If it is 08, it means we will run the step 08, so we need the files from folders
    # 03-Better_quality and 04-Similar_sequences_removed to be copied to the database
    if [[ "${CODE}" = "08"* ]]; then
        # We create the database and the Super-Kingdom folders.
        mkdir -p Database${CODE}/${ORDER}

        # We iterate over the gene families in every Super-Kingdom
        for FAMILY in $(ls ${DATA_PATH}${ORDER}); do

            # We implement the ProgressBar to follow progress
            ProgressBar ${counter} ${data_length}
            if [[ ${FAMILY} = "Example" ]]; then
                ((counter+=1))
                continue
            fi
            
            # We differenciate the going to the cluster from the copying from the cluster parts
            if [[ "${CODE}" = "08" ]]; then
                # If the considered gene family has a 03-Better_quality folder, we copy this folder and the 04-Similar_sequences_removed folder to the
                # new database
                if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/03-Better_quality" ]; then

                    # We make the gene family folder in the copy of the database
                    mkdir Database${CODE}/${ORDER}/${FAMILY}

                    # We copy the files from the wanted folders
                    cp -r ${DATA_PATH}${ORDER}/${FAMILY}/03-Better_quality/ Database${CODE}/${ORDER}/${FAMILY}/
                    cp -r ${DATA_PATH}${ORDER}/${FAMILY}/04-Similar_sequences_removed/ Database${CODE}/${ORDER}/${FAMILY}/

                fi
            else
                if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/04-Similar_sequences_removed" ]; then

                    # We make the gene family folder in the copy of the database
                    mkdir Database${CODE}/${ORDER}/${FAMILY}

                    # We copy the files from the wanted folders
                    cp -r ${DATA_PATH}${ORDER}/${FAMILY}/04-Similar_sequences_removed/ Database${CODE}/${ORDER}/${FAMILY}/

                fi

            fi
        ((counter+=1))
        done

    # We do the same thing for the other codes copying the appropriate files to run the analyses on the cluster
    # In step 10, we just need the files from folder 05-Optimised_alignment
    elif [[ "${CODE}" = "10"* ]]; then
        mkdir -p Database${CODE}/${ORDER}
        for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
            ProgressBar ${counter} ${data_length}
            if [[ ${FAMILY} = "Example" ]]; then
                ((counter+=1))
                continue
            fi
            if [[ "${CODE}" = "10" ]]; then
                if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/05-Optimised_alignment" ]; then
                    mkdir Database${CODE}/${ORDER}/${FAMILY}
                    cp -r ${DATA_PATH}${ORDER}/${FAMILY}/05-Optimised_alignment/ Database${CODE}/${ORDER}/${FAMILY}/
                fi
            else
                if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/06-"* ]; then
                    mkdir Database${CODE}/${ORDER}/${FAMILY}
                    cp -r ${DATA_PATH}${ORDER}/${FAMILY}/06-* Database${CODE}/${ORDER}/${FAMILY}/
                fi
            fi
            ((counter+=1))
        done

    echo $CODE
    # In step 13, we just need the files from folder 08-Phylip_file
    elif [[ "${CODE}" = "13"* ]]; then
        mkdir -p Database${CODE}/${ORDER}
        for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
            ProgressBar ${counter} ${data_length}
            if [[ ${FAMILY} = "Example" ]]; then
                ((counter+=1))
                continue
            fi
            if [[ "${CODE}" = "13" ]]; then
                if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/08-Phylip_file" ]; then
                    mkdir Database${CODE}/${ORDER}/${FAMILY}
                    cp -r ${DATA_PATH}${ORDER}/${FAMILY}/08-Phylip_file/ Database${CODE}/${ORDER}/${FAMILY}/
                fi
            else
                if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/09-PhyML_tree"* ]; then
                    mkdir Database${CODE}/${ORDER}/${FAMILY}
                    cp -r ${DATA_PATH}${ORDER}/${FAMILY}/09-PhyML_tree/ Database${CODE}/${ORDER}/${FAMILY}/
                fi
            fi
            ((counter+=1))
        done
    
    # In step 15, we need the files from folder 07-Consensus folder and from folder 10-Tree_without_bootstrap
    elif [[ "${CODE}" = "15"* ]]; then
        mkdir -p Database${CODE}/${ORDER}
        for FAMILY in $(ls ${DATA_PATH}${ORDER}); do
            ProgressBar ${counter} ${data_length}
            if [[ ${FAMILY} = "Example" ]]; then
                ((counter+=1))
                continue
            fi
            if [[ "${CODE}" = "15" ]]; then
                if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/10-Tree_without_bootstrap" ]; then
                    mkdir Database${CODE}/${ORDER}/${FAMILY}
                    cp -r ${DATA_PATH}${ORDER}/${FAMILY}/10-Tree_without_bootstrap/ Database${CODE}/${ORDER}/${FAMILY}/
                    cp -r ${DATA_PATH}${ORDER}/${FAMILY}/07-Consensus/ Database${CODE}/${ORDER}/${FAMILY}/
                fi
            else
                if [ -d "${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs"* ]; then
                    mkdir Database${CODE}/${ORDER}/${FAMILY}
                    cp -r ${DATA_PATH}${ORDER}/${FAMILY}/11-Raser_outputs/ Database${CODE}/${ORDER}/${FAMILY}/
                fi
            fi
            ((counter+=1))
        done
    fi
done

printf "\nDone\n"