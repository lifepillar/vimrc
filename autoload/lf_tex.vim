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
  " The command assumes Skim.app installed with Homebrew Cask (which symlinks
  " displayline in /usr/local/bin)
  silent execute join([
        \ '!displayline',
        \ line('.'),
        \ shellescape(lf_tex#file('pdf')),
        \ shellescape(expand('%:p'))
        \ ])
  if !has("gui_running")
    redraw!
  endif
endf

fun! lf_tex#clean()
  let l:currdir = expand("%:p:h")
  let l:tmpdirs = ['out']
  let l:suffixes = [
        \ 'aux', 'bbl', 'blg', 'fdb_latexmk', 'fls', 'log', 'nav',
        \ 'out', 'snm', 'tmp', 'toc', 'synctex.gz', 'synctex.gz(busy)',
        \ 'tuc', 'vimout', 'vrb'
        \ ]
  for ff in glob(l:currdir . '/*.{' . join(l:suffixes, ',') . '}', 1, 1)
    call delete(ff)
  endfor
  for dd in l:tmpdirs
    let l:subdir = l:currdir . '/' . dd
    if isdirectory(l:subdir)
      for ff in glob(l:subdir . '/*.{' . join(l:suffixes, ',') . '}', 1, 1)
        call delete(ff)
      endfor
    endif
    call delete(l:subdir) " delete directory (only if empty)
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
    botright copen
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

