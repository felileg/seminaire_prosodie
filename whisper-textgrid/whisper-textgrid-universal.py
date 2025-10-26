import os
import subprocess
import pandas as pd
from praatio import textgrid
import tkinter as tk
from tkinter import filedialog, messagebox, simpledialog

# Initialiser Tkinter (fenêtre cachée)
root = tk.Tk()
root.withdraw()

# Demander a l'utilisateurice le fichier a traiter et les paramètres

audio_file = filedialog.askopenfilename(
    title="Choisir un fichier audio",
    filetypes=[("Fichiers audio", "*.wav *.mp3 *.flac *.m4a *.ogg"), ("Tous les fichiers", "*.*")]
)

if not audio_file:
    messagebox.showwarning("Annulé", "Aucun fichier sélectionné.")
    exit()

audio_language = simpledialog.askstring("Langue de l'audio","Langue de l'audio\n(Format: fr, en, de, ...)")

if not audio_language:
    messagebox.showwarning("Annulé", "Aucune langue sélectionnée.")
    exit()

# Lancer Whisper
subprocess.run([
    "whisper", audio_file,
    "--language", audio_language,
    "--output_format", "tsv"
], check=True)

# Vérifier le TSV produit
tsv_file = os.path.splitext(audio_file)[0] + ".tsv"
if not os.path.exists(tsv_file):
    messagebox.showerror("Erreur", f"Fichier TSV introuvable : {tsv_file}")
    exit()

# Charger et convertir
df = pd.read_csv(tsv_file, sep="\t")
entries = [(row.start / 1000, row.end / 1000, str(row.text)) for _, row in df.iterrows()]

tier = textgrid.IntervalTier("ortho", entries, 0, df.end.max() / 1000)
tg = textgrid.Textgrid()
tg.addTier(tier)
tg.save(os.path.splitext(audio_file)[0] + ".TextGrid", format="short_textgrid", includeBlankSpaces=True)

# Fin
messagebox.showinfo("Terminé", "Conversion terminée.\nFichier : whisper.TextGrid")
