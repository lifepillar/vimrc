fun! BuildQuickfixStatusLine(nr)
  return '%{SetupStl('.a:nr.')}
        \%#CurrMode# %q %#SepMode#%{w:["active"] ? g:left_sep_sym : ""}%*
        \ %<%{get(w:, "quickfix_title", "")}
        \ %=
        \ %#SepMode#%{w:["active"] && w:["winwd"] >= 60 ? g:right_sep_sym : ""}
        \%#CurrMode#%{w:["winwd"] < 60 ? "" : g:pad . printf(" %d line%s", line("$"), line("$") > 1 ? "s " : " ")}%*'
endf

setlocal statusline=%!BuildQuickfixStatusLine(winnr())

