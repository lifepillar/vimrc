fun! BuildQuickfixStatusLine(nr)
  return '%{SetupStl('.a:nr.')}
        \%#CurrMode#%{w:["lf_active"] ? "  " . get(g:mode_map, mode(1), ["?"])[0] . (&paste ? " PASTE " : " ") : ""}
        \%#SepMode#%{w:["lf_active"] ? g:left_sep_sym : ""}%*
        \ %<%{get(w:, "quickfix_title", "")}
        \ %=
        \ %q
        \ %#SepMode#%{w:["lf_active"] && w:["lf_winwd"] >= 60 ? g:right_sep_sym : ""}
        \%#CurrMode#%{w:["lf_active"] ? (w:["lf_winwd"] < 60 ? "" : g:pad . printf(" %d line%s", line("$"), line("$") > 1 ? "s " : " ")) : ""}%*'
endf

setlocal statusline=%!BuildQuickfixStatusLine(winnr())

