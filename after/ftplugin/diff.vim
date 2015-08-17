fun! BuildDiffStatusLine(nr)
  return '%{SetupStl('.a:nr.')}%#CurrMode# Diff
        \ %#SepMode#%{w:["active"] ? g:left_sep_sym : ""}%*
        \ %<%{t:diffpanel.GetStatusLine()} %*'
endf

setlocal statusline=%!BuildDiffStatusLine(winnr())

