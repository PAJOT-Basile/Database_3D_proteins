#! /bin/sh

# This script takes the csv files in the parallel folder and creates a fasta file with the data.

# Variable importation. It takes the path of the parallel folder.
FOLDER=$1

# We will iterate over the files in the parallel folder to isolate the csv files containing the filtered data.
for FILE in $(ls $FOLDER | grep '.csv'); do
	
	# First, we have to create a path to the file from the parallel folder to be accessed later. We also extract the order from the name of the file.
	PATH_FILE="${FOLDER}${FILE}"
	ORDER=$(echo "${FILE}" | cut -d'_' -f2)
	echo "${ORDER}"
	
	# Then, we will iterate over the information in the file to place it in several temporary files (1 per information per order).
	# Therefore, this loop creates 4 files per order.
	for INFO in ID Classification Sequence Folding_data; do
		if [[ "${INFO}" = "ID" ]]; then
			cut -d';' -f1 ${PATH_FILE} > ${ORDER}_${INFO}.csv
	
		elif [[ "${INFO}" = "Classification" ]]; then
			cut -d';' -f2 ${PATH_FILE} > ${ORDER}_${INFO}.csv
	
		elif [[ "${INFO}" = "Sequence" ]]; then
			cut -d';' -f3 ${PATH_FILE} > ${ORDER}_${INFO}.csv
	
		elif [[ "${INFO}" = "Folding_data" ]]; then
			cut -d';' -f4 ${PATH_FILE} > ${ORDER}_${INFO}.csv
		
		fi
	done
	
	# Once the temporary files are created, we firt paste the files containing the ID, classification and folding data together and replace
	# the spaces in between each information by some semi-colons to be able to extract them more easily if needed. We then add a ">" at 
	# the beginning of the line to separate the information from one sequence and the next. We store this in another temporary file.
	paste ${ORDER}_ID.csv ${ORDER}_Classification.csv ${ORDER}_Folding_data.csv | sed 's/\t/;/g' | sed 's/^/>/g' > ${ORDER}_temporary.txt
	# Finally, we paste the sequence to the file before and replace the spaces with a new line to separate the sequence from the information.
	# We then take out the 2 first lines to remove the header of the csv files and only keep the sequences. We store the end product in a fasta file.
	paste ${ORDER}_temporary.txt ${ORDER}_S* | sed 's/\t/\n/g' | tail -n+3 > ${ORDER}_sequences.fasta
done

# Removing the construction files to only keep the fasta files from each order.
rm *.csv *.txt
