fun! BuildDiffStatusLine(nr)
  return '%{SetupStl('.a:nr.')}%#CurrMode# Diff
        \ %#SepMode#%{w:["active"] ? g:left_sep_sym : ""}%*
        \ %<%{exists('*t:diffpanel.GetStatusLine') ? t:diffpanel.GetStatusLine() : ""} %*'
endf

setlocal statusline=%!BuildDiffStatusLine(winnr())

