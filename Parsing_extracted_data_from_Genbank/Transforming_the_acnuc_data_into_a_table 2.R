# This file will be used to take the data extracted from the ACNUC database and to parse it 
# into a more exploitable table containing the sequence ID, the classification and the 
# sequence in itself.

# Importing libraries
library(stringr)
library(dplyr)
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

get_line <- function(data, line_number){
    return(data[line_number])
}

verif_param_exists <- function(param){
    return(ifelse(!is.null(param), param, NA))
}

# Making a function to use the mclapply function and do some multithreading.
extract <- function(file_name){
  # Data importation
  data <- read_lines(paste0(data_path, file_name))
  
  # Extracting the kingdom name from the file name
  kingdom_name <- str_split_fixed(file_name, '_', 3)[2]
  print(kingdom_name)

    extracted_data <- c()
    line_number <- 1
    id <- NULL
    classification <- NULL
    sequence <- NULL
    pdb <- NULL
    while (line_number < length(data)){

        line <- get_line(data, line_number)

        if(startsWith(line, 'ID')){
            id <- line %>%
                str_split_fixed(' ', 7)
            id <- id[4]
        }

        if (startsWith(line, 'OC')){
            cl <- c()
            while(startsWith(line, 'OC')){
                cl <- paste(cl, line)
                line_number = line_number + 1
                line <- get_line(data, line_number)
            }
            classification <- str_replace_all(cl, 'OC   ', '') %>%
                str_replace_all('^ ', '')
        }

        if (startsWith(line, '     ')){
            sq <- c()
            while(startsWith(line, '     ')){
                sq <- paste(sq, line)
                line_number = line_number + 1
                line <- get_line(data, line_number)
            }
            sequence <- str_replace_all(sq, ' ', '')
        }

        if (startsWith(line, 'DR   PDB;')){
            pdb <- line
        }




        if (startsWith(line, '//')){
            extracted_data <- c(extracted_data, verif_param_exists(id), verif_param_exists(classification), verif_param_exists(sequence), verif_param_exists(pdb))
            id <- NULL
            classification <- NULL
            sequence <- NULL
            pdb <- NULL
        }


        if (line_number %% 100 == 0){
            print(line_number)
        }
        
        line_number <- line_number +1

    }

    extrated_data <- matrix(extracted_data, ncol = 4, byrow = TRUE) %>%
        as.data.frame() %>%
        rename(ID = V1,
               Classification = V2,
               Sequence = V3,
               Structure = V4)

    write.csv(extracted_data, file = paste('Families', kingdom_name, 'Sequences_Extracted.csv', sep = '_'), col.names = TRUE)
    
    return(extracted_data)
}

for (file in rev(files)){
    extract(file)
}
