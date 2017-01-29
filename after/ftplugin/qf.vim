fun! LFQuickfixNumLines()
  return w:["lf_winwd"] >= 60 ? printf(" %d line%s", line("$"), line("$") > 1 ? "s " : " ") : ""
endf

if exists("*getwininfo")

  fun! BuildQuickfixStatusLine(nr)
    return '%{SetupStl('.a:nr.')}
          \%#CurrMode#%{w:["lf_active"]
          \ ? get(getwininfo(win_getid())[0], "loclist", 0) ? "  LOCLIST " : "  QUICKFIX "
          \ : "" }%*
          \%{w:["lf_active"]
          \ ? "" : get(getwininfo(win_getid())[0], "loclist", 0) ? "  LOCLIST " : "  QUICKFIX "}
          \ %<%{get(w:, "quickfix_title", "")}
          \ %=
          \ %#CurrMode#%{w:["lf_active"] ? LFQuickfixNumLines() : ""}%*%{w:["lf_active"] ? "" : LFQuickfixNumLines()}'
  endf

else

  fun! BuildQuickfixStatusLine(nr)
    return '%{SetupStl('.a:nr.')}
          \%#CurrMode#%{w:["lf_active"] ? "  QUICKFIX " : ""}%*
          \%{w:["lf_active"] ? "" : "  QUICKFIX "}
          \ %<%{get(w:, "quickfix_title", "")}
          \ %=
          \ %q
          \ %#CurrMode#%{w:["lf_active"] ? LFQuickfixNumLines() : ""}%*%{w:["lf_active"] ? "" : LFQuickfixNumLines()}'
  endf

end

if exists("g:default_stl")
  setlocal statusline=%!BuildQuickfixStatusLine(winnr())
endif
