fun! BuildUndotreeStatusLine(nr)
  return '%{SetupStl('.a:nr.')}
        \%#CurrMode#%{w:["lf_active"] ? "  Undotree " : ""}
        \%#SepMode#%{w:["lf_active"] ? g:left_sep_sym : ""}%*
        \%{w:["lf_active"] ? "" : "  Undotree"}
        \ %<%{t:undotree.GetStatusLine()} %*'
endf

if exists("g:default_stl")
  setlocal statusline=%!BuildUndotreeStatusLine(winnr())
endif

