" Base colors
if has("gui_running")
  let s:vmode       = "gui"
  let s:base03      = '#002b36'
  let s:base02      = '#073642'
  let s:base01      = '#586e75'
  let s:base00      = '#657b83'
  let s:base0       = '#839496'
  let s:base1       = '#93a1a1'
  let s:base2       = '#eee8d5'
  let s:base3       = '#fdf6e3'
  let s:yellow      = '#b58900'
  let s:orange      = '#cb4b16'
  let s:red         = '#dc322f'
  let s:magenta     = '#d33682'
  let s:violet      = '#6c71c4'
  let s:blue        = '#268bd2'
  let s:cyan        = '#2aa198'
  let s:green       = '#859900'
else
  let s:vmode       = "cterm"
  let s:ansi_colors = get(g:, 'solarized_termcolors', 16) != 256 && &t_Co >= 16 ? 1 : 0
  let s:tty         = &t_Co == 8
  let s:base03      = s:ansi_colors ?  "8" : (s:tty ? "0" : 234)
  let s:base02      = s:ansi_colors ?  "0" : (s:tty ? "0" : 235)
  let s:base01      = s:ansi_colors ? "10" : (s:tty ? "0" : 240)
  let s:base00      = s:ansi_colors ? "11" : (s:tty ? "7" : 241)
  let s:base0       = s:ansi_colors ? "12" : (s:tty ? "7" : 244)
  let s:base1       = s:ansi_colors ? "14" : (s:tty ? "7" : 245)
  let s:base2       = s:ansi_colors ?  "7" : (s:tty ? "7" : 254)
  let s:base3       = s:ansi_colors ? "15" : (s:tty ? "7" : 230)
  let s:yellow      = s:ansi_colors ?  "3" : (s:tty ? "3" : 136)
  let s:orange      = s:ansi_colors ?  "9" : (s:tty ? "1" : 166)
  let s:red         = s:ansi_colors ?  "1" : (s:tty ? "1" : 160)
  let s:magenta     = s:ansi_colors ?  "5" : (s:tty ? "5" : 125)
  let s:violet      = s:ansi_colors ? "13" : (s:tty ? "5" :  61)
  let s:blue        = s:ansi_colors ?  "4" : (s:tty ? "4" :  33)
  let s:cyan        = s:ansi_colors ?  "6" : (s:tty ? "6" :  37)
  let s:green       = s:ansi_colors ?  "2" : (s:tty ? "2" :  64)
endif

let s:bg = s:vmode . "bg="
let s:fg = s:vmode . "fg="

" Override some settings and define the colors for the status line
hi clear SignColumn

if &background ==# 'dark'
  if g:solarized_contrast == "high"
    let s:base01      = s:base00
    let s:base00      = s:base0
    let s:base0       = s:base1
    let s:base1       = s:base2
    let s:base2       = s:base3
  endif
  " Fix ErrorMsg in Dark Solarized, which is black on red by default (pesky)
  execute "hi ErrorMsg"       s:bg.s:red     s:fg.s:base3  s:vmode."=NONE"
  " I don't like red on blue, not even the Solarised flavor
  hi! link Special PreProc
  if g:solarized_contrast == "lifepillar"
    execute "hi VertSplit"    s:bg.s:base02  s:fg.s:base02 s:vmode."=NONE"
    execute "hi StatusLineNC" s:bg.s:base02  s:fg.s:base1  s:vmode."=NONE"
    execute "hi CursorLine"   s:bg.s:base03                s:vmode."=underline"
  else
    execute "hi VertSplit"    s:bg.s:base01  s:fg.s:base01 s:vmode."=NONE"
    execute "hi StatusLineNC" s:bg.s:base01  s:fg.s:base1  s:vmode."=NONE"
  endif
  execute   "hi StatusLine"   s:bg.s:base01  s:fg.s:base2  s:vmode."=NONE"
  execute   "hi NormalMode"   s:bg.s:base0   s:fg.s:base2  s:vmode."=NONE"
  execute   "hi InsertMode"   s:bg.s:cyan    s:fg.s:base2  s:vmode."=NONE"
  execute   "hi ReplaceMode"  s:bg.s:orange  s:fg.s:base2  s:vmode."=NONE"
  execute   "hi VisualMode"   s:bg.s:magenta s:fg.s:base2  s:vmode."=NONE"
  execute   "hi CommandMode"  s:bg.s:magenta s:fg.s:base2  s:vmode."=NONE"
  execute   "hi MatchParen"   s:bg.s:base02  s:fg.s:base1  s:vmode."=bold"
  let g:limelight_conceal_ctermfg = s:base01
else
  if g:solarized_contrast == "high"
    let s:base01      = s:base02
    let s:base1       = s:base0
  endif
  if g:solarized_contrast == "lifepillar"
    execute "hi VertSplit"    s:bg.s:base2   s:fg.s:base2  s:vmode."=NONE"
    execute "hi StatusLineNC" s:bg.s:base2   s:fg.s:base1  s:vmode."=NONE"
    execute "hi CursorLine"   s:bg.s:base3                 s:vmode."=underline"
  else
    execute "hi VertSplit"    s:bg.s:base1   s:fg.s:base1  s:vmode."=NONE"
    execute "hi StatusLineNC" s:bg.s:base1   s:fg.s:base2  s:vmode."=NONE"
  endif
  execute   "hi StatusLine"   s:bg.s:base1   s:fg.s:base3  s:vmode."=NONE"
  execute   "hi NormalMode"   s:bg.s:base01  s:fg.s:base3  s:vmode."=NONE"
  execute   "hi InsertMode"   s:bg.s:cyan    s:fg.s:base3  s:vmode."=NONE"
  execute   "hi ReplaceMode"  s:bg.s:orange  s:fg.s:base3  s:vmode."=NONE"
  execute   "hi VisualMode"   s:bg.s:magenta s:fg.s:base3  s:vmode."=NONE"
  execute   "hi CommandMode"  s:bg.s:magenta s:fg.s:base3  s:vmode."=NONE"
  execute   "hi MatchParen"   s:bg.s:base2   s:fg.s:base02 s:vmode."=bold"
  let g:limelight_conceal_ctermfg = s:base1
endif

let s:contrast_levels = ["low", "lifepillar", "normal", "high"]

command! IncreaseContrast
      \ let g:solarized_contrast =
      \ get(s:contrast_levels, (1 + index(s:contrast_levels, g:solarized_contrast)) % 4) |
      \ colorscheme solarized

command! ReduceContrast
      \ let g:solarized_contrast =
      \ get(s:contrast_levels, (3 + index(s:contrast_levels, g:solarized_contrast)) % 4) |
      \ colorscheme solarized

