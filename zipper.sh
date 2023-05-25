#! /bin/sh

DATA_PATH=$1

LIST_ORDERS="01-AcnucFamilies/List_superkingdoms.txt"

# Create a progress bar function to show how we advance in the progress as it is a long process
function ProgressBar {
    # The first variable is the total number of files to iterate over
    total_files=${2}
    # The second variable calculates the percentage of advancement of the process taking into account the beginning and the end of the process to follow
    let _progress=(${1}*100/$((total_files))*100)/100
    # The third variable transforms the advancement of the progress into a number between 1 and 40 to represent it using "#" in the progress bar
    let _done=(${_progress}*10)/10
    # The _left variable takes the complementary number to 40 to be able to fill the empty spots with "-" when the progress bar is loaded.
    let _left=100-$_done
    # The "_fill" and "_empty" variables are used to get the number of times we will print each character
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    

    # Once all of this is done, we print the progress bar
    printf "\rCopying : |${_fill// /█}${_empty// / }| ${_progress}%%; doing file number ${1}/$((total_files))"

}


cat $LIST_ORDERS | while read order; do

    printf "\n$order\n"
    list_fam=$(ls $DATA_PATH$order)
    # The two following variables are used to define and use the progress bar
    data_length=$(ls $DATA_PATH$order | wc -l)
    counter=1
    mkdir Database${order}10/

    for fam in $list_fam; do

        ProgressBar ${counter} ${data_length}
        if [[ $fam = "Example" ]]; then
            ((counter+=1))
            continue
        fi
        
        if [ -d "$DATA_PATH$order/$fam/10-Tree_without_bootstrap" ]; then

            mkdir -p Database${order}10/$fam/10-Tree_without_bootstrap/
            mkdir -p Database${order}10/$fam/07-Consensus/

            cp $DATA_PATH${order}/${fam}/10-Tree_without_bootstrap/* Database${order}10/$fam/10-Tree_without_bootstrap/
            cp $DATA_PATH${order}/${fam}/07-Consensus/* Database${order}10/$fam/07-Consensus/

        fi
        ((counter+=1))
    done
done

printf "\nDone\n"