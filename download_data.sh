#!/usr/bin/env bash
# download_data.sh — Re-telecharge TOUS les jeux de donnees du projet PDAC v6
# depuis leurs sources publiques, et verifie taille + MD5/SHA-256.
# Usage : bash download_data.sh [dossier-destination, defaut : ./data]
# Les matrices brutes (~2 Go) ne sont pas dans ce depot GitHub (limite
# snapshot : fichiers UTF-8, 16 Mo maximum). Ce script est le moyen de les
# obtenir, verifiees. Chaque URL est exacte ; chaque hachage est celui qui
# figure dans les provenances (dossier provenance/) et dans l'annexe A du
# livre blanc PDF. Tout ecart = arreter et verifier la source.
# Requiert : curl, md5sum, sha256sum, python3 (pour les API figshare/Zenodo).
set -euo pipefail
DEST="${1:-./data}"
mkdir -p "$DEST" "$DEST/cptac" "$DEST/panc1_ncata"
FAIL=0

check() { # check <fichier> <taille> <md5|-> <sha256|->
  local f="$1" size="$2" md5="$3" sha="$4"
  local ok=1
  [ -f "$f" ] || { echo "MANQUANT : $f"; return 1; }
  local s; s=$(stat -c%s "$f")
  [ "$s" = "$size" ] || { echo "TAILLE INCORRECTE : $f ($s au lieu de $size)"; ok=0; }
  if [ "$md5" != "-" ]; then
    local m; m=$(md5sum "$f" | cut -d' ' -f1)
    [ "$m" = "$md5" ] || { echo "MD5 INCORRECT : $f ($m)"; ok=0; }
  fi
  if [ "$sha" != "-" ]; then
    local h; h=$(sha256sum "$f" | cut -d' ' -f1)
    [ "$h" = "$sha" ] || { echo "SHA-256 INCORRECT : $f"; ok=0; }
  fi
  if [ "$ok" = 1 ]; then echo "OK : $f"; else FAIL=1; return 1; fi
}

get() { # get <url> <destination>
  echo "Telechargement : $1"
  curl -L --fail --retry 3 -o "$2" "$1"
}

# ---------------------------------------------------------------- DepMap 24Q4
# Article figshare : https://doi.org/10.25452/figshare.plus.27993248.v1
get "https://ndownloader.figshare.com/files/51064667" "$DEST/CRISPRGeneEffect.csv"
check "$DEST/CRISPRGeneEffect.csv" 428678699 6edf7ade09b9b34199210b559d4745d3 3d8f3ec6dbf2db7ff834b79b508622ec0b226f3518003fe96ecf5a4fcf167e3b
get "https://ndownloader.figshare.com/files/51065297" "$DEST/Model.csv"
check "$DEST/Model.csv" 645696 675210d17675f3517b0ce39a3c274f16 b7a0c1385e6cef30132b56aff61f1261d11e3f490490b355c430d32ee0dbdcfa
get "https://api.figshare.com/v2/file/download/51065324" "$DEST/OmicsCNGene.csv"
check "$DEST/OmicsCNGene.csv" 1394554236 4696565fa74dc805983bc278b4a41802 4851d3e939d48837a39a0f01294deb90fa507a85703586a927b77474f999134c
get "https://ndownloader.figshare.com/files/51065741" "$DEST/OmicsSomaticMutationsMAFProfile.maf"
check "$DEST/OmicsSomaticMutationsMAFProfile.maf" 98439503 - 86b8530b31125305391dcffb7dffc5426535df63705a2bf76565368f3955e96f
get "https://ndownloader.figshare.com/files/51065750" "$DEST/OmicsSomaticMutationsMatrixHotspot.csv"
check "$DEST/OmicsSomaticMutationsMatrixHotspot.csv" 4210723 - 6444ce819a28d4228ff7b748e309611c5830c551620d8d2c7f86052e2675e3d8
get "https://ndownloader.figshare.com/files/51065723" "$DEST/OmicsProfiles.csv"
check "$DEST/OmicsProfiles.csv" 254733 - 0bb19ee57935d4b213d378a4db9caacaa1db7318a63ae81485d84f91c20a3bf2

# ------------------------------------------------- TCGA Firehose 2016-01-28
# https://gdac.broadinstitute.org/runs/stddata__2016_01_28/data/PAAD/20160128/
get "https://gdac.broadinstitute.org/runs/stddata__2016_01_28/data/PAAD/20160128/gdac.broadinstitute.org_PAAD.Merge_rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.Level_3.2016012800.0.0.tar.gz" "$DEST/tcga_paad_rsem.tar.gz"
check "$DEST/tcga_paad_rsem.tar.gz" 15296232 b09569ce3f4721f514bc137bd109ac0a -
get "https://gdac.broadinstitute.org/runs/stddata__2016_01_28/data/LUAD/20160128/gdac.broadinstitute.org_LUAD.Merge_rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.Level_3.2016012800.0.0.tar.gz" "$DEST/tcga_luad_rsem.tar.gz"
check "$DEST/tcga_luad_rsem.tar.gz" 47043687 4c36eec3f6df75630292c5a569cfc8f4 -
get "https://gdac.broadinstitute.org/runs/stddata__2016_01_28/data/COAD/20160128/gdac.broadinstitute.org_COAD.Merge_rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.Level_3.2016012800.0.0.tar.gz" "$DEST/tcga_coad_rsem.tar.gz"
check "$DEST/tcga_coad_rsem.tar.gz" 26401036 e703a630556d42f098cf0df87d4712bb -
get "https://gdac.broadinstitute.org/runs/analyses__2016_01_28/data/PAAD/20160128/gdac.broadinstitute.org_PAAD-TP.CopyNumber_Gistic2.Level_4.2016012800.0.0.tar.gz" "$DEST/tcga_paad_gistic.tar.gz"
check "$DEST/tcga_paad_gistic.tar.gz" 26189717 816034f742e8f89ca8734ca2cf4404d5 -

# ---------------------------------------------------------------- GEO
get "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE71nnn/GSE71729/matrix/GSE71729_series_matrix.txt.gz" "$DEST/GSE71729_series_matrix.txt.gz"
check "$DEST/GSE71729_series_matrix.txt.gz" 15622315 - b228789314ec4d866ec51b65724664abaa24b822577c55d3727820c867536a54
get "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE62nnn/GSE62452/matrix/GSE62452_series_matrix.txt.gz" "$DEST/GSE62452_series_matrix.txt.gz"
check "$DEST/GSE62452_series_matrix.txt.gz" 14447291 - 8f41d5b3f11451e653fd6bfc0c6b216c219d46711a7676d1e453dee16a078cba

# ---------------------------------------------------------------- ICGC / Xena
# Le portail ICGC DCC (https://dcc.icgc.org/) est mort (redirige vers
# l'accueil). Miroir qui fonctionne : UCSC Xena.
get "https://icgc-xena-hub.s3.amazonaws.com/download/PACA-AU/nature16965-s2_normalised_exp.txt.gz" "$DEST/icgc_pacaau_exp.txt.gz"
check "$DEST/icgc_pacaau_exp.txt.gz" 9841881 - c2cb57af3ba4c3d7fdac292e66c81067d36e16aae9efdd8005147e20820f49fa
get "https://static-content.springer.com/esm/art%3A10.1038%2Fnature16965/MediaObjects/41586_2016_BFnature16965_MOESM270_ESM.xlsx" "$DEST/bailey2016_suppl_tables1-13.xlsx"
check "$DEST/bailey2016_suppl_tables1-13.xlsx" 22104569 - 778224b36343c6c65b6df49b0149219ba2038cbdec2333b96e4e8798ff74258a

# ---------------------------------------------------------------- PRISM
# Primaire 24Q2, figshare article 25917643 :
# https://doi.org/10.6084/m9.figshare.25917643
get "https://ndownloader.figshare.com/files/46630984" "$DEST/Repurposing_Public_24Q2_Extended_Primary_Data_Matrix.csv"
check "$DEST/Repurposing_Public_24Q2_Extended_Primary_Data_Matrix.csv" 72456953 - -
get "https://ndownloader.figshare.com/files/46630981" "$DEST/Repurposing_Public_24Q2_Extended_Primary_Compound_List.csv"
check "$DEST/Repurposing_Public_24Q2_Extended_Primary_Compound_List.csv" 719567 - -
# Secondaire 19Q4, figshare article 9393293 (DOI 10.6084/m9.figshare.9393293.v4) :
# telecharge via l'API figshare (le portail DepMap/figshare bloque curl
# sans API ; l'API, elle, repond).
python3 - "$DEST" << 'PYEOF'
import json, subprocess, sys, hashlib
dest = sys.argv[1]
api = "https://api.figshare.com/v2/articles/9393293"
files = json.loads(subprocess.check_output(["curl", "-s", api]))["files"]
want = {
    "secondary-screen-dose-response-curve-parameters.csv": ("264340589", "e629b9d505ad3d6bf65fde96f1c54bee"),
    "secondary-screen-replicate-collapsed-treatment-info.csv": ("3788355", None),
}
for f in files:
    name = f["name"]
    if name in want:
        out = f"{dest}/{name}"
        print("Telechargement (API figshare) :", f["download_url"])
        subprocess.run(["curl", "-L", "--fail", "--retry", "3", "-o", out, f["download_url"]], check=True)
        size, md5 = want[name]
        got_size = str(__import__("os").path.getsize(out))
        assert got_size == size, f"taille {name} : {got_size} au lieu de {size}"
        if md5:
            h = hashlib.md5(open(out, "rb").read()).hexdigest()
            assert h == md5, f"MD5 {name} : {h}"
        print("OK :", out)
PYEOF

# ---------------------------------------------------------------- GDSC2
# Cell Model Passports (Sanger) : https://api.cellmodelpassports.sanger.ac.uk/download_files
get "https://cmp.cog.sanger.ac.uk/download/GDSC2_fitted_dose_response_27Oct23.xlsx" "$DEST/GDSC2_fitted_dose_response_27Oct23.xlsx"
check "$DEST/GDSC2_fitted_dose_response_27Oct23.xlsx" 22112537 - 0e99120a14a003dcbd3c27c020f1cfd35e38ee091067a2406f66c0d4dbc1c899
get "https://cmp.cog.sanger.ac.uk/download/screened_compounds_rel_8.5.csv" "$DEST/screened_compounds_rel_8.5.csv"
check "$DEST/screened_compounds_rel_8.5.csv" 46414 - d3cbb8b595980b36bf92d54af1da1dd995d2e2ce624c7cc70aacf2a754dce782

# ---------------------------------------------------------------- CPTAC
# Miroir Zenodo du paquet cptac, record 8394329 :
# https://doi.org/10.5281/zenodo.8394329 (etude PDC000393, Cao et al. Cell 2021).
# La matrice UMich locale (pdac_umich_protein_gene_matrix.csv) est DERIVEE :
# elle se reconstruit avec scripts/build_matrix_umich.py a partir du fichier
# Report ci-dessous.
python3 - "$DEST" << 'PYEOF'
import json, subprocess, sys, hashlib, os
dest = sys.argv[1]
api = "https://zenodo.org/api/records/8394329"
rec = json.loads(subprocess.check_output(["curl", "-s", api]))
by_name = {f["key"]: f for f in rec["files"]}
want = {
    "umich-pdac-proteomics-Report_abundance_groupby=protein_protNorm=MD_gu=2.tsv.gz": ("20504572", "a8c89b796b8ddacd48609e8ca7aac676"),
    "bcm-pdac-proteomics-PDAC_proteomics_gene_abundance_log2_reference_intensity_normalized_Tumor.txt.gz": ("7382441", "988150c28a2c1db14a3c0e62d08c06d2"),
    "umich-pdac-mapping-aliquot_to_patient_ID.tsv.gz": ("22881", "b013fad4a8f9fa26aa3915c0ef636754"),
    "cptac_genes.csv": ("462309", "afc250790ed6d18a7624a38fb872f62a"),
}
for name, (size, md5) in want.items():
    if name not in by_name:
        print("ABSENT du record Zenodo :", name); sys.exit(1)
    link = by_name[name]["links"]["self"]
    out = f"{dest}/cptac/{name}"
    print("Telechargement (Zenodo) :", name)
    subprocess.run(["curl", "-L", "--fail", "--retry", "3", "-o", out, link], check=True)
    assert str(os.path.getsize(out)) == size, f"taille {name}"
    h = hashlib.md5(open(out, "rb").read()).hexdigest()
    assert h == md5, f"MD5 {name} : {h}"
    print("OK :", out)
PYEOF

# ---------------------------------------------------------------- PANC-1
# Depot GitHub ncats/PANC1 : https://github.com/ncats/PANC1
get "https://codeload.github.com/ncats/PANC1/tar.gz/refs/heads/main" "$DEST/panc1_ncata/PANC1-main.tar.gz"
mkdir -p "$DEST/panc1_ncata/extract"
tar -xzf "$DEST/panc1_ncata/PANC1-main.tar.gz" -C "$DEST/panc1_ncata/extract" --strip-components=1
# Verification des 8 fichiers sources (SHA dans results/panc1_combinations_summary.csv
# et dans le dossier d'origine data/panc1_ncata/panc1_sha256.txt).
echo "PANC-1 extrait dans $DEST/panc1_ncata/extract — verifier les SHA avec :"
echo "  sha256sum $DEST/panc1_ncata/extract/*.csv"

if [ "$FAIL" = 1 ]; then echo "ECHEC : au moins une verification a echoue."; exit 1; fi
echo "TERMINE : tous les jeux de donnees telecharges et verifies dans $DEST"
echo "Etapes suivantes : construire les flux (scripts/build_fluxes_*.py),"
echo "puis lancer le pipeline v6 (voir README.md)."
