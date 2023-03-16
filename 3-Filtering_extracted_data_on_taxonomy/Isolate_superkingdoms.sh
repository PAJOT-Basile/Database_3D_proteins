#! /bin/sh

# This script is used to filter the data extracted from the ACNUC database. Once the ID, classification, sequence and folding data 
# were extracted from the source files, we have to filter the newly-created files. Indeed, in each file of the parallel folder, 
# we find that the classification does not correspond to the file name. We find sequences from Eukaryota, Archaea, Bacteria and other 
# superkingdoms in each file. Therefore, this script is made to separate the sequences by superkingdom and filter if there are any 
# duplicates in the extracted sequences.

# Variable importation. It takes the path of the parallel folder.
FOLDER=$1

# Listing the orders to take into account.
ORDERS="Bacteria Eukaryota Archaea Rest"

# For each csv file in the parallel folder, we will iterate over the orders and extract the sequences of said orders into a temporary file.
for FILE in $(ls $FOLDER | grep '.csv'); do
	
	# First, we have to create a path to the file from the parallel folder to be accessed later. We also extract the order from the name of the file.
	PATH_TO_FILE="${FOLDER}${FILE}"
	ORDER=$(echo "${FILE}" | cut -d'_' -f2)
	echo "Extracting from ${ORDER}:"
	
	# For each order name, we will extract the sequences from said name and put it in a temporary file.
	for NAME in ${ORDERS}; do
	
		echo "    • ${NAME}"
		
		# Here, we compare the order name to this string to extract all the rest of the sequences (not Bacteria nor Eukaryota nor Archaea)
		# And add it to a temporary file.
		if [[ "${NAME}" = "Rest" ]]; then 
			grep -Ev 'Bacteria|Eukaryota|Archaea' ${PATH_TO_FILE} > Rest_from_Families_${ORDER}_Sequences_Extracted.csv
		# Otherwise, we extract the sequences from said order and store it in a temporary file.
		else
			grep "${NAME}" ${PATH_TO_FILE} > ${NAME}_from_Families_${ORDER}_Sequences_Extracted.csv
		fi
	done
done
# This loop creates 4 files per iteration (one for each order in ORDERS) per file in the parallel folder.

# Once the temporary files are created, we iterate over the order names to concatenate all the temporary files containing the sequences of said
# order. Then, we sort them alphabetically and take out the duplicates.
for ORDER in ${ORDERS}; do
	echo "Concatenating ${ORDER}"
	
	# We test the order name agains this string to sort out the sequences that are not Bacteria nor Eukaryota nor Archaea because this file
	# contains the headers of all the files in the parallel folder. Therefore, we need to take these lines out specifically in this case.
	if [[ "${ORDER}" = "Rest" ]]; then
		
		# First, we concatenate all the files that start with Rest.
		cat ${ORDER}_* > ${ORDER}_1
		# Then, we take out the headers of the files in the parallel folder.
		grep -v "^ID" ${ORDER}_1* > ${ORDER}_2
		echo "Filtering duplicates in ${ORDER}"
		# Then, we check for duplicates.
		sort ${ORDER}_1 | uniq > Only_${ORDER}_Extracted_Sequences.csv
		# Finally, we add a header to the newly created csv file containing all the seqeunces that are not Bacteria nor Eukaryota nor Archaea.
		sed -i $"1s/^/ID;Classification;Sequence;Folding data\n/" Only_${ORDER}_Extracted_Sequences.csv
	
	# In the other case, the process is the same, but without taking out the headers given they are not here.
	else
		# First, we concatenate all the files starting with the order name.
		cat ${ORDER}_* > ${ORDER}_1
		echo "Filtering duplicates in ${ORDER}"
		# Then, we check for duplicate sequences
		sort ${ORDER}_1 | uniq > Only_${ORDER}_Extracted_Sequences.csv
		# Finally we add a header to the file
		sed -i $"1s/^/ID;Classification;Sequence;Folding data\n/" Only_${ORDER}_Extracted_Sequences.csv
	fi
	echo "Done for ${ORDER}"
done

# Removing the construction files to only keep the csv files containing the extracted sequences from each order
rm Bacteria* Eukaryota* Archaea* Rest*
