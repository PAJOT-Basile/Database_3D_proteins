#! /bin/sh

# If run before, clean up
rm *.csv

FILE=$1
extracting="no"
first_line_seq="yes"

cat $FILE | while read line; do

	if [[ $line = ">"* ]]; then
		echo $line | sed "s/^>//g" | sed "s/$/;/g" >> sequence_names.txt
		first_line_seq="yes"
	elif [[ $line != ">"* ]] && [[ $first_line_seq = "y"* ]]; then
		echo $line | tr "\n" " " | sed "s/^/\n/g" >> sequences.txt
		first_line_seq="no"
	elif [[ $line != ">"* ]] && [[ $first_line_seq = "n"* ]]; then
		echo $line | tr "\n" " " >> sequences.txt
	fi

done

echo "$(tail -n+2 sequences.txt)" > sequences.txt
sed "s/ //g" sequences.txt > sequences1.txt

cat sequences1.txt | while read line; do
	echo ";${#line}" >> number_AA.txt
done

paste sequence_names.txt sequences1.txt number_AA.txt| sed "s/ //g" | sed "s/\t//g" > family.csv

sed -i $"1s/^/Sequence_name;Sequence;Length\n/" family.csv

rm *.txt

python3 ./verif.py family.csv