let current_compiler = 'context'

CompilerSet errorformat=
      \%E%>%f:%l:\ %m,
      \%Cl.%l\ %m,
      \%+C\ \ %m.,
      \%+C%.%#-%.%#,
      \%+C%.%#[]%.%#,
      \%+C[]%.%#,
      \%+C%.%#%[{}\\]%.%#,
      \%+C<%.%#>%.%#,
      \%GOutput\ written\ on\ %m,
      \%GTeXExec\ \|\ run%m

CompilerSet makeprg=cd\ '%:p:h'\ &&\ context\ --nonstopmode\ --synctex=1\ %:t:S

