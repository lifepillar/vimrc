fun! BuildQuickfixStatusLine(nr)
  return '%{SetupStl('.a:nr.')}
        \%#CurrMode#%{w:["lf_active"] ? "  QUICKFIX " : ""}%*
        \%{w:["lf_active"] ? "" : "  QUICKFIX"}
        \ %<%{get(w:, "quickfix_title", "")}
        \ %=
        \ %q
        \ %#CurrMode#%{w:["lf_active"] ? (w:["lf_winwd"] < 60 ? "" :  printf(" %d line%s", line("$"), line("$") > 1 ? "s " : " ")) : ""}%*'
endf

if exists("g:default_stl")
  setlocal statusline=%!BuildQuickfixStatusLine(winnr())
endif

nnoremap <silent> <buffer> q <c-w><c-p>@=winnr("#")<cr><c-w>c

