if has('patch-8.1.1372') " Has g:statusline_winid
  fun! LFBuildUndotreeStatusLine()
    return '%#'.LFStlHighlight().'# Undotree %* %<%{t:undotree.GetStatusLine()} %*'
  endf
else
  call lf_legacy_stl#undotree()
endif

if exists("g:default_stl")
  setlocal statusline=%!LFBuildUndotreeStatusLine()
endif

