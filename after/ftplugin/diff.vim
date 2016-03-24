fun! BuildDiffStatusLine(nr)
  return '%{SetupStl('.a:nr.')}
        \%#CurrMode#%{w:["lf_active"] ? "  Diff " : ""}
        \%#SepMode#%{w:["lf_active"] ? g:left_sep_sym : ""}%*
        \%{w:["lf_active"] ? "" : "  Diff"}
        \ %<%{t:diffpanel.GetStatusLine()} %*'
endf

if exists("g:default_stl")
  setlocal statusline=%!BuildDiffStatusLine(winnr())
endif

