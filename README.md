# PDAC v6 — À la recherche d'un remède pour le cancer du pancréas

**Travail non clinique, bénévole, sans financement, sur données publiques.**
Ce dépôt contient tout le travail reproductible du projet PDAC v6 (15–16
novembre 2026) : livre blanc, scripts, provenances, résultats. Le livre
blanc complet (PDF) est partagé séparément ; sa source Markdown est ici
(`livre-blanc-pdac-v6.md`).

**Le pipeline lui-même n'est pas ici** : il est dans le dépôt privé
[FindPrint/Code](https://github.com/FindPrint/Code)
(`universal_v6.0.0_cohen.py`, v6.0.0-L7aL7b-CohenD, SHA-256
`bb8bbdba4eb1f8c55b49748274ae8fbfef8a43f6c1b890964f18ba77960c0773`).
Le pipeline reste privé et n'est jamais commercialisé.

## En une phrase — état au 16 novembre 2026

Parmi les ~12 patients dont la tumeur exprime le plus KRAS, **CA125
(MUC16) et CEA (CEACAM5) sont élevés** — confirmé en expression dans
**3 cohortes sur 4** (TCGA, GSE71729, GSE62452 oui ; ICGC non), et CA125
prédit une survie plus courte dans **2 cohortes sur 3** (TCGA : Cox 1,44
univarié ; ICGC : quartile 9,5 contre 23,8 mois, p = 0,002, Cox 1,57).

**Avance clinique réelle, trouvée hors pipeline :** le daraxonrasib
(pan-RAS, approuvé par la FDA le 26 août 2026) double la survie médiane
en phase III (13,2 contre 6,7 mois, HR 0,40 — O'Reilly et al.,
*N Engl J Med* 2026, https://doi.org/10.1056/NEJMoa2605555).
**Piste la plus solide du projet :** vopimetostat + daraxonrasib, 82 % de
réponses (18/22) chez les patients MTAP-délétés prétraités (phase 1/2,
non randomisée ; phase 3 prévue 1er semestre 2027), avec un appui mesuré
(dépendance PRMT5 plus forte en pancréas, p = 0,0036).
**Seule piste ouverte :** ATR seul (hypothèse d'expression, sans appui
CRISPR ni médicament).

**Ce n'est pas un remède démontré.** Rien ici ne guérit, ne recommande un
traitement et ne remplace un avis médical. Les négatifs sont tous notés :
effondrement TCGA non répliqué, CRISPR des 12 gènes négatif, trois
criblages de médicaments négatifs, CPTAC négatif, MUC16 comme cible
négatif, zolbetuximab en échec randomisé, MEK + autophagie et MEK + CDK4/6
en échecs cliniques, KRAS + anti-PD-(L)1 et KRAS + PARP non soutenus.

## Contenu du dépôt

| Dossier / fichier | Contenu |
|---|---|
| `livre-blanc-pdac-v6.md` | Texte intégral du livre blanc (§1–§10, §8.1–§8.28, §7, journal) |
| `README.md` | Ce fichier |
| `download_data.sh` | Re-télécharge toutes les matrices brutes (~2 Go) avec vérification MD5/SHA-256 |
| `scripts/` | Les 41 scripts Python + 6 lanceurs `.sh` (construction des flux, criblages, survie, balayage) |
| `provenance/` | Les 25 fichiers `PROVENANCE_*.md` intégraux + `PROTOCOL_pancancer.md` |
| `rapports/` | Les 13 rapports détaillés + `source_registry.md` (189 sources, toutes avec liens) |
| `results/` | Flux CSV (52), tests directs, criblages complets (GDSC2 269 composés, PRISM 6 790, secondaire 1 427, CRISPR 17 916 gènes), PANC-1 (496 paires), résultats de survie |
| `pdf-build/` | `build_pdf.py` + `build_appendix.py` — la chaîne qui construit le PDF depuis le Markdown |

## Reproduire

```bash
# 1. Données brutes (~2 Go, vérifiées)
bash download_data.sh ./data

# 2. Construire les flux (exemple TCGA v4)
python3 scripts/build_fluxes_tcga_v4.py

# 3. Lancer le pipeline v6 (mode fast, ~4 min, minimum 50 points)
python3 /chemin/vers/universal_v6.0.0_cohen.py \
  --input results/pdac_tcga_fluxes_v4.csv --output results_fast_tcga_v4 \
  --mode fast --control_col step --target_col PGC

# 4. Nul (lignes permutées, graine 42) : même commande avec le CSV _nul
```

Le pipeline ne voit jamais la température ni la vérité terrain : l'ordre
des lignes est la seule information d'ordonnancement. Toute traduction en
température ou comparaison à une valeur critique se fait après le run,
dans le harnais, sans retour dans les paramètres.

## Ce qui n'est PAS dans ce dépôt, et pourquoi

- **Les matrices brutes (~2 Go)** : limite snapshot GitHub (fichiers UTF-8,
  16 Mo maximum). Elles se re-téléchargent vérifiées avec
  `download_data.sh` (URL + MD5/SHA exacts dans `provenance/` et dans
  l'annexe A du PDF).
- **Le PDF du livre blanc (binaire)** : il ne peut pas être poussé dans
  l'arbre snapshot. Il est partageable depuis l'espace de travail ; sa
  source Markdown et sa chaîne de construction sont ici.
- **Les sorties complètes des runs** (670 figures PNG, fichiers `df_feat`,
  journaux) : 15 figures qui portent un verdict sont dans le PDF
  (annexe E) ; le reste se reproduit par les commandes ci-dessus.

## Règles du projet

- **Provenance toujours nommée** : source complète, nature des lignes,
  comment chaque valeur a été produite, hachages, ce qui manque.
- **Chaque source porte son lien** : voir `rapports/source_registry.md`
  (189 sources ; 17 sans URL vérifiable, déclarées comme telles avec la
  raison — résumés de congrès sans DOI, communiqués non retrouvés,
  citations incomplètes).
- **Aucun résultat négatif caché** ; un nul qui invalide une piste est un
  résultat.
- **Le pipeline est aveugle** : il ne connaît rien de la science du
  système ; les connaissances scientifiques sont des hypothèses à tester,
  jamais des verdicts à imposer.

## Sources principales (liens complets dans `rapports/source_registry.md`)

- DepMap Public 24Q4 : https://doi.org/10.25452/figshare.plus.27993248.v1
- TCGA Firehose 2016-01-28 : https://gdac.broadinstitute.org/runs/stddata__2016_01_28/data/PAAD/20160128/
- GEO GSE71729 : https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE71729
- GEO GSE62452 : https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE62452
- ICGC PACA-AU via UCSC Xena (portail ICGC DCC mort) : https://xenabrowser.net/datapages/?cohort=PACA-AU
- CPTAC PDC000393, miroir Zenodo : https://zenodo.org/records/8394329
- PRISM primaire : https://doi.org/10.6084/m9.figshare.25917643
- PRISM secondaire : https://doi.org/10.6084/m9.figshare.9393293.v4
- GDSC2 : https://api.cellmodelpassports.sanger.ac.uk/download_files
- PANC-1 (NCATS) : https://github.com/ncats/PANC1
- RASolute-302 (daraxonrasib, phase III) : https://doi.org/10.1056/NEJMoa2605555
- Approbation FDA du daraxonrasib : https://www.fda.gov/news-events/press-announcements/fda-approves-first-class-targeted-therapy-metastatic-pancreatic-cancer
