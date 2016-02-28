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

CompilerSet makeprg=make

