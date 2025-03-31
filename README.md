# Édition numérique des correspondances de Mgr Paul Rémond

Ce projet propose une édition numérique des correspondances de Monseigneur Paul Rémond (1873-1963), évêque de Nice de 1930 à 1963. L'édition est basée sur les documents conservés aux Archives historiques du diocèse de Nice (FR AEC / 06 - SC2 2R6, 2).

## Présentation du projet

Cette édition numérique permet de consulter, explorer et analyser les correspondances de Mgr Paul Rémond, une figure importante de l'Église catholique française durant la première moitié du XXe siècle. Évêque de Nice, il s'est particulièrement distingué pendant la Seconde Guerre mondiale par son engagement dans la Résistance et son action pour sauver des enfants juifs.

## Fonctionnalités

- **Page d'accueil** avec biographie de Mgr Paul Rémond et liste des correspondances classées par année
- **Consultation des lettres** avec mise en page soignée et navigation intuitive
- **Visualisation des entités nommées** (personnes, lieux, organisations) avec système de surlignage interactif
- **Index des personnes**, des lieux et des organisations mentionnés dans les correspondances
- **Navigation contextuelle** entre les différentes parties de l'édition

## Structure technique

### Technologies utilisées

- **XML-TEI** : Encodage des textes selon les recommandations de la Text Encoding Initiative
- **XSLT 2.0** : Transformation des fichiers XML en sites web HTML
- **HTML/CSS** : Interface utilisateur
- **JavaScript** : Interactions dynamiques (filtres, accordéons, affichage des informations sur les entités)

### Organisation des fichiers

- `correpondance_paul_remond.xsl` : Feuille de transformation XSLT principale
- `output/` : Dossier contenant les fichiers HTML générés
  - `index.html` : Page d'accueil avec biographie et liste des correspondances
  - `lettre_*.html` : Pages individuelles pour chaque lettre
  - `index_personnes.html`, `index_lieux.html`, `index_organisations.html` : Pages d'index
- `static/` : Ressources statiques
  - `css/styles.css` : Feuille de styles CSS
  - `js/main.js` : Fonctionnalités JavaScript
  - `images/` : Images et illustrations

## Caractéristiques de l'édition

### Traitement des entités nommées

L'édition permet d'identifier et d'explorer les entités nommées présentes dans les correspondances :
- Personnes (avec informations biographiques)
- Lieux (avec descriptions)
- Organisations (avec descriptions)

Chaque entité nommée est cliquable dans le texte et peut être mise en évidence grâce à un système de filtres interactifs.

## Droits et licence

Cette édition numérique est soumise aux conditions spécifiées dans le fichier TEI source. Les documents sont conservés aux Archives historiques du diocèse de Nice.

## Auteur

Amélie Dogan - Master 2 "Technologies numériques appliquées à l'histoire" à l'Ecole nationale des chartes

## Remerciements

- Archives historiques du diocèse de Nice pour l'accès aux documents originaux
- Jean-Damien Généro pour son cours portant sur le XSLT
- Katarzyna Kapitan pour son cours portant sur XML-TEI

---

Pour toute question ou suggestion concernant cette édition numérique, n'hésitez pas à ouvrir une issue sur ce dépôt GitHub.
