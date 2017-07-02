" Name: Ocean Sunset colorscheme source file
" Author:   Lifepillar <lifepillar@lifepillar.me>
" License: This file is placed in the public domain
" Inspired by the various Ocean Sunset palettes at https://color.adobe.com/

let s:colornames  = [
      \ 'White',
      \ 'DarkGreen',
      \ 'LightGreen',
      \ 'Yellow',
      \ 'Orange',
      \ 'DarkOrange',
      \ 'DarkRed',
      \ 'Purple',
      \ 'Blue',
      \ 'LightBlue',
      \ 'BlueGreen',
      \ 'Green2',
      \ 'LemonGreen',
      \ 'DarkSalmon',
      \ 'Salmon',
      \ 'Pink1',
      \ 'Pink2',
      \ 'Pink3'
      \ ]

let s:none        = ["NONE", "NONE"]
let s:white       = ["#fffefa", 236]
" Main colors
let s:darkgreen   = ["#506b64", 236]
let s:lightgreen  = ["#acaa8c", 236]
let s:yellow      = ["#ffdaa3", 236]
let s:orange      = ["#ffa860", 236]
let s:darkorange  = ["#f96634", 236]
" Auxiliary colors
let s:lightblue   = ["#507d9c", 236] " OK
let s:lemongreen  = ["#819c5e", 236] " OK
let s:darksalmon  = ["#e86a59", 236] " OK
let s:salmon      = ["#ff966e", 236] " OK
let s:pink1       = ["#f39039", 236] " OK
let s:pink2       = ["#f27487", 236] " Maybe
let s:pink3       = ["#a55a76", 236] " Maybe (for errors?)
let s:blue        = ["#394759", 236] " Maybe
let s:darkred     = ["#a62317", 236] " NO
let s:purple      = ["#1f0b27", 236] " NO
let s:bluegreen   = ["#214952", 236] " NO
let s:green2      = ["#0c594e", 236] " NO

fun! s:HL(group, fg, bg, ...) " ... is an optional dictionary of attributes
  call append(line('$'), join([
        \ 'hi', a:group,
        \ 'ctermfg=' . a:fg[1],
        \ 'ctermbg=' . a:bg[1],
        \ 'cterm='   . (a:0 > 0 ? get(a:1, 'cterm', 'NONE') : 'NONE'),
        \ 'guifg='   . a:fg[0],
        \ 'guibg='   . a:bg[0],
        \ 'gui='     . (a:0 > 0 ? get(a:1, 'gui', 'NONE') : 'NONE'),
        \ 'guisp='   . (a:0 > 0 ? get(a:1, 'guisp', 'NONE') : 'NONE')
        \ ]))
endf

fun! s:HLink(src, tgt)
  call append(line('$'),  'hi! link '.a:src.' '.a:tgt)
endf

fun! s:put(line)
  call append(line('$'), a:line)
endf

silent tabnew +setlocal\ ft=vim
insert
" Name: Ocean Sunset colorscheme
" Author:   Lifepillar <lifepillar@lifepillar.me>
" License: This file is placed in the public domain

set background=light
hi clear
if exists('syntax_on')
  syntax reset
endif
let colors_name = 'ocean_sunset'

.

call s:put("if !has('gui_running') && get(g:, 'ocean_sunset_term_trans_bg', 0)")
call s:HL("Normal", s:darkgreen, s:none)
call s:put("else")
call s:HL("Normal", s:darkgreen, s:white)
call s:put("endif")
call s:HL("ColorColumn",              s:none,        s:lightgreen)
call s:HL("Conceal",                  s:darkgreen, s:none)
call s:HL("Cursor",                   s:none,        s:darkgreen)
call s:HLink("lCursor", "Cursor")
call s:HL("CursorIM",                 s:none,        s:darkgreen)
call s:HL("CursorColumn",             s:none,        s:lightgreen)
call s:HL("CursorLine",               s:none,        s:lightgreen)
call s:HL("CursorLineNr",             s:darkgreen,       s:none)
call s:HL("DiffAdd",                  s:lightgreen,   s:darkgreen, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("DiffChange",               s:orange,      s:darkgreen, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("DiffDelete",               s:darkorange,         s:darkgreen, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("DiffText",                 s:lightgreen,       s:darkgreen, {'cterm': 'NONE,bold,reverse', 'gui': 'NONE,bold,reverse'})
call s:HL("Directory",                s:lightgreen,   s:none)
call s:HL("EndOfBuffer",              s:lightgreen,       s:none)
call s:HL("Error",                    s:purple,         s:white, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("ErrorMsg",                 s:purple,         s:white, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("FoldColumn",               s:lightgreen,       s:none)
call s:HL("Folded",                   s:lightgreen,       s:none)
call s:HL("IncSearch",                s:orange,      s:darkgreen, {'cterm': 'NONE,reverse',      'gui': 'NONE,standout'})
call s:HL("LineNr",                   s:lightgreen,       s:none)
call s:HL("MatchParen",               s:darkorange,      s:darkgreen, {'cterm': 'NONE,bold,reverse', 'gui': 'NONE,bold,reverse'})
call s:HL("ModeMsg",                  s:darkgreen,       s:none)
call s:HL("MoreMsg",                  s:lightgreen,       s:none)
call s:HL("NonText",                  s:darkgreen,       s:none)
call s:HL("Pmenu",                    s:darkgreen,       s:darkgreen)
call s:HL("PmenuSbar",                s:lightgreen,       s:lightgreen)
call s:HL("PmenuSel",                 s:darkgreen,       s:orange)
call s:HL("PmenuThumb",               s:lightgreen,       s:orange)
call s:HL("Question",                 s:lightgreen,       s:none)
call s:HL("Search",                   s:orange,      s:darkgreen, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("SignColumn",               s:lightgreen,       s:none)
call s:HL("SpecialKey",               s:lightgreen,       s:none)
call s:HL("SpellBad",                 s:none,        s:none,  {'cterm': 'NONE,underline',    'gui': 'NONE,undercurl', 'guisp': s:darkorange[0]})
call s:HL("SpellCap",                 s:darkorange,      s:none,  {'cterm': 'NONE,underline',    'gui': 'NONE,undercurl', 'guisp': s:darkorange[0]})
call s:HL("SpellLocal",               s:darkorange,      s:none,  {'cterm': 'NONE,underline',    'gui': 'NONE,undercurl', 'guisp': s:darkorange[0]})
call s:HL("SpellRare",                s:darkorange,      s:none,  {'cterm': 'NONE,underline',    'gui': 'NONE,undercurl', 'guisp': s:darkorange[0]})
call s:HL("StatusLine",               s:darkorange, s:white, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("StatusLineNC",             s:darkgreen, s:white, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("TabLine",                  s:white,        s:darkgreen)
call s:HL("TabLineFill",              s:white,        s:darkgreen)
call s:HL("TabLineSel",               s:white,       s:darkorange)
call s:HL("Title",                    s:darkorange,      s:none,  {'cterm': 'NONE,bold',         'gui': 'NONE,bold'})
call s:HL("VertSplit",                s:darkgreen, s:darkgreen)
call s:HL("Visual",                   s:yellow,        s:darkgreen, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("VisualNOS",                s:darkgreen,       s:darkgreen)
call s:HL("WarningMsg",               s:purple,         s:none)
call s:HL("WildMenu",                 s:darkgreen,       s:darkorange)

call s:HL("Boolean",                  s:lightgreen,   s:none)
call s:HL("Character",                s:orange,      s:none)
call s:HL("Comment",                  s:lightgreen,       s:none,  {'gui': 'NONE,italic'})
call s:HL("Constant",                 s:orange,      s:none)
call s:HL("Debug",                    s:darkorange,       s:none)
call s:HL("Delimiter",                s:darkgreen,       s:none)
call s:HL("Float",                    s:lightgreen,   s:none)
call s:HL("Function",                 s:lightgreen,       s:none)
call s:HL("Identifier",               s:salmon,   s:none)
call s:HL("Ignore",                   s:darkgreen,       s:none)
call s:HL("Include",                  s:darkorange,         s:none)
call s:HL("Keyword",                  s:darkgreen, s:none)
call s:HL("Label",                    s:lightgreen,       s:none)
call s:HL("Number",                   s:lightgreen,   s:none)
call s:HL("Operator",                 s:darkgreen,   s:none)
call s:HL("PreProc",                  s:darkorange,         s:none)
call s:HL("Special",                  s:darkorange,         s:none)
call s:HL("SpecialChar",              s:darkorange,       s:none)
call s:HL("SpecialComment",           s:darkorange,       s:none)
call s:HL("Statement",                s:salmon, s:none, {'cterm': 'NONE,bold', 'gui': 'NONE,bold'})
call s:HL("StorageClass",             s:darksalmon,   s:none)
call s:HL("String",                   s:lemongreen,   s:none)
call s:HL("Structure",                s:darkorange,         s:none)
call s:HL("Todo",                     s:darkorange,       s:none,  {'cterm': 'NONE,bold',         'gui': 'NONE,bold'})
call s:HL("Type",                     s:darkorange,      s:none)
call s:HL("Underlined",               s:none,        s:none,  {'cterm': 'NONE,underline',    'gui': 'NONE,underline'})

" OceanSunset color palette
for i in range(0, len(s:colornames) - 1)
  call s:HL("OceanSunset".s:colornames[i], eval("s:".tolower(s:colornames[i])), eval("s:".tolower(s:colornames[i])))
endfor

" Custom highlight groups for the main modes
call s:HL("NormalMode",               s:lightgreen,       s:darkgreen, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("InsertMode",               s:lightgreen,   s:darkgreen, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("ReplaceMode",              s:orange,      s:darkgreen, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("VisualMode",               s:yellow,        s:darkgreen, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})
call s:HL("CommandMode",              s:darkorange,       s:darkgreen, {'cterm': 'NONE,reverse',      'gui': 'NONE,reverse'})

" Vim
call s:HL("vimMapModKey",             s:orange,      s:none)
call s:HL("vimMapMod",                s:orange,      s:none)
call s:HL("vimBracket",               s:darkgreen,   s:none)
call s:HL("vimNotation",              s:darkgreen,   s:none)
call s:HLink("vimUserFunc",           "Function")

" Git
call s:HL("gitcommitComment",         s:lightgreen,       s:none,  {'gui': 'NONE,italic'})

" Markdown
call s:HL("markdownHeadingDelimiter", s:orange,      s:none)
call s:HL("markdownURL",              s:darkorange,      s:none)

" Terminal italic
$append
if get(g:, "ocean_sunset_term_italics", 0)
  hi Comment cterm=italic
  hi gitcommitComment cterm=italic
endif
.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Demo palette :)
silent tabnew
for i in range(1,len(s:colornames))
  execute "syn match OceanSunsetLine".i "/\\%".i."l.*\\%60c/"
  execute "hi! link OceanSunsetLine".i "OceanSunset".s:colornames[i - 1]
  call s:put(repeat(" ", 60).s:colornames[i - 1])
endfor
normal ggd_
