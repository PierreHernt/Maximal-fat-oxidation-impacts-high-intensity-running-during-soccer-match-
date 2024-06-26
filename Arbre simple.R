# Charger les bibliothèques nécessaires
library(dplyr)
library(ggplot2)
library(rpart)
library(rpart.plot)

# Définir le répertoire de travail
setwd("C:/Users/pierh/Stage Master 2/Data/Article")

# Lire les données
df_standardized <- read.csv2("data_standardized.csv", sep=',', dec=".", check.names=F, fileEncoding = "LATIN1")

# Initialiser une fonction pour traiter les différentes variables
process_variable <- function(variable_name, df) {
  donnees <- df %>%
    select(MFO, VO2max, Pmax, F0, all_of(variable_name)) %>% 
    rename(var = all_of(variable_name))
  
  # Ajuster l'arbre de décision
  model.arbre <- rpart(var ~ ., maxdepth = 1, data = donnees)
  
  # Plot de l'arbre de décision
  plot_2 <- rpart.plot(model.arbre, type = 2, extra = 101)
  
  # Récupérer la première coupe et faire le test
  var <- as.character(model.arbre$frame$var[1])
  seuil <- as.numeric(model.arbre$split[,"index"][1])
  donnees$group <- get(var, donnees) > seuil
  test_result <- t.test(var ~ group, data = donnees)
  print(test_result)
  
  wilcox.test(var ~ group, data = donnees)
  
  # Afficher l'importance des variables
  print(model.arbre$variable.importance)
  
  # Test de normalité
  print(shapiro.test(donnees$var))
  
  # Utiliser ggplot2 pour créer le boxplot
  plot_3 <- ggplot(donnees, aes(x = factor(group), y = var)) +
    geom_boxplot() +
    labs(x = paste(var, ">", round(seuil, 2)), y = paste("Standardized Value :", variable_name)) +
    theme_minimal() +
    geom_boxplot(aes(fill = group), fill = "grey40", alpha = 0.2) +
    geom_jitter(aes(color = group), color = "grey40", width = 0.2, size = 2.5) +
    theme_minimal(base_size = 10) +
    theme(plot.title = element_text(size = 14, color = "black", hjust = 0.5, face = 'bold'),
          plot.subtitle = element_text(size = 10, color = "black", hjust = 0.5),
          panel.background = element_rect(fill = "white", color = NA),
          plot.background = element_rect(fill = "white", color = NA),
          panel.grid.major = element_line(color = "grey70"),
          panel.grid.minor = element_blank(),
          axis.text.x = element_text(angle = 45, hjust = 1, color = "black"),
          axis.text.y = element_text(angle = 0, hjust = 1, color = "black"),
          axis.title = element_text(color = "black"),
          axis.title.x = element_text(size = 15, color = "black"),
          axis.title.y = element_text(size = 15, color = "black"))
  
  # Ajouter la p-value sur le graphique
  p_value_text <- paste("p-value:", format(test_result$p.value, digits = 3))
  plot_3 <- plot_3 + annotate("text", x = 1.5, y = max(donnees$var + 0.1, na.rm = TRUE), 
                              label = p_value_text, size = 5, color = "black")
  print(plot_3)
}

# Liste des variables à analyser
variables_to_analyze <- c("Sprinting (> 25 km/h)", "Total Distance", "High Intensity Running (> 15 km/h)")

# Appliquer la fonction pour chaque variable
lapply(variables_to_analyze, process_variable, df = df_standardized)
