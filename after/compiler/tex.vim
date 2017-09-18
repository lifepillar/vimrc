" The following error format is adapted from vimtex
" (https://github.com/lervag/vimtex).

let g:tex_errorformat = ''
      \ . '%-P**%f,'
      \ . '%-P**\"%f\",'
      \ . '%E%f:%l: LaTeX %trror: %m,'
      \ . '%E%f:%l: %m,'
      \ . '%E! LaTeX %trror: %m,'
      \ . '%E!LuaTeX %trror: %m,'
      \ . '%E! %m,'

" More info for undefined control sequences
let g:tex_errorformat .= '%Z<argument> %m,'

" More info for some errors
let g:tex_errorformat .= '%Cl.%l %m,'

if !get(g:, 'lf_latex_no_warnings', 0)
  " Match warnings
  let g:tex_errorformat .= '%+WLaTeX %.%#Warning: %.%#line %l%.%#,'
        \ . '%+W%.%# at lines %l--%*\\d,'
        \ . '%+W%.%# at line %l,'
        \ . '%+WLaTeX %.%#Warning: %m,'
        \ . '%+W%.%#%.%#Warning: %m,'
endif

" Parse biblatex warnings
let g:tex_errorformat .= '%-C(biblatex)%.%#in t%.%#,'
      \ . '%-C(biblatex)%.%#Please v%.%#,'
      \ . '%-C(biblatex)%.%#LaTeX a%.%#,'
      \ . '%-Z(biblatex)%m,'

" Parse hyperref warnings
let g:tex_errorformat .= '%-C(hyperref)%.%#on input line %l.,'

" Ignore unmatched lines
let g:tex_errorformat .= '%-G%.%#'

execute 'CompilerSet errorformat=' . escape(g:tex_errorformat, ' ')

CompilerSet makeprg=make
