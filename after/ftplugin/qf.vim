fun! LFQuickfixNumLines()
  return w:["lf_winwd"] >= 60 ? printf(" %d line%s", line("$"), line("$") > 1 ? "s " : " ") : ""
endf


if exists("*getwininfo")

  fun! LFQuickfixTag()
    return get(getwininfo(win_getid())[0], "loclist", 0) ? "  LOCLIST " : "  QUICKFIX "
  endf

else

  fun! LFQuickfixTag()
    return '  QUICKFIX '
  endf

endif

  fun! BuildQuickfixStatusLine(nr)
    return '%{SetupStl('.a:nr.')}%#CurrMode#
          \%{w:["lf_active"] ? LFQuickfixTag() : "" }%*
          \%{w:["lf_active"] ? "" : LFQuickfixTag()}
          \ %{winnr()}  %<%{get(w:, "quickfix_title", "")}
          \ %= %q %{LFQuickfixNumLines()}'
  endf

if exists("g:default_stl")
  setlocal statusline=%!BuildQuickfixStatusLine(winnr())
endif

