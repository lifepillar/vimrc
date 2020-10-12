" Build the status line the way I want - no fat light plugins!
" For the keys, see :h mode()
let g:lf_stlh = {
      \ 'n': 'NormalMode',  'i': 'InsertMode',      'R': 'ReplaceMode',
      \ 'v': 'VisualMode',  'V': 'VisualMode', "\<c-v>": 'VisualMode',
      \ 's': 'VisualMode',  'S': 'VisualMode', "\<c-s>": 'VisualMode',
      \ 'c': 'CommandMode', 'r': 'CommandMode',     't': 'CommandMode',
      \ '!': 'CommandMode'
      \ }

let g:lf_stlm = {
      \ 'n': 'N',           'i': 'I',               'R': 'R',
      \ 'v': 'V',           'V': 'V',          "\<c-v>": 'V',
      \ 's': 'S',           'S': 'S',          "\<c-s>": 'S',
      \ 'c': 'C',           'r': 'P',               't': 'T',
      \ '!': '!'}

" curwin is always the number of the currently active window. In a %{}
" context, winnr() always refers to the window to which the status line
" being drawn belongs. Since this function is invoked in a %{} context,
" winnr() may be different from a:curwin. We use this fact to detect
" whether we are drawing in the active window or in an inactive window.
fun! SetupStl(curwin)
  return get(extend(w:, { 'lf_active': winnr() ==# a:curwin }), '', '')
endf

fun! LFBuildStatusLine()
  return '%{SetupStl('.winnr().')}%#'.get(g:lf_stlh, mode(), 'Warnings')."#
        \%{w:['lf_active']
        \?'  '.get(g:lf_stlm,mode(),mode()).(&paste?' PASTE ':' ')
        \:''}%*
        \ %{(w:['lf_active']?'':'   ').winnr()}
        \ %{&mod?'◦':' '} %t (%n) %{&ma?(&ro?'▪':' '):'✗'}
        \ %<%{empty(&bt)
        \?(winwidth(0)<80
        \?(winwidth(0)<50?'':expand('%:p:h:t'))
        \:expand('%:p:~:h'))
        \:''}
        \ %=
        \ %a %w %{&ft} %{winwidth(0)<80
        \?''
        \:' '.(strlen(&fenc)?&fenc:&enc).(&bomb?',BOM ':' ').&ff.(&et?'':' ⇥ ')}
        \ %l:%v %P
        \ %#Warnings#%{w:['lf_active']?get(b:,'lf_stl_warnings',''):''}%*"
endf

fun! legacy#statusline#init()
endf

" Local status lines

fun! legacy#statusline#help()
  fun! LFBuildHelpStatusLine()
    return '%{SetupStl('.winnr().')}%#'
          \ . get(g:lf_stlh, mode(), 'Warnings')
          \ .'#%{w:["lf_active"] ? "  HELP " : ""}%*
          \%{w:["lf_active"] ? "" : "  HELP "} %{winnr()} %t (%n) %= %l:%v %P '
  endf
endf

fun! legacy#statusline#undotree()
  fun! LFBuildUndotreeStatusLine()
    return '%{SetupStl('.winnr().')}%#'
          \ . get(g:lf_stlh, mode(), 'Warnings')
          \ . '#%{w:["lf_active"] ? "  Undotree " : ""}%*
          \%{w:["lf_active"] ? "" : "  Undotree"}
          \ %<%{t:undotree.GetStatusLine()} %*'
  endf
endf

fun! legacy#statusline#dirvish()
  fun! LFBuildDirvishStatusLine()
    return '%{SetupStl('.winnr().')}%#'
          \ . get(g:lf_stlh, mode(), 'Warnings')
          \ . '#%{w:["lf_active"] ? "  BROWSE " : ""}%*
          \%{w:["lf_active"] ? "" : "  BROWSE "} %{winnr()} %f %= %l:%v %P '
  endf
endf

if exists("*getwininfo")
  fun! LFQuickfixTag()
    return get(getwininfo(win_getid())[0], "loclist", 0) ? "  LOCLIST " : "  QUICKFIX "
  endf
else
  fun! LFQuickfixTag()
    return 'QUICKFIX'
  endf
endif

fun! LFQuickfixNumLines()
  return winwidth(0) >= 60 ? printf(" %d line%s", line("$"), line("$") > 1 ? "s " : " ") : ""
endf

fun! legacy#statusline#quickfix()
  fun! LFBuildQuickfixStatusLine()
    return '%{SetupStl('.winnr().')}%#'
          \ . get(g:lf_stlh, mode(), 'Warnings')
          \ .'#%{w:["lf_active"] ? LFQuickfixTag() : "" }%*
          \%{w:["lf_active"] ? "" : LFQuickfixTag()}
          \ %{winnr()}  %<%{get(w:, "quickfix_title", "")}
          \ %= %q %{LFQuickfixNumLines()}'
  endf
endf

