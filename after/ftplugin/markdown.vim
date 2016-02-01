setlocal spell
setlocal spelllang=en
setlocal dictionary=/usr/share/dict/words
setlocal autoindent
setlocal foldmethod=syntax
" Disable HTML completion function set by the Markdown plugin.
setlocal omnifunc=

syn region mkdHeaderFold
      \ start="^\s*\z(#\+\)"
      \ skip="^\s*\z1#\+"
      \ end="^\(\s*#\)\@="
      \ fold contains=TOP

