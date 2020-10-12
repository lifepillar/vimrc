set fillchars=fold:\ ,vert:\|
hi! link Search VisualMode
" Remove bold
hi StatusLine cterm=NONE gui=NONE
if &background ==# 'light'
  hi NormalMode  ctermbg=31  ctermfg=255 guibg=#3e999f guifg=#f5f5f5 term=NONE cterm=NONE gui=NONE
  hi! link InsertMode Folded
  hi ReplaceMode ctermbg=166 ctermfg=255 guibg=#d75f00 guifg=#f5f5f5 term=NONE cterm=NONE gui=NONE
endif

