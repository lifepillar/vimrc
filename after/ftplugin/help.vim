if has('patch-8.1.1372') " Has g:statusline_winid
  fun! LFBuildHelpStatusLine()
    return '%#'.LFStlHighlight().'# HELP %* %{winnr()} %t (%n) %= %l:%v %P '
  endf
else
  call legacy#statusline#help()
endif

if exists("g:default_stl")
  setlocal statusline=%!LFBuildHelpStatusLine()
endif

