set fillchars=vert:\|,fold:\·
hi! link Search VisualMode
if &background ==# 'light'
  hi InsertMode  ctermbg=31  ctermfg=255 guibg=#3e999f guifg=#f5f5f5 term=NONE cterm=NONE gui=NONE
  hi ReplaceMode ctermbg=166 ctermfg=255 guibg=#d75f00 guifg=#f5f5f5 term=NONE cterm=NONE gui=NONE
endif

