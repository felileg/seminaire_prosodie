form Make AP tier from LEX
  word lex_tiername lex
  word ap_tiername AP
  word ss_tiername ss
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

  call findtierbyname2 1 apTID 'ap_tiername$'
  if apTID!=0
    Remove tier... apTID
  endif
  call findtierbyname2 1 lexTID 'lex_tiername$'
  apTID=lexTID+1
  Duplicate tier... lexTID apTID 'ap_tiername$'
  call findtierbyname2 1 ssTID 'ss_tiername$'

  
  
  
  nAP=Get number of intervals... apTID
  for i to nAP
    ap$=Get label of interval... apTID i
    if ap$="_"
      sp=Get starting point... apTID i
      intSS = Get interval at time... ssTID sp
      spss=Get starting point... ssTID intSS
      if spss<sp
        Set interval text... apTID i
      endif
    endif
  endfor

  nAP=Get number of intervals... apTID
  nAP=nAP-1
  while nAP>0
    ap$=Get label of interval... apTID nAP
    apn$=Get label of interval... apTID nAP+1
    if ap$="" and (apn$="" or apn$="*")
      Remove right boundary... apTID nAP
    endif
    nAP=nAP-1
  endwhile

  #blank * AP labels 
  nAP=Get number of intervals... apTID
  for i to nAP
    ap$=Get label of interval... apTID i
    if ap$="*"
      Set interval text... apTID i
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


