# ==============================================================
# Intérêt politique : modèles multiniveaux sur données de panel
# À lancer depuis le dossier 01-interet-politique/
# ==============================================================

library(dplyr)
library(lme4)
library(lmerTest)   # p-values (méthode de Satterthwaite)
library(plm)
library(psych)

dir.create("output", showWarnings = FALSE)

# --------------------------------------------------------------
# 1. DONNEES
# --------------------------------------------------------------
# Par défaut : le jeu simulé (voir 00_simuler_donnees.R).
# Pour les vraies données (Swiss Household Panel), fournir un fichier
# au même format : IDPERS, wave, polint, sex, age, income, polpos, eduyear.
fichier <- "data/panel_simule.csv"
if (!file.exists(fichier)) source("code/00_simuler_donnees.R")
data <- read.csv(fichier, stringsAsFactors = FALSE)

# --------------------------------------------------------------
# 2. PREPARATION
# --------------------------------------------------------------
data <- data %>%
  filter(age >= 18,                       # âge de voter
         sex %in% c("man", "woman")) %>%  # catégorie "other" exclue (très rare)
  mutate(
    sex        = factor(sex),
    cohort     = factor(ifelse(wave <= 2007, "1999-2007", "2008-2022"),
                        levels = c("1999-2007", "2008-2022")),
    age10      = (age - 18) / 10,         # échelle réduite : aide la convergence
    log_income = log1p(income),           # revenu très asymétrique
    polpos_ext = abs(polpos - 5)          # position affirmée = distance au centre
  )

# Un seul échantillon pour tous les modèles : comparaisons valides
vars <- c("polint", "sex", "cohort", "age10", "log_income",
          "polpos", "polpos_ext", "eduyear")
data_c <- data %>% filter(complete.cases(across(all_of(vars))))

# Décomposition intra / inter individuelle (moyenne de la personne + écart)
data_c <- data_c %>%
  group_by(IDPERS) %>%
  mutate(mage    = mean(age10),       eage    = age10 - mage,
         mlinc   = mean(log_income),  elinc   = log_income - mlinc,
         mpolpos = mean(polpos),      epolpos = polpos - mpolpos) %>%
  ungroup() %>%
  as.data.frame()

# --------------------------------------------------------------
# 3. DESCRIPTIVES
# --------------------------------------------------------------
desc <- describe(data_c[, c("polint", "age", "income", "polpos", "eduyear")])
print(round(desc, 2))
write.csv(round(as.data.frame(desc), 2), "output/descriptives.csv")

png("output/interet_moyen_par_annee.png", width = 900, height = 550, res = 120)
moy <- data_c %>% group_by(wave) %>%
  summarise(m = mean(polint), se = sd(polint) / sqrt(n()))
plot(moy$wave, moy$m, type = "b", pch = 19, ylim = range(moy$m + c(-2, 2) * moy$se),
     xlab = "Année", ylab = "Intérêt politique moyen (0-10)")
arrows(moy$wave, moy$m - 1.96 * moy$se, moy$wave, moy$m + 1.96 * moy$se,
       angle = 90, code = 3, length = 0.03)
abline(v = 2007.5, lty = 2)
dev.off()

# --------------------------------------------------------------
# 4. MODELES
# --------------------------------------------------------------
# 4.1 Modèle nul (composantes de variance) et ICC
m1 <- lmer(polint ~ 1 + (1 | IDPERS), data = data_c)
vc1 <- as.data.frame(VarCorr(m1))$vcov      # [1] inter, [2] résiduelle
ICC <- vc1[1] / sum(vc1)

# 4.2 Intercept aléatoire avec covariables
m2 <- lmer(polint ~ sex + cohort + age10 + log_income + polpos + eduyear +
             (1 | IDPERS), data = data_c)

# R2 inter et intra (même échantillon que m1)
vc2 <- as.data.frame(VarCorr(m2))$vcov
R2_inter <- (vc1[1] - vc2[1]) / vc1[1]
R2_intra <- (vc1[2] - vc2[2]) / vc1[2]

# 4.3 Variante : position politique "affirmée" (distance au centre)
m2b <- update(m2, . ~ . + polpos_ext)

# 4.4 Régression simple, effets fixes, between
pdat  <- pdata.frame(data_c, index = c("IDPERS", "wave"))
m_reg <- lm(polint ~ sex + cohort + age10 + log_income + polpos + eduyear,
            data = data_c)
m_fix <- plm(polint ~ cohort + age10 + log_income + polpos,
             data = pdat, model = "within")   # sex et eduyear : constants
m_bet <- plm(polint ~ sex + cohort + age10 + log_income + polpos + eduyear,
             data = pdat, model = "between")

# 4.5 Within-between : effets intra (e*) et inter (m*) séparés
m_wb <- lmer(polint ~ sex + cohort + mage + eage + mlinc + elinc +
               mpolpos + epolpos + eduyear + (1 | IDPERS), data = data_c)

# 4.6 Courbe de croissance : pente d'âge aléatoire
ctrl <- lmerControl(optimizer = "bobyqa")
m6 <- lmer(polint ~ 1 + cohort + mage + eage + (1 + eage | IDPERS),
           data = data_c, control = ctrl)
m7 <- lmer(polint ~ 1 + cohort + mage + eage + (1 | IDPERS), data = data_c)
test_pente <- anova(m6, m7)    # refit en ML : test de la pente aléatoire

# --------------------------------------------------------------
# 5. SORTIES
# --------------------------------------------------------------
sink("output/resultats_modeles.txt")
cat("Echantillon d'analyse :", nrow(data_c), "observations,",
    n_distinct(data_c$IDPERS), "personnes\n\n")
cat("== 1. Modèle nul ==\n");              print(summary(m1))
cat("\nICC =", round(ICC, 3), "\n")
cat("\n== 2. Intercept aléatoire ==\n");   print(summary(m2))
cat("\nR2 inter =", round(R2_inter, 3), " R2 intra =", round(R2_intra, 3), "\n")
cat("\n== 3. Position politique affirmée ==\n"); print(summary(m2b))
cat("\n== 4a. Régression simple ==\n");    print(summary(m_reg))
cat("\n== 4b. Effets fixes ==\n");         print(summary(m_fix))
cat("\n== 4c. Between ==\n");              print(summary(m_bet))
cat("\n== 5. Within-between ==\n");        print(summary(m_wb))
cat("\n== 6. Courbe de croissance ==\n");  print(summary(m6))
cat("\nTest de la pente aléatoire :\n");  print(test_pente)
sink()

if (requireNamespace("texreg", quietly = TRUE)) {
  texreg::htmlreg(list(WB = m_wb, Reg = m_reg, Fixed = m_fix, Between = m_bet),
                  file = "output/tableau_modeles.html")
}
writeLines(capture.output(sessionInfo()), "output/sessionInfo.txt")
cat("Terminé. Résultats dans output/\n")
