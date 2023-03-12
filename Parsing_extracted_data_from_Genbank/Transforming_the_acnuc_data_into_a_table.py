# Libraries

import numpy as np
import os as os
import pandas as pd
import time as time

data_path = '../Acnuc_sequences_Genbank'
list_files = os.listdir(data_path)


class Extractor:

    def init(self):
        self.id = None
        self.classification = None
        self.sequence = None
        self.pdb = None
        self.temporary_classification = ''
        self.temporary_sequence = ''
        self.extracted_data = np.array([['ID', 'Classification', 'Sequence', 'Folding data']])

    def contains_info(self, line):

        if line.startswith("ID") or line.startswith('OC') or line.startswith('     ') or line.startswith('DR   PDB;') or line.startswith('//'):
            return(True)
        
        else:
            return(False)
    
    
    def check_parameters(self, line):
        
        # ID
        if line.startswith('ID'):
            self.id = line.split()[1]
            pass

        # Classification
        elif line.startswith('OC'):
            self.temporary_classification += line
            self.temporary_classification  = self.temporary_classification.replace('OC   ', ' ')        
            self.temporary_classification  = self.temporary_classification.replace('\nOC   ', ' ')
            self.temporary_classification  = self.temporary_classification.replace('\n', '')

        # Sequence
        elif line.startswith('     '):
            self.temporary_sequence += line
            self.temporary_sequence = self.temporary_sequence.replace(' ', '')
            self.temporary_sequence = self.temporary_sequence.replace('\n', '')
            pass

        # Folding data
        elif line.startswith('DR   PDB;'):
            self.pdb = line.replace('DR   ', '')
            self.pdb = self.pdb.replace('\n', '')

    def add(self):
        
        if self.id is None:
            self.id = np.nan
        
        if self.temporary_classification != '':
            self.classification = self.temporary_classification
        if self.temporary_classification == '':
            self.classification = np.nan

        if self.temporary_sequence != '':
            self.sequence = self.temporary_sequence
        if self.temporary_sequence == '':
            self.sequence = np.nan

        if self.pdb is None:
            self.pdb = np.nan

        self.last_extracted_data = self.extracted_data
        self.extracted_data =  np.append(self.last_extracted_data, np.array([[self.id, self.classification, self.sequence, self.pdb]]), axis=0)
        self.reinit()

    def reinit(self):
        self.id = None
        self.classification = None
        self.sequence = None
        self.pdb = None
        self.temporary_classification = ''
        self.temporary_sequence = ''

    def end(self):
        return(self.extracted_data)



def kingdom_names(file_name):
    kdname = file_name.split('_')[1]
    kdname = kdname.split('.')[0]
    return(kdname)

start = time.time()

data = open(os.path.join(data_path, list_files[0]), 'r')


extractor = Extractor()
extractor.init()

nb_rounds = 10000

for _ in range(nb_rounds):
    for file in list_files:
        for line in data:
            if not extractor.contains_info(line):
                continue
            else:
                extractor.check_parameters(line)
                if line.startswith('//'):
                    extractor.add()
                

        pd.DataFrame(extractor.end()).to_csv('_'.join(['Families', kingdom_names(file), 'Sequences_Extracted.csv']), header=False, index=False)

end = time.time()
elapsed = end - start

print(f'Running time: {elapsed:.5}.')
