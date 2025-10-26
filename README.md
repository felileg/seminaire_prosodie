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

**Prérequis** : la TextGrid qu'on vient de créer, avec une tier `ortho` contenant une transcription orthographique des unités de parole.

---

Sur [WebMAUS](https://clarin.phonetik.uni-muenchen.de/BASWebServices/interface/WebMAUSGeneral) :
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

---

*Note 1 : MAUS permet de faire en une seule étape la transcription et la segmentation. Pour cela, il faut sélectionner* Pipeline **with** ASR. *Le résultat est cependant médiocre par rapport à Whisper + MAUS ou segmentation manuelle + MAUS.*

*Note 2 : Praat permet aussi de segmenter automatiquement à partir d'une transcription orthographique (sélectionner l'intervalle puis `Ctrl + D`). Le résultat est cependant médiocre par rapport à MAUS.*


## 3) Calcul des variables temporelles (facultatif pour l'exercice du 19 octobre)

**But** : analyse chiffrée du débit de parole (rapport phonèmes/groupes prosodiques)

**Prérequis** : la TextGrid créée à l'aide de MAUS, contenant une tier pour les **groupes prosodiques** (unités de paroles séparées par des pauses) et une autre pour les **syllabes**.

---

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
	- Télécharger l'exécutable d'[Analor](https://www.lattice.cnrs.fr/ressources/logiciels/analor/)
	- Ouvrir `Analor 0.0.jar` avec Java/JRE/JDK.

---

1) **Préparer la TextGrid**

Dans Praat :
- Dupliquer la tier `syll` (*Tier > Duplicate Tier...*) en l'appelant `prom`
- Nettoyer la tier `prom` nouvellement créée (*Tier > Remove all text from tier*)
- Dans la tier `prom`, noter **les pauses** par **_**

---

2) **Analyse perceptive des proéminences**

Dans Praat : 
- Masquer les analyses visuelles (*Analyses > Show analyses* > tout décocher)
- Sélectionner un intervalle de 3-4 secondes et tenter de percevoir à l'oreille les proéminences (généralement signalées par des allongements et des variations de pitch)
- Noter les **proéminences principales** par **`P`**, les **proéminences secondaires** par **`p`**, les **disfluences** (hésitations, bégayements, interruptions, etc.) par **`H`**, sans oublier d'indiquer les **pauses** par un **`_`**.
- Enregistrer la TextGrid

---

3) **Export**

Dans Praat Objects :

- Sélectionner **le son**
	- *To Intensity...*
		- (Laisser les paramètres par défaut et cliquer OK)
		- *Down to IntensityTier*
- Resélectionner le son
	- *Analyse periodicity > To Pitch (filtered autocorrelation)*
		- (Laisser les paramètres par défaut et cliquer OK)
		- *Convert > Down to PitchTier*

Il y a maintenant 6 objets, dont on peut supprimer *Intensity* et *Pitch*, en gardant ***Sound***, ***TextGrid***, ***IntensityTier*** et ***PitchTier***.

**Sélectionner ces 4 fichiers** et les **exporter au format binaire** (*Save > Save as binary file...*)

---

4) **Analyse automatique avec Analor**

**But** : détection des proéminences acoustiques effectives selon des critères empiriques (les analyses sonores qu'on a exportées depuis Praat).

- Ouvrir `Analor 0.0.jar` avec Java/JRE/JDK
- *Documents > Importer un document Praat...*
- Sélectionner le fichier `.collection` 
- *Paramétrage > Gestion des paramètres* > onglet *Proéminences*
- Remplir comme suit :
	- *Nom de la tire indiquant les phonèmes* : `phones`
	- *Nom de la tire indiquant les syllabes* : `syll`
	- *Nom de la tire indiquant les disfluences* : `prom`
	- *Marques de proéminence* : `p;P`
	- Laisser par défaut les autres paramètres (marques de pause, tire des proéminences de référence)
	- Valider
- *Proéminences > Détecter les proéminences*  
→ une tier `prom-analor` est créée
- *Documents > Exporter un document Praat*
- Exporter le documment `.collection`
- Rouvrir dans Praat, contrôler le résultat et enregistrer la TextGrid

---

5) **Analyse syntaxique avec Dismo**

**Ce que ça fait** : analyse syntaxique de la tier `words`, pour pouvoir plus tard détecter les **groupes clitiques**. Les groupes clitiques sont une **notion syntaxique théorique, et pas directement prosodique** : ils représentent l'unité sur laquelle **peut** tomber l'acccent.

Dans DisMo : 
- *File > Add file to the corpus* : choisir la TextGrid comportant la tier `prom-analor` 
- Cocher toutes les cases dans *Annotation options*
- *→ Annotate!*  
→ une nouvelle TextGrid est créée, contenant les annotations syntaxiques


6) **Mise en évidence des groupes clitiques** avec des scripts Praat

**Ce que ça fait** : utilise les étiquettes syntaxiques générées par DisMo pour détecter les noyaux des groupes clitiques.

Dans Praat:
- Importer la TextGrid générée par DisMo
- Supprimer les tiers inutiles : `dismo-discourse`, `dismo-boundaries`, `dismo-tok-min`, `dismo-pos-min`, `dismo-disfluences`

<br>

- *Praat > Open Praat script...* > choisir `1-makeLex.praat`
- Exécuter le script (`Ctrl + R`)
- Garder les options par défaut et confirmer  
→ une nouvelle tier `lex` est créée, contenant les noyaux des groupes clitiques (places où peut tomber l'accent) indiquées par `*`.

<br>

- *Praat > Open Praat script...* > choisir `2-makeAP.praat`
- Exécuter le script (`Ctrl + R`)
- Remplir comme suit :
	- *ap tiername* : `GC`
	- *ss tiername* : `ortho`
- Confirmer  
→ une nouvelle tier `lex` est créée, délimitant les groupes clitiques

