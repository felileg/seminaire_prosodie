# Traitement prosodique : la totale

## 1) Transcription
**But** : obtenir une tier grossièrement segmentée (les **unités de parole** séparées par des **pauses**) avec une **transcription orthographique**.

### Façon simple
Faire à la main une transcription grossière dans une tier `ortho`.

### Façon technique (Whisper)
À terme, fait gagner du temps, mais demande une certaine mise en place :

- Si ce n'est pas déjà fait, **[installer Python](https://www.python.org/downloads/)** avec son IDLE
- **Installer les dépendances** : dans un terminal, exécuter `pip install openai-whisper praatio`
	- Les utilisateur·ices de Windows doivent aussi exécuter `winget install ffmpeg`
- Télécharger le script **[whisper-textgrid.py](whisper-textgrid/whisper-textgrid-universal.py)** et le mettre dans le même dossier que le fichier audio
- Ouvrir le script (par défaut avec *python IDLE*) et **l'exécuter** (*Run > Run Module*)
- Renseigner le fichier audio et la langue de transcription et **patienter**  
→ une TextGrid est créée dans le dossier!
- Ouvrir dans Praat et contrôler la segmentation et la transcription.

## 2) Segmentation

**But** : transcrire en phonétique, découper finement en syllabes et en phonèmes.

**Prérequis** : le fichier qu'on vient de créer, soit une TextGrid avec une tier `ortho` contenant une transcription orthographique des unités de parole.

---
<br>

- Aller sur [WebMAUS](https://clarin.phonetik.uni-muenchen.de/BASWebServices/interface/WebMAUSGeneral)
- Menu à gauche (*show service sidebar*) > *Pipeline **without** ASR*
- Sélectionner **le fichier audio et la TextGrid du même nom**
- *Upload*
- Pipeline : `CHUNKPREP → G2P → MAUS → PHO2SYL`
- Déplier *Expert Options*
- *Input tier name* : `ortho`
- *Output Encoding* : `IPA`
- Accepter les conditions et *Run web service*
- Télécharger la TextGrid
- L'ouvrir dans Praat et contrôler la segmentation.
- Renommer les tiers :
	- `ORT-MAU` (mots isolés) → `words`
	- `KAN-MAU` et `KAS-MAU` → supprimer
	- `MAU` (phonèmes en API) → `phones`
	- `MAS` (syllabes en API) → `syll`
	- `TRN` (groupes prosodiques) → `ortho`.

**Résultat**: une TextGrid avec 4 niveaux d'analyse: groupe prosodique, mot, syllabe et phonème.

<br>

*Note: MAUS permet de faire en une seule étape la transcription et la segmentation. Pour cela, il faut sélectionner* Pipeline **with** ASR *dans le menu de gauche* (show service sidebar) *et s'identifier avec son université. Le résultat est cependant médiocre par rapport à Whisper + MAUS ou segmentation manuelle + MAUS.*

*Note 2: Praat permet aussi de segmenter automatiquement à partir d'une transcription orthographique (sélectionner l'intervalle puis `Ctrl + D`). Le résultat est cependant médiocre par rapport à MAUS.*


## 3) Calcul des variables temporelles (facultatif pour l'exercice du 19 octobre)

**But** : analyse chiffrée du débit de parole (rapport phonèmes/groupes prosodiques)

**Prérequis** : la TextGrid créée à l'aide de MAUS, contenant une tier pour les **groupes prosodiques** (unités de paroles séparées par des pauses) et une autre pour les **syllabes**.

---
<br>

- Contrôler que le son et la TextGrid ont le même nom (à part l'extension)
- Ouvrir Praat
- *Praat* > *Open Praat script...* > sélectionner le script **variables temporelles** ([MacOS/Linux](praat_scripts/variables_temporelles_MAC_LINUX.praat), [Windows](praat_scripts/variables_temporelles_WIN.praat))
- *Run* > *Run* ou `Ctrl + R`
- Remplir : 
	- Dossier : adresse du **répertoire** dans lequel se trouve la TextGrid (pas l'adresse du fichier)
	- Numéros des tiers :
		1. *groupes prosodiques*: position de la tier `ortho` (en l'occurrence *2*)
		2. *syllabes*: position de la tier `syll` (en l'occurrence *4*)


**Résultat** : trois fichiers .txt

## 4) Annotation des proéminences

**Prérequis** : 
- la TextGrid créée à l'aide de MAUS, contenant une tier pour les **syllabes**.
- le programme **Analor** :
	- Si ce n'est pas déjà fait, installer l'[environnement Java](https://adoptium.net/fr/temurin/releases?version=21&os=any&arch=any) 
	- Télécharger [Analor](https://www.lattice.cnrs.fr/ressources/logiciels/analor/) au format `.jar`
	- Ouvrir `Analor 0.0.jar` avec Java/JRE.

---
<br>

- Dupliquer la tier `syll` (*Tier > Duplicate Tier...*) en l'appelant `prom`
- Nettoyer la tier `prom` nouvellement créée (*Tier > Remove all text from tier*)
- Dans la tier `prom`, noter **les pauses** par **_**

<br>

1) D'abord, analyse **perceptive des proéminences**

- Masquer les analyses visuelles (*Analyses > Show analyses* > tout décocher)
- Sélectionner un intervalle de 3-4 secondes et tenter de percevoir à l'oreille les proéminences (généralement signalées par des allongements et des variations de pitch)
- Noter les **proéminences principales** par **`P`**, les **proéminences secondaires** par **`p`**, les **disfluences** (hésitations, bégayements, interruptions, etc.) par **`H`**, sans oublier d'indiquer les **pauses** par un **`_`**.

2) **Analyse automatique avec Analor**


- 
