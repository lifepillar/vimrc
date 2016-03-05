fun! BuildQuickfixStatusLine(nr)
  return '%{SetupStl('.a:nr.')}
        \%#CurrMode#%{w:["lf_active"] ? "  QUICKFIX " : ""}
        \%#SepMode#%{w:["lf_active"] ? g:left_sep_sym : ""}%*
        \%{w:["lf_active"] ? "" : "  QUICKFIX"}
        \ %<%{get(w:, "quickfix_title", "")}
        \ %=
        \ %q
        \ %#SepMode#%{w:["lf_active"] && w:["lf_winwd"] >= 60 ? g:right_sep_sym : ""}
        \%#CurrMode#%{w:["lf_active"] ? (w:["lf_winwd"] < 60 ? "" : g:pad . printf(" %d line%s", line("$"), line("$") > 1 ? "s " : " ")) : ""}%*'
endf

if exists("g:default_stl")
  setlocal statusline=%!BuildQuickfixStatusLine(winnr())
endif

nnoremap <silent> <buffer> q <c-w>c

