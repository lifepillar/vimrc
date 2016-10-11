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

" Asynchronous typesetting {{{
let s:tex_jobs = []

" Print the status of TeX jobs
function! lf_tex#job_status()
  let l:jobs = filter(s:tex_jobs, 'job_status(v:val) == "run"')
  let l:n = len(l:jobs)
  call lf_msg#notice(
        \ 'There '.(l:n == 1 ? 'is' : 'are').' '.(l:n == 0 ? 'no' : l:n)
        \ .' job'.(l:n == 1 ? '' : 's').' running'
        \ .(l:n == 0 ? '.' : ' (' . join(l:jobs, ', ').').'))
endfunction

" Stop all TeX jobs
function! lf_tex#stop_jobs()
  let l:jobs = filter(s:tex_jobs, 'job_status(v:val) == "run"')
  for job in l:jobs
    call job_stop(job)
  endfor
  sleep 1
  let l:tmp = []
  for job in l:jobs
    if job_status(job) == "run"
      call add(l:tmp, job)
    endif
  endfor
  let s:tex_jobs = l:tmp
  if empty(s:tex_jobs)
    call lf_msg#notice('Done. No jobs running.')
  else
    call lf_msg#warn('There are still some jobs running. Please try again.')
  endif
endfunction

" Function called when typesetting in the background is over.
" bufnr: number of the buffer that was active when the job was launched
" path: path of the typeset document (it may be different from bufnr's path)
fun! s:callback(bufnr, path, job, status)
  if index(s:tex_jobs, a:job) != -1
    call remove(s:tex_jobs, index(s:tex_jobs, a:job))
  endif
  if a:status < 0 " Assume the job was terminated
    return
  endif
  " Get info about the current window
  let l:winid = win_getid()               " Save window id
  let l:efm = &l:errorformat              " Save local errorformat
  let l:cwd = fnamemodify(getcwd(), ":p") " Save local working directory
  " Set errorformat to parse TeX errors
  execute 'setl efm=' . escape(g:tex_errorformat, ' ')
  try " Set cwd to expand error file correctly
    execute 'lcd' fnameescape(fnamemodify(a:path, ':h'))
  catch /.*/
    execute 'setl efm=' . escape(l:efm, ' ')
    throw v:exception
  endtry
  try
    execute 'cgetfile' fnameescape(fnamemodify(a:path, ':r') . '.log')
    botright cwindow
  finally " Restore cwd and errorformat
    execute win_id2win(l:winid) . 'wincmd w'
    execute 'lcd ' . fnameescape(l:cwd)
    execute 'setl efm=' . escape(l:efm, ' ')
  endtry
  if a:status == 0
    call lf_msg#notice('Success!')
  else
    call lf_msg#err('There are errors.')
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
      call s:callback(self.lf_data[0], self.lf_data[1], a:job_id, a:data)
    else
      call lf_msg#err('Unexpected event')
    endif
  endf
else
  fun! lf_tex#callback(bufnr, path, job, status)
    call s:callback(a:bufnr, a:path, a:job, a:status)
  endf
endif

fun! lf_tex#lualatex()
  return 'latexmk -lualatex -cd -pv- -synctex='
      \ . (get(b:, 'tex_synctex', get(g:, 'tex_synctex', 1)) ? '1' : '0')
      \ . ' -file-line-error -interaction=nonstopmode'
endf

fun! lf_tex#typeset(...) abort
  let l:path = fnamemodify(strlen(a:000[0]) > 0 ? a:1 : expand("%"), ":p")
  let l:cmd = add(split(lf_tex#lualatex()), l:path)
  if get(g:, 'tex_debug', 0)
    call lf_msg#warn('Cwd: ' . fnamemodify(getcwd(), ':p'))
    call lf_msg#warn('Path: ' . l:path)
    call lf_msg#warn(join(l:cmd))
  else
    call lf_msg#notice('Typesetting...')
  endif
  call add(s:tex_jobs, lf_job#start(l:cmd,
        \ 'lf_tex#callback',
        \ [bufnr("%"), l:path]
        \ ))
endf
" }}}
" vim: sw=2 fdm=marker

