# Crée un jeu de données SIMULÉ qui reprend la structure de la base d'événements du SHP
# utilisée dans le travail original. Les valeurs sont inventées : les résultats produits
# avec ce jeu ne sont pas des résultats de recherche.
# Sortie : data/panel_simule.csv

set.seed(2024)
n <- 6000

P <- data.frame(IDPERS = 1:n)
P$BIRTHYR <- sample(1925:1995, n, replace = TRUE)
P$SEX13   <- sample(c("man", "woman"), n, replace = TRUE)

# Mariage : environ 65 % des personnes se marient, vers 27 ans en moyenne
age_mar <- pmax(18, round(rnorm(n, mean = 27, sd = 5)))
P$married <- ifelse(runif(n) < 0.65, P$BIRTHYR + age_mar, NA)
P$married[!is.na(P$married) & P$married > 2013] <- NA

# Divorce : environ 30 % des mariages, observés seulement jusqu'en 2013
divorce_prevu <- !is.na(P$married) & runif(n) < 0.30
duree_div     <- pmax(1, round(rweibull(n, shape = 1.4, scale = 15)))
annee_div     <- P$married + duree_div
P$divorced    <- ifelse(divorce_prevu & annee_div <= 2013, annee_div, NA)

# Âge au premier enfant et à la première opération (manquant = aucun)
P$FirstChild <- ifelse(runif(n) < 0.60, round(rnorm(n, mean = 29, sd = 5)), NA)
P$operation  <- ifelse(runif(n) < 0.50, round(runif(n, min = 5, max = 70)), NA)

dir.create("data", showWarnings = FALSE)
write.csv(P, "data/panel_simule.csv", row.names = FALSE)
cat("Jeu simulé écrit dans data/panel_simule.csv (", n, "lignes )\n")
