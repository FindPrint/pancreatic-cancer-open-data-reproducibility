# Avis sur les données, licences et accès

Ce dépôt ne contient initialement **aucune donnée patient**. Il ne contient que de la documentation de faisabilité, des protocoles et des références à des ressources externes.

## Règle de non-inclusion

Les éléments suivants sont interdits dans Git et dans les assets de release, sauf validation écrite spécifique de leur licence et de leur gouvernance :

- données individuelles, identifiants, dates ou métadonnées ré-identifiantes ;
- fichiers issus de dbGaP, EGA, ICGC ARGO ou de tout accès contrôlé ;
- imagerie DICOM ou lames dont les conditions de diffusion n’ont pas été vérifiées ;
- données locales, dossiers médicaux, résultats de patients ou informations de contact ;
- tokens, identifiants de connexion et fichiers d’environnement.

## Ressources externes candidates

| Ressource | Rôle envisagé | Statut à vérifier avant usage |
| --- | --- | --- |
| MetaGxPancreas / Bioconductor | Pilote transcriptomique multi-cohortes. | Version, contenu exact d’ExperimentHub, provenance des cohortes, citation et compatibilité des conditions des sources primaires. |
| TCGA-PAAD / GDC | Réplication ou étude de sensibilité. | Type de fichier, statut ouvert/contrôlé, version GDC, notices de redaction et citation. |
| CPTAC-PDA / TCIA | Projet multimodal ultérieur. | Licence par ressource, volume, données cliniques, règles d’attribution et formats. |
| PGPA / ICGC historiques | Source de vérification et possible validation externe. | Disponibilité effective de fichiers, conditions d’accès, version figée et citation. |

Toute utilisation de données devra être enregistrée dans `data/manifests/` avec : URL/DOI, date d’accès, version, licence, checksum, types de données et restriction connue. Aucune source ne doit être téléchargée au seul motif qu’elle est référencée ici.
