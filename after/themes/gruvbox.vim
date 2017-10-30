let s:bg0    = colortemplate#syn#hi_group_fg('GruvboxBg0')
let s:bg2    = colortemplate#syn#hi_group_fg('GruvboxBg2')
let s:bg4    = colortemplate#syn#hi_group_fg('GruvboxBg4')
let s:fg4    = colortemplate#syn#hi_group_fg('GruvboxFg4')
let s:aqua   = colortemplate#syn#hi_group_fg('GruvboxAqua')
let s:blue   = colortemplate#syn#hi_group_fg('GruvboxBlue')
let s:orange = colortemplate#syn#hi_group_fg('GruvboxOrange')
let s:purple = colortemplate#syn#hi_group_fg('GruvboxPurple')

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

