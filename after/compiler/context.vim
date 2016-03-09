let current_compiler = 'context'

CompilerSet errorformat=%Etex\ %trror%.%#error\ on\ line\ %l\ in\ file\ %f:\ %m,
      \%Elua\ %trror%.%#error\ on\ line\ %l\ in\ file\ %f:,
      \%C\ %#,
      \%Z...%m
" Skip remaining lines
CompilerSet errorformat+=%-G%.%#

CompilerSet makeprg=make

