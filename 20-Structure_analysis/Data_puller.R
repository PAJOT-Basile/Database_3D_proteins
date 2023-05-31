# Libraries
library(dplyr)
library(readr)
library(stringr)

setwd("/home/bpajot/Database_3D_proteins/20-Structure_analysis")
#data_path <- commandArgs()[6]
data_path="../Database/"
list_orders <- read_file("../01-AcnucFamilies/List_Archaea.txt") %>%
    str_split_fixed("\n", 4)

for (order in list_orders){
    if (order == ""){
        next
    }else{
        columns <- c("Group", "PDB", "amino_acid", "probability", "Proba>0.95", "Rsa", "SecondaryStructure", "Gene_family")
        to_write <- data.frame(matrix(nrow=0, ncol=length(columns)))
        colnames(to_write) <- columns
        for (family in list.dirs(path=paste0(data_path, order), recursive=FALSE)){
            family_name <- str_split_fixed(family, "/", 4)[4]
            if (dir.exists(paste(data_path, order, family_name, "13-Structure_info", sep="/"))){
                df <- read.csv(paste(data_path, order, family_name, "13-Structure_info", paste0(family_name, "_structinfos.csv"), sep="/"), header=TRUE, sep="\t") %>%
                        mutate(Gene_family = family_name)
                
                to_write <- rbind(to_write, df)
            }
        }
        #print(to_write)
        to_write <- to_write %>%
          mutate(AlnPosition = parse_number(as.character(Group))) %>%
          relocate(AlnPosition, .before = Group) %>%
          select(-Group)
          
        write.csv(to_write, paste(data_path, order, paste0(order, "_structure_info.csv"), sep="/"), sep = ";", col.names=TRUE)
    }
}
