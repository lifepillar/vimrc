let current_compiler = 'context'

CompilerSet errorformat=%Etex\ %trror%.%#error\ on\ line\ %l\ in\ file\ %f:\ %m,
      \%Elua\ %trror%.%#error\ on\ line\ %l\ in\ file\ %f:,
      \%Z...%m
      " \%E%>%f:%l:\ %m,
      " \%Cl.%l\ %m,
      " \%+C\ \ %m.,
      " \%+C%.%#-%.%#,
      " \%+C%.%#[]%.%#,
      " \%+C[]%.%#,
      " \%+C%.%#%[{}\\]%.%#,
      " \%+C<%.%#>%.%#
" Skip remaining lines
CompilerSet errorformat+=%-G%.%#

CompilerSet makeprg=make

