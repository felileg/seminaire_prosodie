import pandas
from praatio import textgrid

# Charger le TSV
df = pandas.read_csv("whisper.tsv", sep="\t")

# Créer la liste d'intervalles (start et end en secondes)
entries = [(row.start / 1000, row.end / 1000, str(row.text)) for _, row in df.iterrows()]

# Créer la tier
tier = textgrid.IntervalTier("ortho", entries, 0, df.end.max() / 1000)

# Créer le TextGrid et ajouter la tier
tg = textgrid.Textgrid()
tg.addTier(tier)

# Sauvegarde du TextGrid
tg.save("whisper.TextGrid", format="short_textgrid", includeBlankSpaces="true")
