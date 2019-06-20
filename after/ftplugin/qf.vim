if has('patch-8.1.1372') " Has g:statusline_winid
  fun! LFQuickfixNumLines()
    return winwidth(0) >= 60 ? printf(" %d line%s", line("$"), line("$") > 1 ? "s " : " ") : ""
  endf

  fun! LFBuildQuickfixStatusLine()
    return '%#'.LFStlHighlight().'# '
          \ . (get(getwininfo(win_getid())[0], "loclist", 0) ? "LOCLIST" : "QUICKFIX")
          \ . ' %* %{winnr()}  %<%{get(w:, "quickfix_title", "")} %= %q %{LFQuickfixNumLines()}'
  endf
else
  call lf_legacy_stl#quickfix()
endif

if exists("g:default_stl")
  setlocal statusline=%!LFBuildQuickfixStatusLine()
endif

