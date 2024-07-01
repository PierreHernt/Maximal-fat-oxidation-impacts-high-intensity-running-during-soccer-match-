installed = installed.packages()
if (!("dplyr" %in% installed)) { install.packages("dplyr") }
if (!("rpart" %in% installed)) { install.packages("rpart") }
if (!("ggplot2" %in% installed)) { install.packages("ggplot2") }
if (!("rpart.plot" %in% installed)) { install.packages("rpart.plot") }
if (!("here" %in% installed)) { install.packages("here") }

# Load necessary libraries
library(dplyr)
library(ggplot2)
library(rpart)
library(rpart.plot)
library(here)

# DATA IMPORTATION
base_path <- here()
print(paste(base_path))
df_standardized <- read.csv2("data_standardized.csv", sep=',', dec=".", check.names=F, fileEncoding = "LATIN1")

# Initialize a function to process different variables
process_variable <- function(variable_name, df) {
  data <- df %>%
    select(MFO, VO2max, Pmax, F0, all_of(variable_name)) %>% 
    rename(var = all_of(variable_name))
  
  # Fit the decision tree
  model.tree <- rpart(var ~ ., maxdepth = 1, data = data)
  
  # Retrieve the first split and perform the test
  var <- as.character(model.tree$frame$var[1])
  threshold <- as.numeric(model.tree$split[,"index"][1])
  data$group <- get(var, data) > threshold
  test_result <- t.test(var ~ group, data = data)
  print(test_result)
  
  wilcox.test(var ~ group, data = data)
  
  # DATA VISUALIZATION
  plot_2 <- ggplot(data, aes(x = factor(group), y = var)) +
    geom_boxplot() +
    labs(x = paste(var, ">", round(threshold, 2)), y = paste("Standardized Value:", variable_name), title = variable_name) +
    theme_minimal() +
    geom_boxplot(aes(fill = group), fill = "grey40", alpha = 0.2) +
    geom_jitter(aes(color = group), color = "grey40", width = 0.2, size = 2.5) +
    theme_minimal(base_size = 10) +
    theme(plot.title = element_text(size = 17, color = "black", hjust = 0.5, face = 'bold'),
          plot.subtitle = element_text(size = 10, color = "black", hjust = 0.5),
          panel.background = element_rect(fill = "white", color = NA),
          plot.background = element_rect(fill = "white", color = NA),
          panel.grid.major = element_line(color = "grey70"),
          panel.grid.minor = element_blank(),
          axis.title = element_text(color = "black"),
          axis.text.x = element_text(angle = 45, hjust = 1, color = "black"),
          axis.text.y = element_text(angle = 0, hjust = 1, color = "black"),
          axis.title.x = element_text(size = 15, color = "black"),
          axis.title.y = element_text(size = 15, color = "black"))
  
  # Add the p-value to the plot
  p_value_text <- paste("p-value:", format(test_result$p.value, digits = 3))
  plot_2 <- plot_2 + annotate("text", x = 1.5, y = max(data$var + 0.1, na.rm = TRUE), 
                              label = p_value_text, size = 5, color = "black")
  print(plot_2)
}

# List of variables to analyze
variables_to_analyze <- c("Sprinting (> 25 km/h)", "Total Distance", "High Intensity Running (> 15 km/h)")

# Apply the function to each variable
lapply(variables_to_analyze, process_variable, df = df_standardized)
