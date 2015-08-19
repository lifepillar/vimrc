fun! BuildUndotreeStatusLine(nr)
  return '%{SetupStl('.a:nr.')}%#CurrMode# Undotree
        \ %#SepMode#%{w:["lf_active"] ? g:left_sep_sym : ""}%*
        \ %<%{t:undotree.GetStatusLine()} %*'
endf

setlocal statusline=%!BuildUndotreeStatusLine(winnr())

