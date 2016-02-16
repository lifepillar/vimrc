" Add warnings that should be ignored to this list:
let g:tex_ignored_warnings = []

" The following error format is adapted from vimtex (https://github.com/lervag/vimtex).

" Push file to file stack
CompilerSet errorformat=%-P**%f
CompilerSet errorformat+=%-P**\"%f\"

" Match errors
CompilerSet errorformat+=%E%f:%l:\ LaTeX\ %trror:\ %m
CompilerSet errorformat+=%E%f:%l:\ %m
CompilerSet errorformat+=%E!\ LaTeX\ %trror:\ %m
CompilerSet errorformat+=%E!LuaTeX\ %trror:\ %m
CompilerSet errorformat+=%E!\ %m

" More info for undefined control sequences
CompilerSet errorformat+=%Z<argument>\ %m

" More info for some errors
CompilerSet errorformat+=%Cl.%l\ %m

for s:w in g:tex_ignored_warnings
  let s:warning = escape(substitute(s:w, '[\,]', '%\\\\&', 'g'), ' ')
  execute 'CompilerSet errorformat+=%-G%.%#'. s:warning .'%.%#'
endfor

" Match warnings
CompilerSet errorformat+=%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#
CompilerSet errorformat+=%+W%.%#\ at\ lines\ %l--%*\\d
CompilerSet errorformat+=%+WLaTeX\ %.%#Warning:\ %m
CompilerSet errorformat+=%+W%.%#%.%#Warning:\ %m

" Parse biblatex warnings
CompilerSet errorformat+=%-C(biblatex)%.%#in\ t%.%#
CompilerSet errorformat+=%-C(biblatex)%.%#Please\ v%.%#
CompilerSet errorformat+=%-C(biblatex)%.%#LaTeX\ a%.%#
CompilerSet errorformat+=%-Z(biblatex)%m

" Parse hyperref warnings
CompilerSet errorformat+=%-C(hyperref)%.%#on\ input\ line\ %l.

" Ignore unmatched lines
CompilerSet errorformat+=%-G%.%#

let s:latexmk = 'max_print_line=2000\ latexmk\ -lualatex\ -cd\ -pv-\ -synctex=1\ -file-line-error\ -interaction=nonstopmode\ %:p:S'

if has('clientserver') " With MacVim, typeset in the background
  execute 'CompilerSet makeprg=('.s:latexmk.'\ >/dev/null\ 2>&1;mvim\ --remote-expr\ \"lf_tex\\#callback($?)\")&'
else
  execute 'CompilerSet makeprg='.s:latexmk
endif

