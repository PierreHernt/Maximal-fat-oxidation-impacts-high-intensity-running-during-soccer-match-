# Charger les bibliothèques nécessaires
library(dplyr)
library(rpart)
library(ggplot2)
library(tidyr)

# Définir le répertoire de travail
setwd("C:/Users/pierh/Stage Master 2/Data/Article")

# Lire les données
df_standardized <- read.csv2("data_standardized.csv", sep=',', dec=".", check.names=F, fileEncoding = "LATIN1")

# Initialiser une fonction pour traiter les différentes variables
process_variable <- function(variable_name, df) {
  donnees <- df %>%
    select(MFO, VO2max, F0, Pmax, all_of(variable_name)) %>%
    rename(Dist = all_of(variable_name))
  
  # Noms de toutes les variables prédictives
  all_variables <- names(donnees)[names(donnees) != "Dist"]
  
  # Initialisation de la liste pour stocker les importances de toutes les variables
  importances_list <- vector("list", 1000)
  
  for (i in 1:1000) {
    # Générer un échantillon bootstrap
    bootstrap_sample <- donnees[sample(1:nrow(donnees), replace = TRUE), ]
    
    # Ajuster l'arbre de décision
    model <- rpart(Dist ~ ., data = bootstrap_sample)
    
    # Initialiser un vecteur d'importance avec zéro pour toutes les variables
    current_importances <- setNames(rep(0, length(all_variables)), all_variables)
    
    # Remplir avec les importances réelles du modèle
    if (!is.null(model$variable.importance)) {
      current_importances[names(model$variable.importance)] <- model$variable.importance
    }
    
    # Stocker l'importance des variables
    importances_list[[i]] <- current_importances
  }
  
  # Transformer la liste en data frame pour le traitement
  importance_df <- do.call(rbind, importances_list) %>% 
    as.data.frame() %>%
    summarise_all(mean, na.rm = TRUE) %>%
    pivot_longer(cols = everything(), names_to = "Variable", values_to = "Importance")
  
  importance_sd <- do.call(rbind, importances_list) |>
    as.data.frame() |> summarise_all(sd,na.rm=TRUE) |>
    pivot_longer(cols = everything(), names_to = "Variable", values_to = "SD")
  
  # Fusion des moyennes et des écarts-types dans un seul dataframe
  importance_df <- left_join(importance_df, importance_sd, by = "Variable")
  
  # Trier par importance pour une meilleure visualisation
  importance_df <- importance_df %>% 
    arrange(desc(Importance))
  
  # Création du graphique avec des annotations à l'intérieur des barres
  plot_1 <- ggplot(importance_df, aes(x = reorder(Variable, Importance), y = Importance)) +
    geom_col(fill = "grey") +
    geom_text(aes(label = paste(round(Importance, 2), "±", round(SD, 1))),
              position = position_stack(vjust = 0.7),  # Centrage des étiquettes à l'intérieur des barres
              color = "black",  # Couleur noire pour contraste avec fond gris
              size = 3.5) +
    geom_errorbar(aes(ymin = Importance - SD, ymax = Importance + SD),
                  width = 0.2,  # Largeur des barres d'erreur
                  color = "black",
                  position = position_nudge(x = 0.2)) +  # Couleur des barres d'erreur
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
      x = "", y = "Importance : Mean ± SD", title = paste("Variable Importance for Predicting", variable_name)
    ) + coord_flip()
  
  print(plot_1)
}

# Liste des variables à analyser
variables_to_analyze <- c("Sprinting (> 25 km/h)", "Total Distance", "High Intensity Running (> 15 km/h)")

# Appliquer la fonction pour chaque variable
lapply(variables_to_analyze, process_variable, df = df_standardized)