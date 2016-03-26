hi NormalMode ctermbg=239 ctermfg=187 guibg=#616161 guifg=#dfdebd term=NONE cterm=NONE gui=NONE
hi InsertMode ctermbg=65  ctermfg=187 guibg=#719872 guifg=#fdf6e3 term=NONE cterm=NONE gui=NONE
hi! link ReplaceMode WildMenu
hi! link CommandMode DiffChange
hi TabLineFill ctermfg=252 guifg=#e1e1e1
" Remove bold
hi StatusLine  cterm=reverse gui=reverse
hi TabLineSel  cterm=NONE gui=NONE
" Remove underline in tabline
hi TabLine cterm=NONE gui=NONE

fun! BackgroundToggle_seoul256_light()
  colorscheme seoul256
endf

" g:seoul256_light_background is a value between 252 and 256
command! IncreaseContrast
      \ let g:seoul256_light_background = 252 + (g:seoul256_light_background - 251) % 5 |
      \ colorscheme seoul256-light

command! ReduceContrast
      \ let g:seoul256_light_background = 256 - (257 - g:seoul256_light_background) % 5 |
      \ colorscheme seoul256-light

