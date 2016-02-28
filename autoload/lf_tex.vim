fun! lf_tex#file(suffix)
  return expand('%:p:r') . '.' . a:suffix
endf

fun! lf_tex#preview()
  silent execute '!open -a Skim.app ' . shellescape(lf_tex#file('pdf')) . ' >&/dev/null 2>&1 &'
  if !has("gui_running")
    redraw!
  endif
endf

fun! lf_tex#forward_search()
  silent execute join([
        \ '!${HOME}/Applications/Skim.app/Contents/SharedSupport/displayline',
        \ line('.'),
        \ shellescape(lf_tex#file('pdf')),
        \ shellescape(expand('%:p'))
        \ ])
  if !has("gui_running")
    redraw!
  endif
endf

fun! lf_tex#clean()
  let l:files = map([
        \ 'aux', 'bbl', 'blg', 'fdb_latexmk', 'fls', 'log',
        \ 'toc', 'synctex.gz', 'synctex.gz(busy)', 'tuc'
        \ ],
        \ 'lf_tex#file(v:val)')
  for ff in l:files
    call delete(ff)
  endfor
  call lf_msg#notice("Aux files removed")
endf

" Callback function used when a document is typeset asynchronously in MacVim
fun! lf_tex#callback(exit_status)
  " The following is adapted from LaTeX-Box
  " set cwd to expand error file correctly
  let l:cwd = fnamemodify(getcwd(), ':p')
  execute 'lcd ' . fnameescape(expand('%:p:h'))
  try
    execute 'cgetfile ' . fnameescape(lf_tex#file('log'))
  finally
    " restore cwd
    execute 'lcd ' . fnameescape(l:cwd)
  endtry
  if self.status == 0
    call lf_msg#notice("Success!")
    cclose
  else
    copen
  endif
endf

