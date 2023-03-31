#! /bin/sh

# If run before, we clean
rm *.csv

LIST_ORDERS="../1-AcnucFamilies/List_superkingdoms.txt"
cat $LIST_ORDERS | while read ORDER; do

    echo $ORDER
    # Getting the number of families per Super-Kingdoms
    ls "../${ORDER}/" | wc -l >> Number_families.txt
    echo "${ORDER}" >> Names_families.txt
    cat ../${ORDER}/* | grep -c ">" >> Number_sequences.txt

done

paste Names_families.txt Number_families.txt Number_sequences.txt| sed "s/\t/; /g" > Stats/Number_of_families_per_superkingdom.csv
sed -i $"1s/^/Super_kingdom; Number_of_families; Number_of_sequences\n/" Stats/Number_of_families_per_superkingdom.csv

rm *.txt

Rscript Stats.R