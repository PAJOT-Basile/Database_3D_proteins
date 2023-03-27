# Libraries
import bz2 as bz
import os as os
import pandas as pd
from pathlib import Path
import shutil as shu


# Path to get to the first folder.
data_path = "../1-AcnucFamilies"

# Make a list of all the ".fam" files.
list_files = [file for file in os.listdir(data_path) if file.endswith(".fam")]

# Finding the archive file in the folder and open it.
list_archive = [file for file in os.listdir(data_path) if file.endswith(".bz2")]
archive_file = bz.open(os.path.join(data_path, list_archive[0]), "r")

# Defining a function that will give us the kingdom name considering the ".fam" file.
def kingdom_names(file_name):
    kdname = file_name.split(".")[0]
    return(kdname.split("s")[1])

# Creating the files where the data will be stored. Theses files will have the names of the Super-Kingdoms.
for file in list_files:
    # If the script was run before, it removes the created tree.
    if Path(kingdom_names(file)).is_dir():
        shu.rmtree(kingdom_names(file), ignore_errors=True)
        
    # Then, recreates empty directories.
    os.mkdir(kingdom_names(file))

    
# Here, we create an Extractor class. It will be used to extract all the needed family files and create new files with the extracted data.
class Extractor:

    # Initialise method. It will be used to re-initialise the extractor once a family_name is done being extracted.
    def init(self):
        self.extracting = False
        self.extracting_family = None
        self.extracting_superkingdom = None

    # The "check_family_name" method checks if the read family name in the archive file matches the read family name in the ".fam" file.
    def check_family_name(self, family_name, archive_line, file):
        # If they are the same, it returns True, and False otherwise.
        if "".join(["#", family_name]) == archive_line:
            # We set the extracting parameter to True to be able to keep extracting all the lines in the file from the gene family.
            self.extracting = True
            return(True)
        else:
            return(False)
                
    # The "extract_family_name" method extracts the family name of the archive file if it matches with a family name in the ".fam" file.
    def extract_family_name(self, archive_line, file):
        # First, we take out the "\n" at the end of the lines.
        archive_line_stripped = archive_line.strip()
        # We create a new file with the gene family name in the appropriate Super-Kingdom folder and add the family name.
        with open("_".join([os.path.join(kingdom_names(file), archive_line_stripped), "sequences.fasta"]), "a") as f:
            f.write(archive_line)
            f.close()
        # We then store the family name in a variable to find the way back to the file when we won't have the family name as a variable.
        self.extracting_family = archive_line_stripped
        self.extracting = True
        # We then add a variable taking into account the Super-Kingdom. But some gene families can be found in several Super-Kingdoms.
        # Therefore, we make a list we will iterate over while extracting the lines in the gene-family file to each Super-kingdom containing the family name.
        if self.extracting_superkingdom is None:
            self.extracting_superkingdom = [kingdom_names(file)]
        elif len(self.extracting_superkingdom) > 0:
            self.extracting_superkingdom.append(kingdom_names(file))
    
    # The "extract_sequence_line" method works the same way the "extract_family_name" does. It iterates over the superkingdoms to add the line it
    # is extracting to the appropriate file in the right folder.
    def extract_sequence_line(self, archive_line):
            for kingdom_to_add_line_to in self.extracting_superkingdom:
                with open("_".join([os.path.join(kingdom_to_add_line_to, self.extracting_family), "sequences.fasta"]), "a") as f:
                    f.write(archive_line)
                    f.close()


# Make the extractor object and initialise it.
extractor = Extractor()
extractor.init()

# We added a line counter to be able to follow the process, but it is not necesseray.
line_nb = 1

# We iterate over each line in the archive file.
for line in archive_file:
    
    # First, we have to decode the lines (the archive file is a zipped file)
    archive_line = line.decode("utf-8")

    # Then, we test several properties of the line. Each line containing a gene family name starts with "#". Therefore, we will check for each line 
    # starting with a hashtag if the family name it shows is found in either ".fam" file.
    
    
    # If the line strats with a hashtag and the extracing parameter is true, it means that we have extracted all the lines from one family and we are
    # now looking at the line of the next family. Therefore, we have to re-initailise the extractor and start again for all the lines in the new family.
    if archive_line.startswith('#') and extractor.extracting:
        extractor.init() 

    # If the line starts with a hashtag, we iterate over each line in each one of the ".fam" files to compare the lines with the "check_family_name" method.
    if archive_line.startswith('#'):
        for file in list_files:   
            family_names_per_kingdom = open(os.path.join(data_path, file), "r")
            #print(f"    {kingdom_names(file)}")
            for family_name in family_names_per_kingdom:
                # If the family name is not the one we are looking for, we continue.
                if not extractor.check_family_name(family_name, archive_line, file):
                    continue
                # If the family name is the one we are looking for, we extract the family name and stop iterating over the lines in the file.
                # We go directrly to the next ".fam" file.
                else:
                    extractor.extract_family_name(archive_line, file)
                    break
    
    # If the line does not start with a hashtag but the extracting parameter is true, it means we are extracting a family file.
    # Therefore, the line we have is a line we have to extract.
    if not archive_line.startswith("#") and extractor.extracting :
        extractor.extract_sequence_line(archive_line)
    
    
    if line_nb % 1000000 == 0:
        print(line_nb)

    line_nb += 1

