installed = installed.packages()
if (!("dplyr" %in% installed)) { install.packages("dplyr") }
if (!("rpart" %in% installed)) { install.packages("rpart") }
if (!("ggplot2" %in% installed)) { install.packages("ggplot2") }
if (!("tidyr" %in% installed)) { install.packages("tidyr") }
if (!("here" %in% installed)) { install.packages("here") }

library(dplyr)
library(rpart)
library(ggplot2)
library(tidyr)
library(here)

# DATA IMPORTATION
base_path <- here()
print(paste(base_path))
df_standardized <- read.csv2("data_standardized.csv", sep=',', dec=".", check.names=F, fileEncoding = "LATIN1")

# Initialize a function to process different variables
process_variable <- function(variable_name, df) {
  data <- df %>%
    select(MFO, VO2max, F0, Pmax, all_of(variable_name)) %>%
    rename(var = all_of(variable_name))
  

  all_variables <- names(data)[names(data) != "var"]
  
  importances_list <- vector("list", 1000)
  
  for (i in 1:1000) {
    # Generate a bootstrap sample
    bootstrap_sample <- data[sample(1:nrow(data), replace = TRUE), ]
    
    # Fit the decision tree
    model <- rpart(var ~ ., data = bootstrap_sample)
    
    # Initialize an importance vector with zero for all variables
    current_importances <- setNames(rep(0, length(all_variables)), all_variables)
    
    # Fill with the actual importance from the model
    if (!is.null(model$variable.importance)) {
      current_importances[names(model$variable.importance)] <- model$variable.importance
    }
    
    # Store the variable importance
    importances_list[[i]] <- current_importances
  }
  
  # Transform the list into a data frame for processing
  importance_df <- do.call(rbind, importances_list) %>% 
    as.data.frame() %>%
    summarise_all(mean, na.rm = TRUE) %>%
    pivot_longer(cols = everything(), names_to = "Variable", values_to = "Importance")
  
  importance_sd <- do.call(rbind, importances_list) %>%
    as.data.frame() %>%
    summarise_all(sd, na.rm = TRUE) %>%
    pivot_longer(cols = everything(), names_to = "Variable", values_to = "SD")
  
  importance_df <- left_join(importance_df, importance_sd, by = "Variable")
  
  # Sort by importance for better visualization
  importance_df <- importance_df %>% 
    arrange(desc(Importance))
  
  
  # DATA VISUALISATION
  plot_1 <- ggplot(importance_df, aes(x = reorder(Variable, Importance), y = Importance)) +
    geom_col(fill = "grey") +
    geom_text(aes(label = paste(round(Importance, 2), "±", round(SD, 1))),
              position = position_stack(vjust = 0.7),  
              color = "black", 
              size = 3.5) +
    geom_errorbar(aes(ymin = Importance - SD, ymax = Importance + SD),
                  width = 0.2,  
                  color = "black",
                  position = position_nudge(x = 0.2)) +  
    theme_minimal() +
    theme(
      plot.title = element_text(size = 15, color = "black", hjust = 0.5, face = 'bold'),
      axis.text.x = element_text(size = 12),
      axis.text.y = element_text(size = 12, face = "bold"),
      panel.background = element_rect(fill = "white", color = NA),
      plot.background = element_rect(fill = "white", color = NA),
      axis.title.x = element_text(size = 15, color = "black"),
      axis.title.y = element_text(size = 15, color = "black"),
      panel.grid.major = element_line(color = "grey70"),
      panel.grid.minor = element_blank()) +
    labs(
      x = "", y = "Importance: Mean ± SD", title = paste("Variable Importance for Predicting", variable_name)
    ) + coord_flip()
  
  print(plot_1)
}

# List of variables to analyze
variables_to_analyze <- c("Sprinting (> 25 km/h)", "Total Distance", "High Intensity Running (> 15 km/h)")

# Apply the function to each variable
lapply(variables_to_analyze, process_variable, df = df_standardized)
