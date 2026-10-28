# ==============================================================
# Simulation d'un panel qui imite la structure des données réelles
# (une ligne par personne et par année, personnes suivies sur
# plusieurs années, intérêt politique noté de 0 à 10).
# Les valeurs sont inventées : elles servent à faire tourner le code.
# ==============================================================

set.seed(2026)
n <- 3000

personnes <- data.frame(
  IDPERS  = 1:n,
  sex     = sample(c("man", "woman"), n, replace = TRUE, prob = c(0.47, 0.53)),
  entree  = sample(1999:2012, n, replace = TRUE),
  eduyear = pmin(21, pmax(8, round(rnorm(n, 13.5, 3)))),
  u_int   = rnorm(n, 0, 2.1),   # écart durable de chaque personne
  u_pol   = rnorm(n, 0, 1.6),   # position politique de base
  u_inc   = rnorm(n, 0, 0.5),   # niveau de revenu de base
  u_age   = rnorm(n, 0, 0.025)  # pente d'âge propre à chaque personne
)
personnes$naissance <- personnes$entree - sample(18:75, n, replace = TRUE)
personnes$n_vagues  <- pmin(2020 - personnes$entree + 1,
                            sample(3:15, n, replace = TRUE))

# Une ligne par personne et par année
panel <- do.call(rbind, lapply(seq_len(n), function(i) {
  p <- personnes[i, ]
  data.frame(IDPERS = p$IDPERS, wave = p$entree + seq_len(p$n_vagues) - 1)
}))
panel <- merge(panel, personnes, by = "IDPERS")
panel$age <- panel$wave - panel$naissance
N <- nrow(panel)

panel$income <- round(exp(10.7 + panel$u_inc +
                          0.25 * (panel$sex == "man") +
                          0.012 * (panel$age - 40) + rnorm(N, 0, 0.3)))
panel$polpos <- pmin(10, pmax(0, round(5 + panel$u_pol + rnorm(N, 0, 0.8))))

latent <- 5.0 -
  0.9  * (panel$sex == "woman") +
  (0.03 + panel$u_age) * (panel$age - 18) +
  0.15 * (panel$eduyear - 13) -
  0.25 * (panel$wave >= 2008) +
  0.01 * panel$polpos +
  panel$u_int + rnorm(N, 0, 1.3)
panel$polint <- pmin(10, pmax(0, round(latent)))

# Valeurs manquantes aléatoires (comme dans une vraie enquête)
panel$income[sample(N, round(0.12 * N))] <- NA
panel$polpos[sample(N, round(0.08 * N))] <- NA

panel <- panel[order(panel$IDPERS, panel$wave),
               c("IDPERS", "wave", "polint", "sex", "age",
                 "income", "polpos", "eduyear")]

dir.create("data", showWarnings = FALSE)
write.csv(panel, "data/panel_simule.csv", row.names = FALSE)
cat("Fichier écrit : data/panel_simule.csv (", N, "lignes,", n, "personnes )\n")
