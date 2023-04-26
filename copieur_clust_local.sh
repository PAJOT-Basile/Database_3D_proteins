#! /bin/sh

DATA_PATH=$1

LIST_ORDERS="01-AcnucFamilies/List_supekingdoms.txt"

cat $LIST_ORDERS | while read order; do

    echo $order
    list_fam=$(ls "Database${order}03")
    for fam in $list_fam; do

        cp Database${order}03/${fam}/04-Similar_sequences_removed/* Database/${order}/${fam}/04-Similar_sequences_removed


    done
done