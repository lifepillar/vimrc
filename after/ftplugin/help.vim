  fun! BuildHelpStatusLine(nr)
    return '%{SetupStl('.a:nr.')}
          \%#CurrMode#%{w:["lf_active"] ? "  HELP " : ""}%*
          \%{w:["lf_active"] ? "" : "  HELP"}
          \ %t
          \ %=
          \ %#CurrMode#%{w:["lf_active"] && w:["lf_winwd"] >= 60 ? printf(" %d:%-2d %2d%% ", line("."), virtcol("."), 100 * line(".") / line("$")) : ""}%*'
  endf

if exists("g:default_stl")
  setlocal statusline=%!BuildHelpStatusLine(winnr())
endif

nnoremap <silent> <buffer> q <c-w><c-p>@=winnr("#")<cr><c-w>c

