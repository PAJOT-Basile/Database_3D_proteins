# Libraries
library(dplyr)
library(readr)
library(stringr)

# This script takes as variable input the path to the database
data_path <- commandArgs()[6]
# This file contains a list of the Super-Kingdoms we are working on. We will iterate over these orders
list_orders <- read_file("../01-AcnucFamilies/List_superkingdoms.txt") %>%
    str_split_fixed("\n", 4)

# We make a printf function to separate the different lines of the progressbar
printf <- function(t) cat(sprintf(t))

# We iterate over the Super-Kingdoms
for (order in list_orders){
    if (order == ""){
        next
    }else{
        # We create an empty dataframe that will be filled up by the gene family structure informations for each Super-Kingdom
        columns <- c("Group", "PDB", "amino_acid", "probability", "Proba>0.95", "Rsa", "SecondaryStructure", "Gene_family")
        to_write <- data.frame(matrix(nrow=0, ncol=length(columns)))
        colnames(to_write) <- columns
        # We print a carraige return to go back to the line for the next Super-Kingdom
        printf("\n")
        print(order)

        # We make a list of all the gene families in the Super-Kingdom folder
        list_gene_families <- list.dirs(path=paste0(data_path, order), recursive=FALSE)

        # We define a progress bar that takes into account the number of gene families in the considered Super-Kingdom
        pb <- txtProgressBar(min=0, max=length(list_gene_families), initial=0)

        # We iterate over the gene families
        for (i in 1:length(list_gene_families)){
            # We implement the progressbar
            setTxtProgressBar(pb, i)

            # We extract the gene family name from the list of gene families
            family <- list_gene_families[i]
            family_name <- str_split_fixed(family, "/", 4)[4]
            if (family_name == "Example"){
                next
            }
            else{
                # If the structure info SGED file exists, we import it and add it to the previously binded or created dataframe
                if (file.exists(paste(data_path, order, family_name, "13-Structure_info", paste0(family_name, "_structinfos.csv"), sep="/"))){
                df <- read.csv(paste(data_path, order, family_name, "13-Structure_info", paste0(family_name, "_structinfos.csv"), sep="/"), header=TRUE, sep="\t") %>%
                        mutate(Gene_family = family_name)
                if (ncol(df) <= 7){
                  df$Proba.0.95 <- rep(NA, nrow(df))
                }
                to_write <- rbind(to_write, df)
                }
            }
        }
        # We change the Group column into an alignment position
        to_write <- to_write %>%
          mutate(AlnPosition = parse_number(as.character(Group))) %>%
          relocate(AlnPosition, .before = Group) %>%
          select(-Group)
        
        # We write the output of the binding process into a csv file in the considered Super-Kingdom folder in the database
        write.table(to_write, paste(data_path, order, paste0(order, "_structure_info.csv"), sep="/"), 
                    sep = ";", na = "NA", row.names = FALSE, col.names = TRUE)
    }
}
