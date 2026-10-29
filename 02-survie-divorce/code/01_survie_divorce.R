# Analyse de survie : durée du mariage avant le divorce, selon le sexe
# Travail pratique du cours d'Analyse de données longitudinales (Université de Genève, 2024)
# Entrée : data/panel_simule.csv (jeu simulé) ou un fichier réel au même format
# Colonnes attendues : BIRTHYR, SEX13 ("man"/"woman"), married, divorced, FirstChild, operation
# Sorties : figures dans output/

library(survival)
dir.create("output", showWarnings = FALSE)

# ---------------------------------------------------------------
# 1. Préparation des données
# ---------------------------------------------------------------
data <- read.csv("data/panel_simule.csv", stringsAsFactors = FALSE)

annee_obs <- 2013
data$AGE  <- annee_obs - data$BIRTHYR    # âge en 2013 (reflet de la génération)
data <- subset(data, AGE > 18)

# Population d'analyse : personnes dont le mariage ET le divorce sont observés.
# Choix assumé : les personnes non divorcées n'ont pas de durée dans la base d'origine
# (aucune donnée censurée). On étudie donc le moment du divorce parmi les divorcés,
# pas la probabilité de divorcer. Voir la section "Limites" du rapport.
data <- subset(data, !is.na(married) & !is.na(divorced))

data$DIVORCE <- 1
data$duree   <- data$divorced - data$married   # durée du mariage en années

summary(data$duree)
table(data$duree <= 0)

# On retire les durées négatives (incohérences) et nulles
data <- subset(data, duree > 0)
nrow(data)

# ---------------------------------------------------------------
# 2. Analyse descriptive
# ---------------------------------------------------------------
sdivorce <- Surv(data$duree, data$DIVORCE == 1)

km <- survfit(sdivorce ~ 1)
print(km)
summary(km)

png("output/courbe_globale.png", width = 800, height = 600)
plot(km, conf.int = TRUE,
     main = "Proportion de mariages non dissous selon la durée",
     xlab = "Durée du mariage (années)",
     ylab = "Proportion de mariages non dissous")
abline(h = 0.5, lty = 2)
dev.off()

km_sexe <- survfit(sdivorce ~ data$SEX13)
print(km_sexe)   # médianes et intervalles de confiance par sexe

png("output/courbes_par_sexe.png", width = 800, height = 600)
plot(km_sexe, col = c("blue", "red"),
     main = "Proportion de mariages non dissous selon la durée, par sexe",
     xlab = "Durée du mariage (années)",
     ylab = "Proportion de mariages non dissous")
legend("topright", c("Hommes", "Femmes"), col = c("blue", "red"), lty = 1)
abline(h = 0.5, lty = 2)
dev.off()

survdiff(sdivorce ~ data$SEX13)   # test du log-rank

# ---------------------------------------------------------------
# 3. Modèles de Cox
# ---------------------------------------------------------------
# FirstChild = âge au premier enfant, operation = âge à la première opération.
# Ces variables sont manquantes pour une partie des personnes : le modèle 2
# ne garde que celles qui ont une valeur pour chacune.
cox1 <- coxph(Surv(duree, DIVORCE) ~ SEX13, data = data)
summary(cox1)

cox2 <- coxph(Surv(duree, DIVORCE) ~ SEX13 + AGE + FirstChild + operation,
              data = data)
summary(cox2)

# Hypothèse de proportionnalité (résidus de Schoenfeld)
cox.zph(cox1)
cox.zph(cox2)

png("output/schoenfeld_cox2.png", width = 1200, height = 400)
par(mfrow = c(1, 4))
plot(cox.zph(cox2))
dev.off()
par(mfrow = c(1, 1))

# Modèle stratifié par sexe
cox3 <- coxph(Surv(duree, DIVORCE) ~ strata(SEX13) + AGE + FirstChild + operation,
              data = data)
summary(cox3)

png("output/cloglog_strate_sexe.png", width = 800, height = 600)
plot(survfit(cox3), col = 1:2, fun = "cloglog",
     xlab = "Durée du mariage (années, échelle log)",
     ylab = "log(-log(survie))")
legend("topleft", c("Hommes", "Femmes"), col = 1:2, lty = 1)
dev.off()

# Interaction du sexe avec le temps
cox4 <- coxph(Surv(duree, DIVORCE) ~ SEX13 + tt(SEX13 == "woman") + AGE +
                FirstChild + operation,
              data = data,
              tt = function(x, t, ...) x * t)
summary(cox4)
