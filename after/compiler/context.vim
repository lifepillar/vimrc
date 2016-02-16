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

let s:context = 'cd\ ''%:p:h''\ &&\ context\ --nonstopmode\ --synctex=1\ %:t:S'

if has('clientserver') " With MacVim, typeset in the background
  execute 'CompilerSet makeprg=('.s:context.'\ >/dev/null\ 2>&1;mvim\ --remote-expr\ \"lf_tex\\#callback($?)\")&'
else
  execute 'CompilerSet makeprg='.s:context
endif

