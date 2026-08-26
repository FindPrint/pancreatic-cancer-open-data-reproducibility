# Reproductibilité sur données ouvertes — cancer du pancréas

> **Avertissement médical.** Ce dépôt organise une recherche rétrospective sur données ouvertes et dé-identifiées. Il ne produit ni diagnostic, ni pronostic individuel, ni recommandation thérapeutique et ne constitue pas un dispositif médical.

## Objet du projet

Ce dépôt est séparé du projet Apamea. Il évalue si les principes de **traçabilité**, de **robustesse par exclusions** et de **validation inter-cohortes** peuvent être adaptés à un pilote transcriptomique de recherche sur le cancer du pancréas.

Le projet ne transfère pas le pipeline v2/v3 Apamea à des patients. En particulier, aucun scan de seuil Monte Carlo, aucune partition pré/post et aucun score CSD/F1′/F2″ n’est utilisé comme outil biomédical.

## État actuel

| Élément | Statut |
| --- | --- |
| Cadre de sécurité non clinique | Établi. |
| Registre des cohortes ouvertes candidates | Établi. |
| Compatibilité du pipeline Apamea | Évaluée : traçabilité transférable, code analytique non transférable tel quel. |
| Protocole de pilote transcriptomique | Préparé, sans téléchargement de données individuelles. |
| Données de patients | Aucune donnée téléchargée, copiée ou versionnée. |
| Modèle clinique ou recommandation de traitement | Explicitement hors périmètre. |

## Choix de pilote recommandé

Le premier pilote proposé utilise **MetaGxPancreas** sous une version figée, pour tester de manière rétrospective et descriptive la stabilité inter-cohortes d’une association transcriptomique pré-spécifiée avec la survie globale. Il s’agit d’une question de recherche, pas d’une prédiction patient.

Le protocole impose une validation leave-one-cohort-out, l’absence de fuite de cohortes d’évaluation, des analyses de sensibilité, des intervalles d’incertitude et un rapport des échecs de généralisation. Les cadres TRIPOD+AI, PROBAST+AI et REMARK guident la transparence et le contrôle du biais.

## Arborescence

```text
README.md
docs/
  data-governance/   # limites cliniques, protection et règles de données
  methodology/       # sources et compatibilité Apamea–oncologie
  protocol/          # protocole pré-spécifié du pilote
  reports/           # rapports versionnés
scripts/             # scripts futurs, distincts de v2/v3
 data/manifests/     # versions, licences et checksums autorisés
 data/external-links/# références aux ressources sans copier les données
results/             # résultats agrégés, exploratoires et de validation
release-assets/      # archives vérifiables autorisées
```

## Règles non négociables

1. Le dépôt reste **privé** par défaut.
2. Aucune donnée brute de patient, donnée identifiante ou donnée sous accès contrôlé ne doit être committée.
3. Toute donnée utilisée doit être associée à une source, une version, des conditions d’accès et une empreinte lorsque disponible.
4. Toute adaptation de méthode est séparée du code Apamea et documentée avant exécution.
5. Une cohorte tenue à l’écart de l’évaluation ne peut jamais servir au choix de variables, au réglage ou à la normalisation globale.
6. Aucun résultat ne sera formulé comme une indication de traitement, de diagnostic ou de pronostic individuel.

## Documents de départ

- [Cadre de sécurité](docs/data-governance/CADRE_SECURITE_PROJET_ONCOLOGIE_PANCREAS.md)
- [Registre des sources ouvertes](docs/methodology/REGISTRE_SOURCES_OUVERTES_CANCER_PANCREAS.md)
- [Compatibilité Apamea–oncologie](docs/methodology/ANALYSE_COMPATIBILITE_PIPELINE_APAMEA_ONCOLOGIE.md)
- [Protocole pilote](docs/protocol/PROTOCOLE_PILOTE_NON_CLINIQUE_PANCREAS_TRANSCRIPTOMIQUE.md)

## Licence et données

Le code de ce dépôt ne confère aucun droit sur les ressources externes. Chaque source conserve ses conditions d’accès, citation et licence propres. Le fichier [`LICENSE_OR_DATA_NOTICES.md`](LICENSE_OR_DATA_NOTICES.md) doit être mis à jour avant l’utilisation de toute nouvelle source.
