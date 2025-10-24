# Traitement prosodique : la totale

## Transcription large
**But** : obtenir une tier grossièrement segmentée (**unités de parole** séparées par des pauses) avec une **transcription orthographique**.

### Façon simple
→ Faire à la main une transcription grossière dans une tier `ortho`.

### Façon technique (Whisper)
À terme, fait gagner du temps, mais demande une certaine mise en place :

- Installer whisper en python (dans un terminal : `pip install openai-whisper`)
- Exécuter dans un terminal : `whisper NOM_DU_FICHIER.extension --language fr --output_format tsv`
- Renommer le fichier de sortie en `whisper.tsv`
- Ouvrir `tsv-to-textgrid.py` et l'exécuter (*Run* > *Run Module* ou `Fn + F5`) → un fichier `whisper.TextGrid` est créé
- Ouvrir dans Praat et contrôler la segmentation et la transcription.


## Segmentation automatique dans MAUS
**But** : transcrire en phonétique, découper finement en syllabes et en phonèmes.

- Aller sur [WebMAUS](https://clarin.phonetik.uni-muenchen.de/BASWebServices/interface/WebMAUSGeneral)
- Menu à gauche (*show service sidebar*) > *Pipeline without ASR*
- Sélectionner *le fichier audio* et *la TextGrid* **du même nom**
- *Upload*
- Pipeline : `CHUNKPREP → G2P → MAUS → PHO2SYL`
- Déplier *Expert Options*
- *Input tier name* : `ortho`
- *Output Encoding* : `IPA`
- *Run web service*
- Télécharger la TextGrid
- Ouvrir dans Praat et contrôler la segmentation.
- Renommer les tiers :
	- `ORT-MAU` (mots isolés) → `words`
	- `KAN-MAU` et `KAS-MAU` → supprimer
	- `MAU` (phonèmes en API) → `phones`
	- `MAS` (syllabes en API) → `syll`
	- `TRN` (groupes prosodiques) → `ortho`.

**Résultat**: une TextGrid avec 4 niveaux d'analyse: groupe prosodique, mot, syllabe et phonème.

*Note: MAUS permet techniquement de faire en une seule étape **la transcription** et **la segmentation**. Pour cela, il faut sélectionner* Pipeline without ASR *dans le menu de gauche (show service sidebar) et s'identifier avec son université. Le résultat est cependant médiocre par rapport à Whisper + MAUS*

*Note 2: on peut aussi segmenter automatiquement directement dans Praat (sélectionner l'intervalle et `Ctrl + D`). Le résultat est cependant mauvais par rapport à MAUS.*


## Calculer les variables temporelles

**But** : analyse chiffrée du débit de parole (rapport phonèmes/groupes prosodiques)

**Prérequis** : le fichier qu'on vient de créer avec MAUS, soit une TextGrid avec une tier pour les **groupes prosodiques** (unités de paroles séparées par des pauses) et une autre pour les **syllabes**.

- Contrôler que le son et la TextGrid ont le même nom (à part l'extension)
- Ouvrir Praat
- *Praat* > *Open Praat script...* > sélectionner le script *variables_temporelles*
- *Run* > *Run* ou `Ctrl + R`
- Remplir : 
	- Dossier : adresse du **répertoire** dans lequel se trouve la TextGrid (pas l'adresse du fichier)
	- Numéros des tiers :
		1. *groupes prosodiques*: position de la tier `ortho` (en l'occurrence *2*)
		2. *syllabes*: position de la tier `syll` (en l'occurrence *4*)

