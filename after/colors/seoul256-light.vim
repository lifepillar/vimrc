hi NormalMode ctermbg=239 ctermfg=187 guibg=#616161 guifg=#dfdebd term=NONE cterm=NONE gui=NONE
hi InsertMode ctermbg=65  ctermfg=187 guibg=#719872 guifg=#fdf6e3 term=NONE cterm=NONE gui=NONE
hi! link ReplaceMode WildMenu
hi! link CommandMode DiffChange

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

