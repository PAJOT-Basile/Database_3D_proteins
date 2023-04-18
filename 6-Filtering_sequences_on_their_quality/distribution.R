library(ggplot2)
library(dplyr)
library(forcats)
library(cowplot)


order <- commandArgs()[6]
method <- commandArgs()[7]

data <- read.csv(paste0("./csvs/Evaluation_scores_", order, ".csv"), sep = ";", header = TRUE) %>%
    mutate(Family_name = fct_reorder(Family_name, desc(Gap_score)),
           Number_sequences = as.numeric(Number_sequences),
           Number_sites = as.numeric(Number_sites),
           Gap_score = as.numeric(Gap_score))

plot1 <- ggplot(data, aes(x = Family_name, y = Gap_score)) +
    geom_col(aes(color = Gap_score)) +
    scale_color_gradient(low = "blue", high = "red") +
    labs(title = paste("Distribution of the gap score for", order),
         x = "Family name",
         y = "Gap score")

plot2 <- ggplot(data, aes(y = Gap_score)) +
    geom_smooth(aes(x = log10(Number_sequences), color = "Number of sequences")) +
    geom_smooth(aes(x = log10(Number_sites), color = "Number of sites")) +
    labs(title = "Gap score depending on the number of sequences or sites",
         x = "Number of sequences/sites",
         y = "Gap score")


plot_grid(plot1, plot2, ncol = 1, nrow = 2)

ggsave(paste0("./", method, "_Distribution gap score", order, ".png"), width = 10, height = 7, dpi = 300)

print(paste("The maximum gap score is", max(data$Gap_score)))
