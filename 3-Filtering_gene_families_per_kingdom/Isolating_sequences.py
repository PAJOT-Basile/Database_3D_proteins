# Libraries
import os as os
from pathlib import Path
import sys as sys

# Taking into account all the variables that have been passed on by the launcher.
order = sys.argv[1].strip("/")
data_path = sys.argv[2]
file_name_to_test = sys.argv[3]


# Create an extractor class that will be used to extract all the needed sequences and create new files with the extracted data.
class Extractor:

    # Initialise method. It will be used to re-initialise the extractor once the sequence is done being extracted.
    def init(self):
        self.extracting = False
    
    # The "check_seqeunce" method checks if the read sequence ID is in the ".mne" file for each Super-Kingdom. 
    def check_sequence(self, reference_sequence, sequence_from_family_file):
        # If the line in the ".mne" file corresponds to a line in the gene-family file, it returns True and False otherwise.
        if "".join([">", reference_sequence]) == sequence_from_family_file.replace(".", "_"):
            return(True)
        else:
            return(False)

    # The "extract_sequence_name" method extracts the sequence ID from the gene-family file.
    def extract_sequence_name(self, sequence_name, directory, family_name):
        # We create a new file with the gene-family name in the appropriate Super-Kingdom folder and add the sequence ID.
        with open("#".join([os.path.join(directory, "".join(["#", family_name])), "sequences_filtered.fasta"]), "a") as f:
            f.write("".join([">", sequence_name]))
            f.close()
        # We set the extracting parameter to True to be able to keep extracting all the lines in the file for the matching sequences.
        self.extracting = True

    # The "extracting_sequence_line" method just opens the file of the family name and writes the sequence line to extract in the file.
    def extracting_sequence_line(self, sequence_line, directory, family_name):
        with open("#".join([os.path.join(directory, "".join(["#", family_name])), "sequences_filtered.fasta"]), "a") as f:
            f.write(sequence_line)
            f.close()


#Make the extractor object and initialise it.
extractor = Extractor()
extractor.init()

# Open the paths to the files. The first one is the file containing all the sequences for one family and the second
# one contains all the sequence IDs for a Super-Kingdom.
file_to_test = open(os.path.join(data_path, order, file_name_to_test), "r")
# Taking out the family name of the gene family we are treating here.
family_name = file_name_to_test.split("#")[1]

# This loop iterates over each line in the gene family file. It tests several parameters. Each new sequence strats with ">". Therefore, for each
# line like this we will test if the sequence ID matches one from the ".mne" file.
for line in file_to_test:

    # If the line starts with ">" and we are extracting, we have finished extracting one sequence and we are looking at a new one. We have to 
    # test if the we want to extract the sequence. If the test is positive, we keep going. If not, we re-initailise the extractor and keep moving
    # forward in the file.
    if line.startswith(">") and extractor.extracting:
        extractor.init()
    
    # If the line starts with ">", and we are not extracting, it means that we have a sequence ID to test. If the test is positive, we extract the
    # sequence name. If not, we continue.
    if line.startswith(">") and not extractor.extracting:
        reference_file = open("".join([os.path.join(data_path, order), "_sequences.mne"]), "r")
        for reference_line in reference_file:
            if extractor.check_sequence(reference_line, line):
                extractor.extract_sequence_name(reference_line, order, family_name)
        reference_file.close()
    
    # If the line does not start with ">" and we are extracting, we are in the middle of a sequence. Therefore, we extract the line.
    if not line.startswith(">") and extractor.extracting:
        extractor.extracting_sequence_line(line, order, family_name)
