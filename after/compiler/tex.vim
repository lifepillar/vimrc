CompilerSet makeprg=latexmk

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

" Ignore some warnings
let g:latex_ignored_warnings = [
      \]
for w in g:latex_ignored_warnings
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

" The Dispatch plugin deliberately removes the above catchall format from
" errorformat. This is somewhat annoying, but we may work around that by adding
" the catchall format twice. This is the purpose of the following line. Note
" that we cannot simply append exactly the same string twice because Vim is
" smart enough to filter duplicate formats (note the additional comma and dot).
" For more information, see: https://github.com/tpope/vim-dispatch/issues/76.
CompilerSet errorformat+=%-G%.%#,.

