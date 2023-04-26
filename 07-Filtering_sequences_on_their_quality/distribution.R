# Libraries
library(ggplot2)
library(dplyr)
library(forcats)
library(cowplot)

# This script takes into account the name of the Super-Kingdom we are working on and the name of the gap score calculation method.
order <- commandArgs()[6]
method <- commandArgs()[7]

# We import the dataset and reorder the data according to the Gap score
data <- read.csv(paste0("./csvs/Evaluation_scores_", order, "_", method, ".csv"), sep = ";", header = TRUE) %>%
    mutate(Family_name = fct_reorder(Family_name, desc(Gap_score)),
           Number_sequences = as.numeric(Number_sequences),
           Number_sites = as.numeric(Number_sites),
           Gap_score = as.numeric(Gap_score)) %>%
    filter(Family_name != Example)

# We make a first plot that gives the distribution of the gap score in the Super-Kingdom
plot1 <- ggplot(data, aes(x = Family_name, y = Gap_score)) +
    geom_col(aes(color = Gap_score)) +
    scale_color_gradient(low = "blue", high = "red") +
    labs(title = paste("Distribution of the gap score for", order),
         x = "Family name",
         y = "Gap score")

# We make a second plot that gives the evolution of the gap score according to the number of sequences in the gene family file and the number 
# of sites in said file
plot2 <- ggplot(data, aes(y = Gap_score)) +
    geom_smooth(aes(x = log10(Number_sequences), color = "Number of sequences")) +
    geom_smooth(aes(x = log10(Number_sites), color = "Number of sites")) +
    labs(title = "Gap score depending on the number of sequences or sites",
         x = "Number of sequences/sites",
         y = "Gap score")

# We paste the two plots together
plot_grid(plot1, plot2, ncol = 1, nrow = 2, labels = c("A", "B"))

# And save them as png images
ggsave(paste0("./Distribution gap score ", order, "_", method, ".png"), width = 10, height = 7, dpi = 300)
