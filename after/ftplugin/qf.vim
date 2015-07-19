func! SetupQfStl(nr)
    exec 'hi! link CurrMode ' . ((winnr() == a:nr) ? get(g:mode_map, mode(1), ['','Warnings'])[1] : 'StatusLineNC')
    return get(extend(w:, {"winwd": winwidth(winnr())}), '', '')
endfunc

func! BuildQuickfixStatusLine(nr)
  return '%{SetupQfStl('.a:nr.')}%#CurrMode# %q %* %<%{get(w:, "quickfix_title", "")}%=
        \ %#CurrMode#%{w:["winwd"] < 60 ? "" : printf(" %d line%s", line("$"), line("$") > 1 ? "s " : " ")}%*'
endfunc

setlocal statusline=%!BuildQuickfixStatusLine(winnr())

