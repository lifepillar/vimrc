let current_compiler = 'context'

CompilerSet errorformat=%Etex\ %trror\ %#>\ error\ on\ line\ %l\ in\ file\ %f:\ %m
      " \%E%>%f:%l:\ %m,
      " \%Cl.%l\ %m,
      " \%+C\ \ %m.,
      " \%+C%.%#-%.%#,
      " \%+C%.%#[]%.%#,
      " \%+C[]%.%#,
      " \%+C%.%#%[{}\\]%.%#,
      " \%+C<%.%#>%.%#
" Skip remaining lines (FIXME: change + into -)
CompilerSet errorformat+=%+G%.%#

let s:context = 'cd\ ''%:p:h''\ &&\ context\ --nonstopmode\ --synctex=1\ %:t:S'

if has('clientserver') " With MacVim, typeset in the background
  execute 'CompilerSet makeprg=('.s:context.'\ >/dev/null\ 2>&1;mvim\ --remote-expr\ \"lf_tex\\#callback($?)\")&'
else
  execute 'CompilerSet makeprg='.s:context
endif

