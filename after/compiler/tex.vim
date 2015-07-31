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
CompilerSet errorformat+=%E!\ %m

" More info for undefined control sequences
CompilerSet errorformat+=%Z<argument>\ %m

" More info for some errors
CompilerSet errorformat+=%Cl.%l\ %m

for w in g:tex_ignored_warnings
  let warning = escape(substitute(w, '[\,]', '%\\\\&', 'g'), ' ')
  exe 'CompilerSet errorformat+=%-G%.%#'. warning .'%.%#'
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

