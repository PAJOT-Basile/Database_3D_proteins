# Libraries 

require(ape)
require(stringr)

# Variable input
file_to_transform <- commandArgs()[6]
path_file <- str_split(file_to_transform, "/")

data_path <- paste(path_file[[1]][1], path_file[[1]][2], sep="/")
order <- path_file[[1]][3]
family <- path_file[[1]][4]

t <- read.tree(file_to_transform)
t$node.label <- NULL
write.tree(t, file=paste(data_path, order, family, "10-Tree_without_bootstrap", paste0(family, ".tree"), sep="/"))