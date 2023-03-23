# Libraries
import bz2 as bz
import csv as csv
import os as os
import pandas as pd
from pathlib import Path
import shutil as shu


# Data path
data_path = "../0-test"
list_files = [file for file in os.listdir(data_path) if file.endswith(".fam")]


list_archive = [file for file in os.listdir(data_path) if file.endswith(".bz2")]

archive_file = bz.open(os.path.join(data_path, list_archive[0]), "r")

def kingdom_names(file_name):
    kdname = file_name.split(".")[0]
    return(kdname.split("s")[1])

for file in list_files:
    # If the script was run before, clean up
    if Path(kingdom_names(file)).is_dir():
        shu.rmtree(kingdom_names(file))

    os.mkdir(kingdom_names(file))

class Extractor:

    def init(self):
        self.extracting = False
        self.extracting_family = None
        self.extracting_superkingdom = None


    def check_family_name(self, family_name, archive_line, file):
        if "".join([">", family_name]) == archive_line:
            print(f"Extracting sequence from {family_name} in {kingdom_names(file)}.")
            self.extracting = True
            return(True)
        else:
            return(False)
                

    def extract_family_name(self, archive_line, file):
        if self.extracting_family is None:
            with open("_".join([os.path.join(kingdom_names(file), archive_line), "sequences.fasta"]), "a") as f:
                writer_object = csv.writer(f)
                writer_object.writerow(archive_line)
                f.close()
            self.extracting_family = archive_line
            self.extracting = True
            if self.extracting_superkingdom is None:
                self.extracting_superkingdom = [kingdom_names(file)]
            elif len(self.extracting_superkingdom) == 1:
                self.extracting_superkingdom.append(kingdom_names(file))
    
    def extract_sequence_line(self, archive_line):
            for kingdom_to_add_line_to in self.extracting_superkingdom:
                with open("_".join([os.path.join(kingdom_to_add_line_to, self.extracting_family), "sequences.fasta"]), "a") as f:
                    writer_object = csv.writer(f)
                    writer_object.writerow(archive_line)
                    f.close()


extractor = Extractor()
extractor.init()

line_nb = 1
# Final loop
for archive_line in archive_file:
    if archive_line.startswith(b'>'):
        print(line_nb)

        for file in list_files:
            
            family_names_per_kingdom = open(os.path.join(data_path, file), "r")
            print(f"    {kingdom_names(file)}")
            for family_name in family_names_per_kingdom:
                if not extractor.check_family_name(family_name, archive_line, file):
                    continue
                else:
                    print(f"Match for {archive_line}")
                    extractor.extract_family_name(archive_line, file)
                    break
    if archive_line.startswith(b'>') and extractor.extracting:
        extractor.init() 
        continue

    if extractor.extracting :
        extractor.extract_sequence_line(archive_line)
    
    
    line_nb += 1





