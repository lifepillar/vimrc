setlocal spell
setlocal spelllang=en
setlocal dictionary=/usr/share/dict/words
setlocal autoindent
setlocal foldmethod=syntax

syn region mkdHeaderFold
      \ start="^\s*\z(#\+\)"
      \ skip="^\s*\z1#\+"
      \ end="^\(\s*#\)\@="
      \ fold contains=TOP

