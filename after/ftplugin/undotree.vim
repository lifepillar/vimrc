fun! BuildUndotreeStatusLine(nr)
  return '%{SetupStl('.a:nr.')}
        \%#CurrMode#%{w:["lf_active"] ? "  Undotree " : ""}
        \%#SepMode#%{w:["lf_active"] ? g:left_sep_sym : ""}%*
        \%{w:["lf_active"] ? "" : "  Undotree"}
        \ %<%{t:undotree.GetStatusLine()} %*'
endf

setlocal statusline=%!BuildUndotreeStatusLine(winnr())

