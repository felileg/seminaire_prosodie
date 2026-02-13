form Analyse de la vitesse d'articulation
    sentence dossier /chemin/vers/tes/fichiers/
    integer tier_syllabes 1
endform

clearinfo

# --- Sécurité : Correction du chemin ---
si_slash$ = right$(dossier$, 1)
if si_slash$ != "/" and si_slash$ != "\"
    dossier$ = dossier$ + "/"
endif

# --- Préparation du fichier CSV ---
csv_file$ = dossier$ + "resultats_articulation.csv"
filedelete 'csv_file$'
# En-tête du CSV (utilisation du point-virgule pour Excel français)
header$ = "Fichier;Duree_Totale;Duree_Pauses;Duree_Articulee;Nb_Syllabes;Dur_Moy_Syll_sec;Syll_par_seconde" + newline$
fileappend "'csv_file$'" 'header$'

# --- Création de la liste ---
Create Strings as file list: "liste", dossier$ + "*.TextGrid"
n = Get number of strings

printline Analyse de 'n' fichiers en cours...

for i from 1 to n
    selectObject: "Strings liste"
    nom$ = Get string: i
    Read from file: dossier$ + nom$
    tg = selected("TextGrid")
    
    d_pauses = 0
    nb_syll = 0
    d_totale = Get total duration
    nb_inter = Get number of intervals: tier_syllabes
    
    for j from 1 to nb_inter
        label$ = Get label of interval: tier_syllabes, j
        start = Get start time of interval: tier_syllabes, j
        end = Get end time of interval: tier_syllabes, j
        d_inter = end - start
        
        if label$ = "_" or label$ = "<p:>" or label$ = "<dis>"
            d_pauses = d_pauses + d_inter
        elsif label$ != ""
            nb_syll = nb_syll + 1
        endif
    endfor
    
    d_articulee = d_totale - d_pauses
    
    if nb_syll > 0 and d_articulee > 0
        moy_syll = d_articulee / nb_syll
        syll_sec = nb_syll / d_articulee
    else
        moy_syll = 0
        syll_sec = 0
    endif
    
    # --- Écriture dans le CSV ---
    # On remplace les points par des virgules pour Excel FR si nécessaire, 
    # mais ici on reste en format standard point pour la compatibilité logicielle
    ligne$ = "'nom$';'d_totale:3';'d_pauses:3';'d_articulee:3';'nb_syll';'moy_syll:4';'syll_sec:2'" + newline$
    fileappend "'csv_file$'" 'ligne$'
    
    selectObject: tg
    Remove
endfor

selectObject: "Strings liste"
Remove
printline Terminé. Le fichier est ici : 
printline 'csv_file$'
