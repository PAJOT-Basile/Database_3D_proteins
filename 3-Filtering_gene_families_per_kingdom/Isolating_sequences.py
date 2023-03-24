# Libraries
import os as os
from pathlib import Path
import shutil as shu

# Data path
directory_path = "../2-Extracting_families_per_kingdom"
list_reference_files = [file for file in os.listdir(directory_path) if file.endswith('.mne')]



class Extractor:

    def init(self):
        self.extracting = False
        self.extracting_family = None
    
    def check_sequence(self, reference_sequence, sequence_from_family_file):
        if "".join([">", sequence_from_family_file]) == reference_sequence:
            return(True)
        else:
            return(False)
    
    def extract_sequence_name(self, sequence_name, directory, family_name):
        if not Path(directory).is_dir():
            os.mkdir(directory)

        with open("_".join([os.path.join(directory, family_name), "sequences_filtered.fasta"])) as f:
            f.write(sequence_name)
            f.close()
            self.extracting = True
        
        if self.extracting_family is None:
            self.extracting_family = [family_name]
        elif len(self.extract_sequence_name) > 0:
            self.extracting_family.append(family_name)

    def extracting_sequence_line(self, sequence_line, directory):
        for family_name in self.extracting_family:
            with open("_".join([os.path.join(directory, family_name), "sequences_filtered.fasta"])) as f:
                f.write(sequence_line)
                f.close()



extractor = Extractor()
extractor.init()


# Final loop
for reference_file in list_reference_files:
    directory = reference_file.split("_")[0]
    print(directory)
    line_nb = 1
    for reference_line in reference_file:
        for file in directory:
            family_name = file.split("_")[0].strip("#")
            for line in file:

                if line.startswith(">") and extractor.extracting:
                    extractor.init()

                if line.startswith(">"):
                    if extractor.check_sequence(reference_line, line):
                        extractor.extract_sequence_name(line, directory, family_name)
                
                if not line.startswith(">") and extractor.extracting:
                    extractor.extracting_sequence_line(line, directory, family_name)

        if line_nb % 500000 == 0:
            print(line_nb)

        line_nb += 1
