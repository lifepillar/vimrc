let s:bg0    = lf_theme#fg('GruvboxBg0')
let s:bg2    = lf_theme#fg('GruvboxBg2')
let s:bg4    = lf_theme#fg('GruvboxBg4')
let s:fg4    = lf_theme#fg('GruvboxFg4')
let s:aqua   = lf_theme#fg('GruvboxAqua')
let s:blue   = lf_theme#fg('GruvboxBlue')
let s:orange = lf_theme#fg('GruvboxOrange')
let s:purple = lf_theme#fg('GruvboxPurple')

fun! s:hg(group, bg, fg, mode)
  execute "hi" a:group "ctermbg=".a:bg[0] "ctermfg=".a:fg[0] "guibg=".a:bg[1] "guifg=".a:fg[1] "cterm=".a:mode "gui=".a:mode
endf

call s:hg("StatusLine",  s:fg4, s:bg2,    "NONE,reverse")
call s:hg("NormalMode",  s:bg0, s:fg4,    "NONE,reverse")
call s:hg("InsertMode",  s:bg0, s:blue,   "NONE,reverse")
call s:hg("ReplaceMode", s:bg0, s:aqua,   "NONE,reverse")
call s:hg("VisualMode",  s:bg0, s:orange, "NONE,reverse")
call s:hg("CommandMode", s:bg0, s:purple, "NONE,reverse")
call s:hg("Warnings",    s:bg0, s:orange, "NONE,reverse")

