#! /bin/sh

# If run before, we clean up the working environment to not mix everything up.
rm *.csv

# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders.
LIST_ORDERS="../../1-AcnucFamilies/List_superkingdoms.txt"

# We iterate over each order to extract several informations from the considered folder in the parent folder.
# Each extracted variable is stored in a text file before being pasted.
cat $LIST_ORDERS | while read ORDER; do

    echo $ORDER
    # Get the number of families per Super-Kingdoms.
    ls "../${ORDER}/" | wc -l >> Number_families.txt
    # Take the name of the considered Super-Kingdom to add it to a file.
    echo "${ORDER}" >> Names_families.txt
    # Count the number of sequences per Super-Kingdom.
    cat ../${ORDER}/* | grep -c ">" >> Number_sequences.txt

    # Frist extract all the names of the gene families.
    grep -c "^>" ../${ORDER}/* | cut -d":" -f1 | cut -d"#" -f2 > ${ORDER}_names_of_families.txt
    # Then extract the number of sequences in each gene family file.
    grep -c "^>" ../${ORDER}/* | cut -d":" -f2 > ${ORDER}_number_sequences_per_family.txt

    # Paste the names of each gene family with the number of sequences in the corresponding gene fqmily.
    paste  ${ORDER}_names_of_families.txt ${ORDER}_number_sequences_per_family.txt | sed "s/\t/; /g" > ${ORDER}_number_of_sequences_per_family.csv

    # Add a header to the text file and save the result in a csv file.
    sed -i $"1s/^/Family_name; Number_of_sequences\n/" ${ORDER}_number_of_sequences_per_family.csv

done

# Paste the files containing the general informations on the Super-Kingdoms and transforming it into a csv file after adding a header.
paste Names_families.txt Number_families.txt Number_sequences.txt| sed "s/\t/; /g" > Number_of_families_per_superkingdom.csv
sed -i $"1s/^/Super_kingdom; Number_of_families; Number_of_sequences\n/" Number_of_families_per_superkingdom.csv

# Clean up after using the text files to store temporary variables.
rm *.txt

# Run the R script to create graphs.
Rscript ./Stats.R