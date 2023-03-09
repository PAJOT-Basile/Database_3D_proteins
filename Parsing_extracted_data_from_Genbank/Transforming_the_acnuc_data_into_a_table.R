# This file will be used to take the data extracted from the ACNUC database and to parse it 
# into a more exploitable table containing the sequence ID, the classification and the 
# sequence in itself.

# Importing libraries
library(stringr)
library(dbplyr)
library(readr)
library(parallel)

# We will automatize the process of transforming an ACNUC file into a data frame. To do this,
# we will do a function that extracts the wanted data from the ACNUC file that we will then
# thread to use on several CPUs and win some time.
# To do so, we will first make a list of the 'gb' files in the '../Acnuc_sequences_Genbank' folder.
# We will iterate over these files to load the data and start as many jobs as there are '.gb' 
# files in the folder.
data_path <- '../Acnuc_sequences_Genbank/'
files <- list.files(path = data_path, pattern = '.gb')

# Making a function to use the mclapply function and do some multithreading.
extract <- function(file_name){
  # Data importation
  data <- read_lines(paste0(data_path, file_name))
  
  # Extracting the kingdom name from the file name
  kingdom_name <- str_split_fixed(file_name, '_', 3)[2]
  print(kingdom_name)
  
  # Each new sequence in the ACNUC file has a '//' at the end that is used as an end character. 
  # Therefore, we will use these characters as a way to count the sequences in the file and to 
  # mark out the beginning of and end of the sequences in the file.
  nb_seq <- grep('//', data)   # Here we get all the lines where a '//' appears.
  nb_seq[length(nb_seq) + 1] <- 1      # Here we add 1 to the list of line numbers to be able 
  # to mark out the first sequence. This will be our starting point
  nb_seq <- sort(nb_seq)    # Here we put all the lines in ascending order to be able to start 
  # at the beginning and finish at the end of the file. 
  
  
  # To extract all the sequences from the data file, we will keep extracting fragments of the total 
  # data file containing one sequence and make a small file that we can manipulate more easily. The 
  # whole process is put in a loop to iterate over all the sequences in the data file.
  
  for (num_seq in 1:(length(nb_seq) - 1)){
    print(num_seq)
    # Making a variable containing only one sequence on which we will be working in the loop. We take 
    # the data contained between two successive '//'
    dataseq <- data[nb_seq[num_seq] : nb_seq[num_seq + 1]]
    
    
    
    # First we extract the line containing the sequence ID from the extracted data.
    id <- dataseq[grep('^ID', dataseq)]
    # Then we isolate the ID in the line.
    id <- str_split_fixed(id, ' ', 7)[4]
    
    
    
    # The ID is now extracted. We will then extract the classification from the extracted data. We now, 
    # extract the lines containing the classification.
    classification <- dataseq[grep('^OC', dataseq)]
    # The classification contains several lines all starting with 'OC'. Therefore, we will paste all 
    # of the lines one after the other using a short loop.
    cl <- c()    # Here we initialize the loop
    for (i in 1:length(classification)){
      cl <- paste(cl, classification[i])
    }
    # The cl variable now contains all the taxonomy pasted. But it is polluted with some 'OC' where
    # the lines used to start. Thus, we will now delete the 'OC' and take out the space at the beginning of the line.
    classification <- str_replace_all(cl, 'OC   ', '') %>% 
      str_replace_all('^ ', '')
    
    
    
    # We now have the ID and the classification. The only missing item is the sequence that we will be using. 
    # We will extract the lines containing the sequences and then paste them all together (they are on several
    # lines) using the same method as for the classification.
    sequence <- dataseq[grep('^     ', dataseq)]   # Here we select the lines containing the sequence. They
    # all start with '     ' (5 spaces).
    sq <- c()    # Here we initialize the loop
    for (i in 1:length(sequence)){
      sq <- paste(sq, sequence[i])
    }
    # The sq variable now contains the sequence on one line. But there are several spaces left in the sequence
    # that could through off some alignment software. Thus, we take them out.
    sequence <- str_replace_all(sq, ' ', '')
    
    
    
    # All the wanted parameters are now extracted. We can now combine them into a data frame that will be completed
    # after each iteration over the data file. We must however separate the cases where the data frame is empty and
    # when it is not. To do that, we will make a temporary data frame containing the information we just extracted
    # that we will then complete.
    temp_datafr <- cbind(id, classification, sequence) %>% 
      matrix(ncol = 3)
    
    # Now we will separate the cases of an empty data frame and a non-empty one.
    if (num_seq == 1){
      extracted_data <- temp_datafr
    }else{
      extracted_data <- rbind(extracted_data, temp_datafr)
    }
  }
  extracted_data <- as.data.frame(extracted_data)
  # Finally, the extracted_data data frame contains the data we want. We will just rename the columns and save it.
  colnames(extracted_data) <- c('ID', 'Taxonomy', 'Sequence')
  write.csv(extracted_data, file = paste('Families', kingdom_name, 'Sequences_Extracted.csv', sep = '_'), col.names = TRUE)
  
  
  
  return(paste('Ok for', kingdom_name))
} 


# Running the function extract for each file in the files list
for (file in files){
  mclapply(file, extract, mc.cores = 7)
}

