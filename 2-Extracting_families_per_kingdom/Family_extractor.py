# Libraries
import bz2 as bz
import os as os
from pathlib import Path
import shutil as shu
import sys as sys
import tqdm as tqdm


# This script takes as input the path to the folder containing the data to extract
data_path = sys.argv[1]

# We make a list of the "fam" files in the parallel folder to iterate over them
list_files = [file for file in os.listdir(data_path) if file.endswith(".fam")]

# In the same way, we make a list of the archive files to be able to extract only the one archive file name from the parallel folder
list_archive = [file for file in os.listdir(data_path) if file.endswith(".bz2")]

# This is the number of lines in the archive file. You do not really need it. It is a fast way to make a progress bar appear but is not necessary. If you take 
# it out, make sure to take out the "zip" and the counter that is used in the end loop
x=822419022

# We open the archive file.
archive_file = bz.open(os.path.join(data_path, list_archive[0]), "r")

# We make a "kingdom_names" function allowing us to extract the Super-Kingdom names from the file name
def kingdom_names(file_name):
    kdname = file_name.split(".")[0]
    return(kdname.split("s")[1])

# We iterate over the list of files in the parallel folder to make a new directory for each Super-Kingdom. If the script was run before, it removes the previously
# created files
for file in list_files:
    # If run before, we clean up the working environment to not mix everything up
    if Path(kingdom_names(file)).is_dir():
        shu.rmtree(kingdom_names(file), ignore_errors=True)

    # We create a new folder wuth the name of the Super-Kingdom
    os.mkdir(kingdom_names(file))

# We define the "Extractor" class that will be used to extract all the needed sequences and create new files with the extracted data
class Extractor:

    # Initialise method. It will be used to re-initialise the extractor once the sequence is done being extracted. We define several local variables that
    # will help us while iterating over the lines in the archive file to know which lines to take and which not to take
    def init(self):
        self.extracting = False
        self.extracting_family = None
        self.extracting_superkingdom = None

    # The "check_family_name" method checks if the considered family ID is the same as one we have in the archive file
    def check_family_name(self, family_name, archive_line, file):
        # If it matches, we return True and set the extracting parameter to True
        if "".join(["#", family_name]) == archive_line:
            self.extracting = True
            return(True)
        else:
            return(False)
                
    # The "extract_family_name" method extracts the gene family name from the archive file
    def extract_family_name(self, archive_line, file):
        archive_line_stripped = archive_line.strip()
        with open("#".join([os.path.join(kingdom_names(file), archive_line_stripped), "sequences.fasta"]), "a") as f:
            f.write(archive_line)
            f.close()
        # We set the "extracting_family" parameter to the name of the gene family we are extracting to be able to save this name when we will no longer
        # be reading the corresponding line in the archive file.
        self.extracting_family = archive_line_stripped
        self.extracting = True
        
        # We commit to memory the Super-Kingdoms that are being extracted to be able to iterate over them if some gene families are in several Super-Kingdoms
        if self.extracting_superkingdom is None:
            self.extracting_superkingdom = [kingdom_names(file)]
        elif len(self.extracting_superkingdom) > 0:
            self.extracting_superkingdom.append(kingdom_names(file))
    
    # The "extract_sequence_line" method is used to extract the lines in the considered gene family (sequence IDs and sequences)
    def extract_sequence_line(self, archive_line):
            for kingdom_to_add_line_to in self.extracting_superkingdom:
                with open("#".join([os.path.join(kingdom_to_add_line_to, self.extracting_family), "sequences.fasta"]), "a") as f:
                    f.write(archive_line)
                    f.close()


# we make the Extrator object and intitialise it.
extractor = Extractor()
extractor.init()

# We iterate over the lines in the in the archive file (the zip with x is just to be able to see the progress bar)
for line, line_nb in zip(archive_file, tqdm.tqdm(range(x))):
    # we decode the line from the zipped archive file
    archive_line = line.decode("utf-8")

    if archive_line.startswith('#') and extractor.extracting:
        extractor.init() 


    # If the line from the archive file starts with "#", it means that we are looking at a gene family ID. Therefore, we will compare it to each
    #  line in the "fam" files containing all the gene family IDs that are in the corresponding Super-Kingdom
    if archive_line.startswith('#'):

        # We iterate over the "fam" files
        for file in list_files:
            
            # We open the corresponding "fam" file
            family_names_per_kingdom = open(os.path.join(data_path, file), "r")
            
            # We iterate over each line of the opened "fam" file to test if the gene family name is one we need to extract thanks to the "check_family_name"
            # method. If we have a gene family name we have to extract, we use the "extract_family_name" method and exit the loop in the "fam" file 
            # (each gene family is only present once in each "fam" file)
            for family_name in family_names_per_kingdom:
                if not extractor.check_family_name(family_name, archive_line, file):
                    continue
                else:
                    extractor.extract_family_name(archive_line, file)
                    break
    
    # If the line does not start with "#" in the archive file, but we are extracting, it means that we are in a gene family we have to extract
    # Therefore, we extract each line in the gene family using the "extract_sequence_line" method
    if not archive_line.startswith("#") and extractor.extracting :
        extractor.extract_sequence_line(archive_line)
    





