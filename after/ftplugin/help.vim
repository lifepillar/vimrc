fun! BuildHelpStatusLine(nr)
  return '%{SetupStl('.a:nr.')}
        \%#CurrMode#%{w:["lf_active"] ? "  HELP " : ""}%*
        \%{w:["lf_active"] ? "" : "  HELP "} %{winnr()} %t (%n) %= %l:%v %P '
endf

if exists("g:default_stl")
  setlocal statusline=%!BuildHelpStatusLine(winnr())
endif
