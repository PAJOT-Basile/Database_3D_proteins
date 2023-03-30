#! /bin/sh

# If run before, we clean
rm *.csv

LIST_ORDERS="Archaea Bacteria Eukaryota"

for ORDER in $LIST_ORDERS; do

    echo $ORDER
    # Getting the number of families per Super-Kingdoms
    ls "../${ORDER}/" | wc -l >> Number_families.txt
    echo "${ORDER}" >> Names_families.txt
    cat ../${ORDER}/* | grep -c ">" >> Number_sequences.txt

    grep -c "^>" ../${ORDER}/* | cut -d":" -f1 | cut -d"#" -f2 > ${ORDER}_names_of_families.txt
    grep -c "^>" ../${ORDER}/* | cut -d":" -f2 > ${ORDER}_number_sequences_per_family.txt

    paste  ${ORDER}_names_of_families.txt ${ORDER}_number_sequences_per_family.txt | sed "s/\t/; /g" > ${ORDER}_number_of_sequences_per_family.csv

    sed -i $"1s/^/Family_name; Number_of_sequences\n/" ${ORDER}_number_of_sequences_per_family.csv

done

paste Names_families.txt Number_families.txt Number_sequences.txt| sed "s/\t/; /g" > Number_of_families_per_superkingdom.csv
sed -i $"1s/^/Super_kingdom; Number_of_families; Number_of_sequences\n/" Number_of_families_per_superkingdom.csv

rm *.txt