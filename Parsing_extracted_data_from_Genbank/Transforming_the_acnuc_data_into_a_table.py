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

    def check_parameters(self, line):
        
        # ID
        if line.startswith('ID'):
            self.id = line.split()[1]

        # Classification
        if line.startswith('OC'):
            self.temporary_classification += line
            self.temporary_classification  = self.temporary_classification.replace('OC   ', ' ')        
            self.temporary_classification  = self.temporary_classification.replace('\nOC   ', ' ')
            self.temporary_classification  = self.temporary_classification.replace('\n', '')

        # Sequence
        if line.startswith('     '):
            self.temporary_sequence += line
            self.temporary_sequence = self.temporary_sequence.replace(' ', '')
            self.temporary_sequence = self.temporary_sequence.replace('\n', '')

        # Folding data
        if line.startswith('DR   PDB;'):
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

data = open(os.path.join(data_path, list_files[2]), 'r')


extractor = Extractor()
extractor.init()

for line in data:
    extractor.check_parameters(line)
    if line.startswith('//'):
        extractor.add()

print(extractor.end())

pd.DataFrame(extractor.end()).to_csv('_'.join(['Families', kingdom_names(list_files[1]), 'Sequences_Extracted.csv']), header=False, index=False)

end = time.time()
elapsed = end - start

print(f'Running time: {elapsed:.3}.')
