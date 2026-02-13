import os
import subprocess
import pandas as pd
from praatio import textgrid
import tkinter as tk
from tkinter import filedialog, messagebox, simpledialog

# Interface Tkinter
root = tk.Tk() # initialise
root.withdraw() # cache la fenêtre racine
root.option_add("*font", "monospace 12")  # style de tous les widgets enfants


# Demande a l'utilisateurice le fichier a traiter et les paramètres

audio_file = filedialog.askopenfilename(
    title="Choisir un fichier audio",
    filetypes=[("Fichiers audio", "*.wav *.mp3 *.flac *.m4a *.ogg"), ("Tous les fichiers", "*.*")])
if not audio_file:
    messagebox.showwarning("Annulé", "Aucun fichier sélectionné.")
    exit()

audio_language = simpledialog.askstring("Langue de l'audio","Format: fr, en, de, ...\n\nPar défaut: détection automatique")
if not audio_language:
    messagebox.showinfo("Détection auto", "Aucune langue sélectionnée. Détection automatique")

whisper_model = simpledialog.askstring("Modèle de transcription","Valeurs: tiny, base, small, medium, large-v1,\nlarge-v2, large-v3, large-v3-turbo, turbo, ...\n\nPar défaut: small\n\nAttention: le chargement d'un autre modèle que\n'small' peut demander beaucoup de temps et de\nbande-passante lors de la première utilisation")
if not whisper_model:
    messagebox.showinfo("Modèle par défaut", "Aucun modèle sélectionné. Modèle par défaut sélectionné: small")

# Crée un sous processus de Whisper-Ctranslate2
whisper_process = ([
    "whisper-ctranslate2", audio_file,
    "--output_dir", os.path.dirname(audio_file),
    "--output_format", "tsv"
])

# Y ajoute, si ils existent, les arguments facultatifs
if audio_language:
    whisper_process.extend(["--language", audio_language])
if whisper_model:
    whisper_process.extend(["--model", whisper_model])

# Lance le sous-processus
subprocess.run(whisper_process)

# Vérifie le TSV produit
tsv_file = os.path.splitext(audio_file)[0] + ".tsv"
if not os.path.exists(tsv_file):
    messagebox.showerror("Erreur", f"Fichier TSV introuvable à l'adresse {os.path.dirname(tsv_file)}")
    exit()

# Charge TSV et convertit en TextGrid
df = pd.read_csv(tsv_file, sep="\t")
entries = [(row.start / 1000, row.end / 1000, str(row.text)) for _, row in df.iterrows()]

tier = textgrid.IntervalTier("ortho", entries, 0, df.end.max() / 1000)
tg = textgrid.Textgrid()
tg.addTier(tier)
tg.save(os.path.splitext(audio_file)[0] + ".TextGrid", format="short_textgrid", includeBlankSpaces=True)

# Fin
messagebox.showinfo("Terminé", f"Conversion terminée.\nTextGrid : {os.path.splitext(audio_file)[0]}.TextGrid")
