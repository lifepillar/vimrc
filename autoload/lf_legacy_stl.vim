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

fun! BuildStatusLine()
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

fun! lf_legacy_stl#init()
endf
