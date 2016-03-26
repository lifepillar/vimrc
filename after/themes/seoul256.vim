hi! link VertSplit   StatusLineNC
hi! link NormalMode  StatusLineNC
hi! link InsertMode  PmenuSbar
hi! link ReplaceMode Search
hi! link CommandMode DiffAdd
" Remove bold
hi StatusLine  cterm=reverse gui=reverse
hi TabLineSel  cterm=NONE gui=NONE
" Remove underline in tabline
hi TabLine cterm=NONE gui=NONE

fun! BackgroundToggle_seoul256()
  colorscheme seoul256-light
endf

" g:seoul256_background is a value between 233 and 239
command! IncreaseContrast
      \ let g:seoul256_background = 233 + (g:seoul256_background - 232) % 7 |
      \ colorscheme seoul256

command! ReduceContrast
      \ let g:seoul256_background = 239 - (240 - g:seoul256_background) % 7 |
      \ colorscheme seoul256

