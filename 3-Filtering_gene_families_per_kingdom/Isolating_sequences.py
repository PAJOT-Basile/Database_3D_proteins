# Libraries
import os as os
from pathlib import Path
import sys as sys

order = sys.argv[1]
data_path = sys.argv[2]
file_name_to_test = sys.argv[3]


class Extractor:

    def init(self):
        self.extracting = False
        self.extracting_family = None
    

    def check_sequence(self, reference_sequence, sequence_from_family_file):
        
        if "".join([">", reference_sequence]) == sequence_from_family_file.replace(".", "_"):
            return(True)
        else:
            return(False)


    def extract_sequence_name(self, sequence_name, directory, family_name):

        with open("#".join([os.path.join(directory, "".join(["#", family_name])), "sequences_filtered.fasta"]), "a") as f:
            f.write("".join([">", sequence_name]))
            f.close()
        
        self.extracting = True
        if self.extracting_family is None:
            self.extracting_family = [family_name]
        elif len(self.extract_sequence_name) > 0:
            self.extracting_family.append(family_name)


    def extracting_sequence_line(self, sequence_line, directory, family_name):
        for family_name in self.extracting_family:
            with open("#".join([os.path.join(directory, "".join(["#", family_name])), "sequences_filtered.fasta"]), "a") as f:
                f.write(sequence_line)
                f.close()



extractor = Extractor()
extractor.init()

file_to_test = open(os.path.join(data_path, order, file_name_to_test), "r")
reference_file = open("".join([os.path.join(data_path, order), "_sequences.mne"]), "r")
family_name = file_name_to_test.split("#")[1]

for line in file_to_test:

    if line.startswith(">") and extractor.extracting:
        for reference_line in reference_file:
            if extractor.check_sequence(reference_line, line):
                extractor.extract_sequence_name(reference_line, order, family_name)
            else:
                extractor.init()
    
    if line.startswith(">") and not extractor.extracting:
        for reference_line in reference_file:
            if extractor.check_sequence(reference_line, line):
                extractor.extract_sequence_name(reference_line, order, family_name)

    if not line.startswith(">") and extractor.extracting:
        extractor.extracting_sequence_line(line, order, family_name)
