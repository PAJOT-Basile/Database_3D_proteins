#! /bin/sh

# We take into account the path to the folder containing the file to transform from fasta to csv and the name of the fasta file
DATA_PATH=$1
ORDER=$2
FAMILY_NAME=$3
FILE_TO_DO=$4
METHOD=$5

PATH_FILE=$(echo "$DATA_PATH$ORDER/$FAMILY_NAME/$FILE_TO_DO/$FAMILY_NAME")

# We also define two local variable that will be used in the transformation
first_line_seq="yes"

# We iterate over the lines of the file and add each line differently to a text file
if [[ "$METHOD" = "PRANK" ]]; then
	cat $PATH_FILE.fasta.best.fas | while read line; do

		# If the line starts with ">", we have a new sequence ID so, we extract it and add it to the file containing all the sequence IDs
		# We also change the local variable "first_line_seq" to "yes" to sqy that we extracted the sequence ID, so the next line to extract
		# is the first line of a sequence. Therefore, it will have special treatment
		if [[ $line = ">"* ]]; then
			echo $line | sed "s/^>//g" | sed "s/$/;/g" >> ${ORDER}_${FAMILY_NAME}_sequence_names.txt
			first_line_seq="yes"
		# If it is the first line of the sequence, we extract it and add a back to the line. If we do not do this, all the sequences will
		# be added in one line, thus losing all the sequences
		# Once the first line is extracted, we set the local varible "first_line_seq" to "no" meaning that we are no longer extracting the first 
		# line of the sequence
		elif [[ $line != ">"* ]] && [[ $first_line_seq = "y"* ]]; then
			echo $line | tr "\n" " " | sed "s/^/\n/g" >> ${ORDER}_${FAMILY_NAME}_sequences.txt
			first_line_seq="no"
		# If the line we are extracting is not the first line of a sequence, then we simply extract it and change the back to the line into.
		# a space to paste all the bits of sequences into one line
		elif [[ $line != ">"* ]] && [[ $first_line_seq = "n"* ]]; then
			echo $line | tr "\n" " " >> ${ORDER}_${FAMILY_NAME}_sequences.txt
		fi

	done
else
cat $PATH_FILE.fasta | while read line; do

		# If the line starts with ">", we have a new sequence ID so, we extract it and add it to the file containing all the sequence IDs
		# We also change the local variable "first_line_seq" to "yes" to sqy that we extracted the sequence ID, so the next line to extract
		# is the first line of a sequence. Therefore, it will have special treatment
		if [[ $line = ">"* ]]; then
			echo $line | sed "s/^>//g" | sed "s/$/;/g" >> ${ORDER}_${FAMILY_NAME}_sequence_names.txt
			first_line_seq="yes"
		# If it is the first line of the sequence, we extract it and add a back to the line. If we do not do this, all the sequences will
		# be added in one line, thus losing all the sequences
		# Once the first line is extracted, we set the local varible "first_line_seq" to "no" meaning that we are no longer extracting the first 
		# line of the sequence
		elif [[ $line != ">"* ]] && [[ $first_line_seq = "y"* ]]; then
			echo $line | tr "\n" " " | sed "s/^/\n/g" >> ${ORDER}_${FAMILY_NAME}_sequences.txt
			first_line_seq="no"
		# If the line we are extracting is not the first line of a sequence, then we simply extract it and change the back to the line into.
		# a space to paste all the bits of sequences into one line
		elif [[ $line != ">"* ]] && [[ $first_line_seq = "n"* ]]; then
			echo $line | tr "\n" " " >> ${ORDER}_${FAMILY_NAME}_sequences.txt
		fi

	done
fi

# We take out the first line of the file given with the method used earlier, we added a back to the line at the beginning of every 
# first sequence line. Therefore, the first line of the file is an empty line
echo "$(tail -n+2 ${ORDER}_${FAMILY_NAME}_sequences.txt | sed 's/ //g')" > ${ORDER}_${FAMILY_NAME}_sequences.txt

# We add the length of the sequence in a new file
cat ${ORDER}_${FAMILY_NAME}_sequences.txt | while read line; do
	echo ";${#line}" >> ${ORDER}_${FAMILY_NAME}_number_AA.txt
done

# We paste the different text files containing the different informations (sequence ID, the sequences and the lengths of the sequences)
paste ${ORDER}_${FAMILY_NAME}_sequence_names.txt ${ORDER}_${FAMILY_NAME}_sequences.txt ${ORDER}_${FAMILY_NAME}_number_AA.txt| sed "s/ //g" | sed "s/\t//g" | sort > $PATH_FILE.csv

# We add a first header to the created csv file
sed -i $"1s/^/Sequence_name;Sequence;Length\n/" $PATH_FILE.csv

# We clean up the temporaraly used text files
rm ${ORDER}_${FAMILY_NAME}*.txt