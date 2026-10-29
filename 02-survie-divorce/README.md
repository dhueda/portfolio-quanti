# Durée du mariage avant le divorce : analyse de survie

Travail pratique du cours d'Analyse de données longitudinales, Master en Histoire économique internationale, Université de Genève (printemps 2024).

## Question de recherche

Parmi les personnes divorcées, la durée du mariage avant le divorce diffère-t-elle selon le sexe ?

## Données

- Base d'événements du Panel suisse de ménages (SHP) fournie par le cours : 496 personnes divorcées (215 hommes, 281 femmes), observation jusqu'en 2013.
- Variable étudiée : durée du mariage en années, du mariage au premier divorce.
- Variable clé : sexe. Contrôles : âge en 2013, âge au premier enfant, âge à la première opération.
- Les données d'origine sont soumises à licence et ne sont pas publiées ici. Elles s'obtiennent auprès de l'organisme producteur du panel (Swiss Household Panel, FORS).
- Le dossier `data/` contient un jeu simulé qui reprend la structure de la base. Il permet de faire tourner le code. Ses valeurs sont inventées : les résultats qu'il produit ne sont pas des résultats de recherche.

## Méthodes

- Courbes de survie de Kaplan-Meier, médianes et intervalles de confiance
- Test du log-rank pour comparer les sexes
- Modèles de Cox (sexe seul, puis avec contrôles), modèle stratifié par sexe
- Test de proportionnalité des risques (résidus de Schoenfeld)
- Interaction du sexe avec le temps

Outils : R (package survival).

## Résultats du travail original (données réelles)

- Durée médiane du mariage avant le divorce : 11 ans pour les hommes, 12 ans pour les femmes (11,5 ans au total). Le test du log-rank ne montre pas de différence (p = 0,6).
- Le sexe n'est pas associé à la durée du mariage dans les modèles de Cox, avec ou sans contrôles.
- L'âge au premier enfant et l'âge à la première opération sont associés à un divorce plus rapide.
- Les risques sont proportionnels, et l'effet du sexe ne change pas avec la durée du mariage.

Les sorties R d'origine sont dans `resultats_reels/` et le rapport complet dans `rapport/`.

## Limites

- Les personnes non divorcées n'ont pas de durée dans la base d'origine. L'analyse décrit donc le moment du divorce parmi les divorcés, pas le risque de divorcer.
- Le modèle avec contrôles repose sur 277 personnes, car l'âge au premier enfant et l'âge à la première opération sont manquants pour les autres.

## Reproduire l'analyse

Depuis ce dossier :

```r
install.packages("survival")
source("code/00_simuler_donnees.R")   # crée data/panel_simule.csv
source("code/01_survie_divorce.R")    # estime les modèles, écrit output/
```

Pour utiliser les vraies données, placer un fichier au même format (colonnes BIRTHYR, SEX13, married, divorced, FirstChild, operation) et changer le chemin dans `code/01_survie_divorce.R`.

## Structure

```
02-survie-divorce/
├── code/               scripts R
├── data/               jeu simulé (pas de données réelles)
├── output/             figures produites par le code
├── resultats_reels/    sorties du travail original
└── rapport/            rapport
```
