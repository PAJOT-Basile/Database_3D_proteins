#! /bin/sh

# This script takes into account the path to the database
DATA_PATH=$1

# It makes a list of the Super-Kingdoms in the database and iterates over them.
list_orders=$(ls $DATA_PATH)
for order in $list_orders; do
    echo $order
    # In each directory, we make a list of the order families and copy each name with the Super-Kingdom in the text file
    list_families=$(ls $DATA_PATH/$order*/)
    for family in $list_families; do
        echo "$order/$family" >> List_gene_families.xtxt
    done
done
