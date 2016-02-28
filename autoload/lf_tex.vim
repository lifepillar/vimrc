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
        \ 'out', 'toc', 'synctex.gz', 'synctex.gz(busy)', 'tuc'
        \ ],
        \ 'lf_tex#file(v:val)')
  for ff in l:files
    call delete(ff)
  endfor
  call lf_msg#notice("Aux files removed")
endf

" Callback function used when a document is typeset asynchronously
fun! s:callback(job, status)
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
  if a:status == 0
    cclose
    call lf_msg#notice("Success!")
  else
    copen
  endif
endf

if has("nvim")
  fun! lf_tex#callback(job_id, data, event)
    " Apparently, NeoVim does not autoload the callback function passed to
    " jobstart(). So, the function must be explicitly called once in order to
    " load it, before calling jobstart(). This is the reason why we define
    " this dummy 'load' event.
    if a:event == 'load' | return | endif
    if a:event == 'exit'
      call s:callback(a:job_id, a:data)
    else
      call lf_msg#err('Unexpected event')
    endif
  endf
else
  fun! lf_tex#callback(job, status)
    call s:callback(a:job, a:status)
  endf
endif

