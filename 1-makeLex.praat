form Make lex from POS
  word word_tiername dismo-tok-mwu
  word pos_tiername dismo-pos-mwu
  word lex_tiername lex
endform

verbose=0

clearinfo
ntg=numberOfSelected("TextGrid")
for i to ntg
  t'i'ID=selected("TextGrid",i)
  t'i'$=selected$("TextGrid",i)
endfor

for itg to ntg

  thisID=t'itg'ID
  tg$=t'itg'$
  select thisID
printline 'tg$'
call findtierbyname2 0 posTID 'pos_tiername$'
call findtierbyname2 0 lexTID 'lex_tiername$'
if lexTID!=0
  Remove tier... lexTID
endif
lexTID=posTID+1
Duplicate tier... posTID lexTID 'lex_tiername$'
call findtierbyname2 0 wordTID 'word_tiername$'

nWords=Get number of intervals... posTID
for iWord to nWords
  pos$=Get label of interval... posTID iWord
  if pos$="_"
    Set interval text... lexTID iWord _
  elsif pos$=""
    printline empty word 'iWord'
  else
    pos3$=left$(pos$,3)
    if iWord<nWords
      posnext$=Get label of interval... posTID iWord+1
    else
      posnext$=""
    endif
    pos3next$=left$(posnext$,3)
    if (pos3$="ADJ" and pos3next$!="NOM")or pos3$="ADV" or pos3$="NOM" or pos3$="FRG" or pos3$="INT" or (pos3$="VER" and index(pos$,"aux")==0)
      Set interval text... lexTID iWord *
	  lex=1
	else
      Set interval text... lexTID iWord
      lex=0
    endif
  endif
endfor
endfor

procedure findtierbyname2 .verbose .var$ .name$
  .n = Get number of tiers
  '.var$' = 0
  .i=1
  while .i<=.n
    .tmp$ = Get tier name... '.i'
    #printline +'.tmp$'+'.name$'+
    if .tmp$ =.name$
      '.var$' = .i
      if .verbose
        printline Tier '.name$' found in TextGrid : '.i' 
      endif
    endif
    .i=.i+1
  endwhile
endproc
