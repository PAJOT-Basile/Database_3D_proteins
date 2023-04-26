#! /bin/sh

DATA_PATH=$1

LIST_ORDERS="01-AcnucFamilies/List_supekingdoms.txt"

cat $LIST_ORDERS | while read order; do

    echo $order
    list_fam=$(ls $DATA_PATH$order)
    for fam in $list_fam; do

        if [ -d "$DATA_PATH$order/$fam/04-Similar_sequences_removed" ]; then
            
            mkdir -p Database${order}03/$fam/03-Better_quality
            cp Database/${order}/${fam}/03-Better_quality/* Database${order}03/$fam/03-Better_quality

            mkdir Database${order}03/$fam/04-Similar_sequences_removed
            cp Database/${order}/${fam}/04-Similar_sequences_removed/* Database${order}03/$fam/04-Similar_sequences_removed
        fi
    done
done