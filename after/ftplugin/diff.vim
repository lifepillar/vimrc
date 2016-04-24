fun! BuildDiffStatusLine(nr)
  return '%{SetupStl('.a:nr.')}
        \%#CurrMode#%{w:["lf_active"] ? "  Diff " : ""}%*
        \%{w:["lf_active"] ? "" : "  Diff"}
        \ %<%{t:diffpanel.GetStatusLine()} %*'
endf

if exists("g:default_stl")
  setlocal statusline=%!BuildDiffStatusLine(winnr())
endif

