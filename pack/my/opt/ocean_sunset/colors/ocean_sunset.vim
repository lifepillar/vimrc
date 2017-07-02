" Name: Ocean Sunset colorscheme
" Author:   Lifepillar <lifepillar@lifepillar.me>
" License: This file is placed in the public domain

set background=light
hi clear
if exists('syntax_on')
  syntax reset
endif
let colors_name = 'ocean_sunset'

if !has('gui_running') && get(g:, 'ocean_sunset_term_trans_bg', 0)
hi Normal ctermfg=236 ctermbg=NONE cterm=NONE guifg=#506b64 guibg=NONE gui=NONE guisp=NONE
else
hi Normal ctermfg=236 ctermbg=236 cterm=NONE guifg=#506b64 guibg=#fbfbfb gui=NONE guisp=NONE
endif
hi ColorColumn ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#acaa8c gui=NONE guisp=NONE
hi Conceal ctermfg=236 ctermbg=NONE cterm=NONE guifg=#506b64 guibg=NONE gui=NONE guisp=NONE
hi Cursor ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#506b64 gui=NONE guisp=NONE
hi! link lCursor Cursor
hi CursorIM ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#506b64 gui=NONE guisp=NONE
hi CursorColumn ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#acaa8c gui=NONE guisp=NONE
hi CursorLine ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#acaa8c gui=NONE guisp=NONE
hi CursorLineNr ctermfg=236 ctermbg=NONE cterm=NONE guifg=#506b64 guibg=NONE gui=NONE guisp=NONE
hi DiffAdd ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#acaa8c guibg=#506b64 gui=NONE,reverse guisp=NONE
hi DiffChange ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#ffa860 guibg=#506b64 gui=NONE,reverse guisp=NONE
hi DiffDelete ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#f96634 guibg=#506b64 gui=NONE,reverse guisp=NONE
hi DiffText ctermfg=236 ctermbg=236 cterm=NONE,bold,reverse guifg=#acaa8c guibg=#506b64 gui=NONE,bold,reverse guisp=NONE
hi Directory ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi EndOfBuffer ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi Error ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#1f0b27 guibg=#fbfbfb gui=NONE,reverse guisp=NONE
hi ErrorMsg ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#1f0b27 guibg=#fbfbfb gui=NONE,reverse guisp=NONE
hi FoldColumn ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi Folded ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi IncSearch ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#ffa860 guibg=#506b64 gui=NONE,standout guisp=NONE
hi LineNr ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi MatchParen ctermfg=236 ctermbg=236 cterm=NONE,bold,reverse guifg=#f96634 guibg=#506b64 gui=NONE,bold,reverse guisp=NONE
hi ModeMsg ctermfg=236 ctermbg=NONE cterm=NONE guifg=#506b64 guibg=NONE gui=NONE guisp=NONE
hi MoreMsg ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi NonText ctermfg=236 ctermbg=NONE cterm=NONE guifg=#506b64 guibg=NONE gui=NONE guisp=NONE
hi Pmenu ctermfg=236 ctermbg=236 cterm=NONE guifg=#506b64 guibg=#506b64 gui=NONE guisp=NONE
hi PmenuSbar ctermfg=236 ctermbg=236 cterm=NONE guifg=#acaa8c guibg=#acaa8c gui=NONE guisp=NONE
hi PmenuSel ctermfg=236 ctermbg=236 cterm=NONE guifg=#506b64 guibg=#ffa860 gui=NONE guisp=NONE
hi PmenuThumb ctermfg=236 ctermbg=236 cterm=NONE guifg=#acaa8c guibg=#ffa860 gui=NONE guisp=NONE
hi Question ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi Search ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#ffa860 guibg=#506b64 gui=NONE,reverse guisp=NONE
hi SignColumn ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi SpecialKey ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi SpellBad ctermfg=NONE ctermbg=NONE cterm=NONE,underline guifg=NONE guibg=NONE gui=NONE,undercurl guisp=#f96634
hi SpellCap ctermfg=236 ctermbg=NONE cterm=NONE,underline guifg=#f96634 guibg=NONE gui=NONE,undercurl guisp=#f96634
hi SpellLocal ctermfg=236 ctermbg=NONE cterm=NONE,underline guifg=#f96634 guibg=NONE gui=NONE,undercurl guisp=#f96634
hi SpellRare ctermfg=236 ctermbg=NONE cterm=NONE,underline guifg=#f96634 guibg=NONE gui=NONE,undercurl guisp=#f96634
hi StatusLine ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#f96634 guibg=#fbfbfb gui=NONE,reverse guisp=NONE
hi StatusLineNC ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#506b64 guibg=#fbfbfb gui=NONE,reverse guisp=NONE
hi TabLine ctermfg=236 ctermbg=236 cterm=NONE guifg=#fbfbfb guibg=#506b64 gui=NONE guisp=NONE
hi TabLineFill ctermfg=236 ctermbg=236 cterm=NONE guifg=#fbfbfb guibg=#506b64 gui=NONE guisp=NONE
hi TabLineSel ctermfg=236 ctermbg=236 cterm=NONE guifg=#fbfbfb guibg=#f96634 gui=NONE guisp=NONE
hi Title ctermfg=236 ctermbg=NONE cterm=NONE,bold guifg=#f96634 guibg=NONE gui=NONE,bold guisp=NONE
hi VertSplit ctermfg=236 ctermbg=236 cterm=NONE guifg=#506b64 guibg=#506b64 gui=NONE guisp=NONE
hi Visual ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#ffdaa3 guibg=#506b64 gui=NONE,reverse guisp=NONE
hi VisualNOS ctermfg=236 ctermbg=236 cterm=NONE guifg=#506b64 guibg=#506b64 gui=NONE guisp=NONE
hi WarningMsg ctermfg=236 ctermbg=NONE cterm=NONE guifg=#1f0b27 guibg=NONE gui=NONE guisp=NONE
hi WildMenu ctermfg=236 ctermbg=236 cterm=NONE guifg=#506b64 guibg=#f96634 gui=NONE guisp=NONE
hi Boolean ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi Character ctermfg=236 ctermbg=NONE cterm=NONE guifg=#ffa860 guibg=NONE gui=NONE guisp=NONE
hi Comment ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE,italic guisp=NONE
hi Constant ctermfg=236 ctermbg=NONE cterm=NONE guifg=#ffa860 guibg=NONE gui=NONE guisp=NONE
hi Debug ctermfg=236 ctermbg=NONE cterm=NONE guifg=#f96634 guibg=NONE gui=NONE guisp=NONE
hi Delimiter ctermfg=236 ctermbg=NONE cterm=NONE guifg=#506b64 guibg=NONE gui=NONE guisp=NONE
hi Float ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi Function ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi Identifier ctermfg=236 ctermbg=NONE cterm=NONE guifg=#ff966e guibg=NONE gui=NONE guisp=NONE
hi Ignore ctermfg=236 ctermbg=NONE cterm=NONE guifg=#506b64 guibg=NONE gui=NONE guisp=NONE
hi Include ctermfg=236 ctermbg=NONE cterm=NONE guifg=#f96634 guibg=NONE gui=NONE guisp=NONE
hi Keyword ctermfg=236 ctermbg=NONE cterm=NONE guifg=#506b64 guibg=NONE gui=NONE guisp=NONE
hi Label ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi Number ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi Operator ctermfg=236 ctermbg=NONE cterm=NONE guifg=#506b64 guibg=NONE gui=NONE guisp=NONE
hi PreProc ctermfg=236 ctermbg=NONE cterm=NONE guifg=#f96634 guibg=NONE gui=NONE guisp=NONE
hi Special ctermfg=236 ctermbg=NONE cterm=NONE guifg=#f96634 guibg=NONE gui=NONE guisp=NONE
hi SpecialChar ctermfg=236 ctermbg=NONE cterm=NONE guifg=#f96634 guibg=NONE gui=NONE guisp=NONE
hi SpecialComment ctermfg=236 ctermbg=NONE cterm=NONE guifg=#f96634 guibg=NONE gui=NONE guisp=NONE
hi Statement ctermfg=236 ctermbg=NONE cterm=NONE,bold guifg=#ff966e guibg=NONE gui=NONE,bold guisp=NONE
hi StorageClass ctermfg=236 ctermbg=NONE cterm=NONE guifg=#e86a59 guibg=NONE gui=NONE guisp=NONE
hi String ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE guisp=NONE
hi Structure ctermfg=236 ctermbg=NONE cterm=NONE guifg=#f96634 guibg=NONE gui=NONE guisp=NONE
hi Todo ctermfg=236 ctermbg=NONE cterm=NONE,bold guifg=#f96634 guibg=NONE gui=NONE,bold guisp=NONE
hi Type ctermfg=236 ctermbg=NONE cterm=NONE guifg=#f96634 guibg=NONE gui=NONE guisp=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=NONE,underline guifg=NONE guibg=NONE gui=NONE,underline guisp=NONE
hi OceanSunsetWhite ctermfg=236 ctermbg=236 cterm=NONE guifg=#fbfbfb guibg=#fbfbfb gui=NONE guisp=NONE
hi OceanSunsetDarkGreen ctermfg=236 ctermbg=236 cterm=NONE guifg=#506b64 guibg=#506b64 gui=NONE guisp=NONE
hi OceanSunsetLightGreen ctermfg=236 ctermbg=236 cterm=NONE guifg=#acaa8c guibg=#acaa8c gui=NONE guisp=NONE
hi OceanSunsetYellow ctermfg=236 ctermbg=236 cterm=NONE guifg=#ffdaa3 guibg=#ffdaa3 gui=NONE guisp=NONE
hi OceanSunsetOrange ctermfg=236 ctermbg=236 cterm=NONE guifg=#ffa860 guibg=#ffa860 gui=NONE guisp=NONE
hi OceanSunsetDarkOrange ctermfg=236 ctermbg=236 cterm=NONE guifg=#f96634 guibg=#f96634 gui=NONE guisp=NONE
hi OceanSunsetDarkRed ctermfg=236 ctermbg=236 cterm=NONE guifg=#a62317 guibg=#a62317 gui=NONE guisp=NONE
hi OceanSunsetPurple ctermfg=236 ctermbg=236 cterm=NONE guifg=#1f0b27 guibg=#1f0b27 gui=NONE guisp=NONE
hi OceanSunsetBlue ctermfg=236 ctermbg=236 cterm=NONE guifg=#394759 guibg=#394759 gui=NONE guisp=NONE
hi OceanSunsetLightBlue ctermfg=236 ctermbg=236 cterm=NONE guifg=#507d9c guibg=#507d9c gui=NONE guisp=NONE
hi OceanSunsetBlueGreen ctermfg=236 ctermbg=236 cterm=NONE guifg=#214952 guibg=#214952 gui=NONE guisp=NONE
hi OceanSunsetGreen2 ctermfg=236 ctermbg=236 cterm=NONE guifg=#0c594e guibg=#0c594e gui=NONE guisp=NONE
hi OceanSunsetLemonGreen ctermfg=236 ctermbg=236 cterm=NONE guifg=#819c5e guibg=#819c5e gui=NONE guisp=NONE
hi OceanSunsetDarkSalmon ctermfg=236 ctermbg=236 cterm=NONE guifg=#e86a59 guibg=#e86a59 gui=NONE guisp=NONE
hi OceanSunsetSalmon ctermfg=236 ctermbg=236 cterm=NONE guifg=#ff966e guibg=#ff966e gui=NONE guisp=NONE
hi OceanSunsetPink1 ctermfg=236 ctermbg=236 cterm=NONE guifg=#f39039 guibg=#f39039 gui=NONE guisp=NONE
hi OceanSunsetPink2 ctermfg=236 ctermbg=236 cterm=NONE guifg=#f27487 guibg=#f27487 gui=NONE guisp=NONE
hi OceanSunsetPink3 ctermfg=236 ctermbg=236 cterm=NONE guifg=#a55a76 guibg=#a55a76 gui=NONE guisp=NONE
hi NormalMode ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#acaa8c guibg=#506b64 gui=NONE,reverse guisp=NONE
hi InsertMode ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#acaa8c guibg=#506b64 gui=NONE,reverse guisp=NONE
hi ReplaceMode ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#ffa860 guibg=#506b64 gui=NONE,reverse guisp=NONE
hi VisualMode ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#ffdaa3 guibg=#506b64 gui=NONE,reverse guisp=NONE
hi CommandMode ctermfg=236 ctermbg=236 cterm=NONE,reverse guifg=#f96634 guibg=#506b64 gui=NONE,reverse guisp=NONE
hi vimMapModKey ctermfg=236 ctermbg=NONE cterm=NONE guifg=#ffa860 guibg=NONE gui=NONE guisp=NONE
hi vimMapMod ctermfg=236 ctermbg=NONE cterm=NONE guifg=#ffa860 guibg=NONE gui=NONE guisp=NONE
hi vimBracket ctermfg=236 ctermbg=NONE cterm=NONE guifg=#506b64 guibg=NONE gui=NONE guisp=NONE
hi vimNotation ctermfg=236 ctermbg=NONE cterm=NONE guifg=#506b64 guibg=NONE gui=NONE guisp=NONE
hi! link vimUserFunc Function
hi gitcommitComment ctermfg=236 ctermbg=NONE cterm=NONE guifg=#acaa8c guibg=NONE gui=NONE,italic guisp=NONE
hi markdownHeadingDelimiter ctermfg=236 ctermbg=NONE cterm=NONE guifg=#ffa860 guibg=NONE gui=NONE guisp=NONE
hi markdownURL ctermfg=236 ctermbg=NONE cterm=NONE guifg=#f96634 guibg=NONE gui=NONE guisp=NONE
if get(g:, "ocean_sunset_term_italics", 0)
  hi Comment cterm=italic
  hi gitcommitComment cterm=italic
endif
