# Durée du mariage avant le divorce : des différences de genre ?

Analyse de survie sur les données du Panel suisse de ménages (SHP)

## Introduction

Les hommes et les femmes divorcent-ils après la même durée de mariage ? Cette question aide à comprendre si la fragilité des unions se joue de la même façon pour les deux sexes. Festy et Kortchagina (2002) montrent que les hommes et les femmes décrivent leur mariage et leur divorce de façon proche, même si leurs réponses ne sont pas toujours cohérentes entre elles.

Les données viennent du Panel suisse de ménages (SHP, observation jusqu'en 2013). La population d'analyse regroupe les personnes de plus de 18 ans dont le mariage et le divorce sont tous deux datés. Elle compte 496 personnes (215 hommes et 281 femmes). L'événement est le premier divorce.

La durée est le nombre d'années entre le mariage et le divorce. Les durées négatives, qui sont des incohérences de dates, et les durées nulles ont été retirées. Dans cette base, seules les personnes divorcées ont une durée. Il n'y a donc aucune donnée censurée. L'analyse décrit le moment du divorce parmi les personnes divorcées. Elle ne dit pas qui divorce ni qui reste marié. La section « Limites » revient sur ce point.

## Analyse descriptive

Les courbes de la figure 1 donnent, pour chaque durée de mariage, la proportion de mariages qui ne sont pas encore dissous. La moitié des mariages qui finissent en divorce sont dissous avant 11,5 ans. Les courbes des hommes et des femmes sont très proches.

| Groupe | Effectif | Durée médiane (années) | Intervalle de confiance à 95 % |
|---|---|---|---|
| Hommes | 215 | 11 | 10 à 13 |
| Femmes | 281 | 12 | 11 à 14 |
| Ensemble | 496 | 11,5 | 11 à 13 |

*Tableau 1. Durée médiane du mariage avant le divorce, parmi les personnes divorcées. Source : SHP.*

Les intervalles de confiance des deux groupes se recoupent largement. Le test du log-rank le confirme (χ² = 0,2, 1 degré de liberté, p = 0,6). On ne rejette donc pas l'hypothèse d'égalité des courbes. Les données ne montrent pas de différence de durée entre les hommes et les femmes.

Visuellement, les hommes semblent divorcer un peu plus vite entre 8 et 15 ans de mariage, et les femmes un peu plus vite entre 22 et 27 ans. Ces écarts sont faibles et le test ne les confirme pas. Il faut les lire comme de simples tendances.

*Figure 1. Proportion de mariages non encore dissous selon la durée du mariage, par sexe (courbes de Kaplan-Meier, en bleu les hommes, en rouge les femmes).*

## Modèle

J'ai estimé des modèles de Cox, en temps continu. Le modèle 1 ne contient que le sexe. Le modèle 2 ajoute trois variables de contrôle :

- l'âge en 2013, qui reflète la génération et représente la temporalité du processus ;
- l'âge au premier enfant, car la parentalité peut influencer la stabilité du couple ;
- l'âge à la première opération, qui renvoie à la santé.

Ces trois variables mesurent des étapes de la vie qui sont liées au mariage et au divorce. Les rapports de risque correspondent à une année d'âge supplémentaire.

| | Modèle 1 (n = 496) | Modèle 2 (n = 277) |
|---|---|---|
| Femme (réf. : homme) | 0,96 [0,80 ; 1,15] | 0,94 [0,73 ; 1,22] |
| Âge en 2013 | | 1,00 [0,98 ; 1,03] |
| Âge au premier enfant | | 1,04 [1,01 ; 1,07] |
| Âge à la première opération | | 1,01 [1,00 ; 1,02] |

*Tableau 2. Rapports de risque de divorce (intervalle de confiance à 95 %), parmi les personnes divorcées. Un rapport supérieur à 1 indique un divorce plus rapide. Source : SHP.*

Le sexe n'a pas d'effet significatif, ni seul (p = 0,63) ni avec les contrôles (p = 0,66). L'âge au premier enfant et l'âge à la première opération sont associés à un divorce plus rapide. Chaque année d'âge en plus au premier enfant augmente le risque de 4 %, et chaque année en plus à la première opération l'augmente de 1 %.

Les deux modèles ne reposent pas sur les mêmes personnes. Le modèle 2 ne garde que les 277 personnes qui ont une valeur pour l'âge au premier enfant et l'âge à la première opération. Sa concordance (0,62) ne se compare donc pas à celle du modèle 1 (0,51), ni les tests de vraisemblance.

**Proportionnalité des risques.** Les résidus de Schoenfeld ne montrent pas de tendance dans le temps. Le test ne rejette pas la proportionnalité, ni pour le modèle 1 (p = 0,89), ni pour le modèle 2 (test global p = 0,46). L'âge en 2013 (p = 0,10) et l'âge au premier enfant (p = 0,07) sont à la limite. Le modèle stratifié par sexe donne des courbes presque confondues sur le graphique en log-log. Les deux groupes ont donc des risques très proches et parallèles.

**Interaction avec le temps.** L'interaction entre le sexe et la durée est proche de zéro (rapport de risque de 1,00 par année, p = 0,91). Rien ne montre que l'écart entre hommes et femmes change au fil du mariage.

## Conclusion

Parmi les personnes divorcées, les hommes et les femmes ont une durée de mariage proche, avec une médiane de 11 ans pour les hommes et de 12 ans pour les femmes. L'écart n'est pas significatif et ne varie pas avec la durée. Les âges au premier enfant et à la première opération sont les seules variables associées au moment du divorce. Ce résultat va dans le même sens que Festy et Kortchagina (2002), qui trouvent des récits très proches chez les deux sexes, même si leur étude porte sur la Russie et sur la cohérence des réponses.

## Limites

L'analyse ne concerne que les personnes divorcées. Les personnes encore mariées n'ont pas de durée dans cette base. Les résultats décrivent donc le moment du divorce, pas le risque de divorcer. Les médianes sont sans doute plus courtes que celles d'une population complète, qui inclurait les mariages encore en cours (données censurées). Une analyse sur l'ensemble des personnes mariées demande une base qui garde ces personnes.

Le modèle 2 repose sur 277 personnes seulement, car l'âge au premier enfant et l'âge à la première opération sont manquants pour les autres. Ces âges peuvent aussi tomber après le divorce, ce qui limite l'interprétation du lien avec la durée du mariage. Une version plus rigoureuse utiliserait des variables qui varient dans le temps.

## Bibliographie

Festy, P., & Kortchagina, I. (2002). Un mariage, deux divorces ? Cohérence et incohérences des réponses masculines et féminines à des enquêtes sur le divorce en Russie. *Population*, 57(1), 11-33. https://doi.org/10.3917/popu.201.0011
