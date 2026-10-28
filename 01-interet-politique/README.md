# Intérêt politique : analyse longitudinale (modèles multiniveaux)

Travail de séminaire d'analyse longitudinale, Master en Histoire économique internationale, Université de Genève.

## Question de recherche

L'intérêt politique des personnes en âge de voter a-t-il évolué entre 1999-2007 et 2008-2022 ? Quelle part des différences vient des individus eux-mêmes, et quelle part des changements au fil du temps ?

## Données

* Panel individuel suivi sur plusieurs années, environ 190 000 observations pour 29 600 personnes (travail original).
* Variable étudiée : intérêt politique (échelle de 0 à 10).
* Variables explicatives : sexe, âge, revenu, position gauche-droite, années d'éducation, période (1999-2007 ou 2008-2022).
* Les données d'origine sont soumises à licence et ne sont pas publiées ici. Elles s'obtiennent auprès de l'organisme producteur du panel (Swiss Household Panel, FORS).
* Le dossier `data/` contient un **jeu simulé** qui reprend la structure du panel. Il permet de faire tourner tout le code. Ses valeurs sont inventées : les résultats qu'il produit ne sont pas des résultats de recherche.

## Méthodes

1. Statistiques descriptives
2. Modèle nul à composantes de variance et ICC
3. Modèle à intercept aléatoire avec covariables, R² inter et intra
4. Régression simple, effets fixes, modèle between
5. Modèle within-between (effets intra et inter individuels séparés)
6. Courbe de croissance avec pente d'âge aléatoire et test de comparaison de modèles

Outils : R (`lme4`, `lmerTest`, `plm`, `dplyr`, `psych`).

## Résultats du travail original (données réelles)

* Modèle nul : ICC de 0,78. Environ trois quarts de la variance de l'intérêt politique se situent entre les individus.
* Les femmes ont un intérêt politique plus faible que les hommes.
* L'intérêt politique augmente avec l'âge et avec le nombre d'années d'éducation.
* L'intérêt est plus faible après 2008, ce qui est une association entre la période et l'intérêt, pas une preuve de l'effet de la crise économique.
* La pente d'âge varie selon les individus (test de comparaison de modèles significatif).

Les sorties R d'origine sont dans `resultats_reels/` et le rapport complet dans `rapport/`.

## Reproduire l'analyse

Depuis ce dossier :

```r
install.packages(c("dplyr", "lme4", "lmerTest", "plm", "psych"))
source("code/00_simuler_donnees.R")   # crée data/panel_simule.csv
source("code/01_modeles.R")           # estime les modèles, écrit output/
```

Pour utiliser les vraies données, placer un fichier au même format (colonnes `IDPERS, wave, polint, sex, age, income, polpos, eduyear`) et changer le chemin dans `code/01_modeles.R`.

## Améliorations apportées au code par rapport au rendu original

* Tous les modèles sont estimés sur le même échantillon, ce qui rend les comparaisons et les R² valides.
* Âge recentré et réduit, revenu en logarithme : modèles plus stables.
* Position politique : ajout d'une mesure de position affirmée (distance au centre de l'échelle).
* Courbe de croissance estimée avec un optimiseur adapté.

Ces changements n'ont été testés que sur le jeu simulé.

## Structure

```
01-interet-politique/
├── code/               scripts R
├── data/               jeu simulé (pas de données réelles)
├── output/             sorties produites par le code sur le jeu simulé
├── resultats_reels/    captures des sorties du travail original
└── rapport/            rapport (PDF)
```
