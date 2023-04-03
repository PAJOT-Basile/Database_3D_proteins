# Libraries
library(dplyr)
library(ggplot2)
library(stringr)
library(forcats)
library(cowplot)

# Take a number to simulate the filtering and see how much of the database you lose.
num_min_seq_per_family <- 3

# Import the number of families per Super-Kingdom.
Number_of_families_per_kingdom <- read.csv("Number_of_families_per_superkingdom.csv", sep = ";", header = TRUE) %>% 
  as.data.frame()

# Do a first plot counting the number of gene families per Super-Kingdom.
p1 <-ggplot(data = Number_of_families_per_kingdom, aes(x = Super_kingdom, y = Number_of_families)) +
  geom_col(aes(fill = Super_kingdom)) +
  geom_text(aes(x = Super_kingdom, y = Number_of_families, label = Number_of_families), vjust = 1) +
  ggtitle("Number of families per Super-Kingdom") +
  theme(legend.position = "none")

# Do a second one counting the number of sequences per Super-Kingdom.
p2 <- ggplot(data = Number_of_families_per_kingdom, aes(x = Super_kingdom, y = log(Number_of_sequences))) +
  geom_col(aes(fill = Super_kingdom)) +
  geom_text(aes(x = Super_kingdom, y = log(Number_of_sequences), label = Number_of_sequences), vjust = 1) +
  ggtitle("Number of sequences per Super-Kingdom") +
  theme(legend.position = "none")

# Make a grid with these two lots to save them together.
plot_grid(p1, p2, ncol = 2, nrow = 1, labels = c("A", "B"))

# Save the plots.
ggsave("Stats per Super-Kingdom.png", width = 10, height = 7, dpi = 300)


# Make a list of the csv files per Super-Kingdom.
Number_of_sequences_per_family_list_files <- list.files(path = "./", pattern = "_number_of_sequences_per_family.csv")

# We will iterate over each Super-Kingdom to do the same process and the same graphs.
for (file in Number_of_sequences_per_family_list_files){
  
  # Extract the name of the Super-Kingdom.
  order <- str_split_fixed(file, "_", 6)[1]
  # Import the csv file containing the number of sequences per gene family twice. Once as it is and once simulating the filtering.
  Number_of_sequences_per_family <- read.csv(paste0("./", file), sep = ";", header = TRUE) %>% 
    as.data.frame() %>%
    mutate(Family_name = fct_reorder(Family_name, desc(Number_of_sequences)),
           ID = "Raw data")
  Number_of_sequences_per_family_filtered <- read.csv(paste0("./", file), sep = ";", header = TRUE) %>% 
    as.data.frame() %>% 
    filter(Number_of_sequences > num_min_seq_per_family) %>% 
    mutate(Family_name = fct_reorder(Family_name, desc(Number_of_sequences)),
           ID = "Filtered data")
  
  # We bind the two tables together and plot them in the same graph.
  rbind(Number_of_sequences_per_family, Number_of_sequences_per_family_filtered) %>% 
    mutate(id = factor(ID, levels = c("Raw data", "Filtered data"))) %>% 
    ggplot(aes(x = Family_name, y = log(Number_of_sequences))) +
    geom_col(aes(color = log(Number_of_sequences))) +
    scale_color_gradient(low = "blue", high = "red") +
    ggtitle(paste0("Number of sequences per family for ", nrow(Number_of_sequences_per_family), " original families in ", order,
                  "\n(", nrow(Number_of_sequences_per_family_filtered), " after filtering families with more than ", num_min_seq_per_family, " sequences)"),
            subtitle = paste0("(", round( (nrow(Number_of_sequences_per_family_filtered) / nrow(Number_of_sequences_per_family) )*100, digits = 1),
                              "% families conserved)")) +
    facet_wrap(~id, ncol = 2)

  # Finaly, we save the plot.
  ggsave(paste0("Number of sequences per family for ", order, ".png"))
  
}


