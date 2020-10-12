fun! local#tex#file(suffix)
  return expand('%:p:r') . '.' . a:suffix
endf

if has('mac')
  let s:default_viewer = 'TeXShop'
else
  let s:default_viewer = 'Okular'
endif

fun! s:view_in_texshop(f)
  silent execute '!open -a TeXShop.app ' .. a:f .. ' >/dev/null 2>&1'
endf

fun! s:search_in_texshop(f, l)
  " For texshop.sh, see TeXShop.app > Help > Changes and search for 'sync_preview'
  call local#run#job(['/usr/local/bin/texshop.sh', line('.'), '1', a:f])
endf

fun! s:view_in_skim(f)
  silent execute '!open -a Skim.app ' .. a:f .. ' >/dev/null 2>&1'
endf

fun! s:search_in_skim(f, l)
  call local#run#job(['displayline', line('.'), local#tex#file('pdf'), a:f])
endf

fun! s:view_in_okular(f)
  silent execute '!okular --unique ' .. a:f .. ' >/dev/null 2>&1 &'
endf

fun! s:search_in_okular(f, l)
  call local#run#job(['okular', '--unique', local#tex#file('pdf') .. '#src:' .. line('.') .. a:f])
endf

fun! s:view_in_zathura(f)
  silent execute '!zathura ' .. a:f .. ' >/dev/null 2>&1 &'
endf

" For backward search, create ~/.config/zathurarc with the following content:
"     set synctex true
"     set synctex-editor-command "gvim --remote-silent +%{line} %{input}"
" Use Ctrl-Click to jump to GVim
fun! s:search_in_zathura(f, l)
  call local#run#job(['zathura', '--synctex-forward', line('.') .. ':1:' .. a:f, local#tex#file('pdf')])
endf

let s:preview = {
      \ 'TeXShop': function('s:view_in_texshop'),
      \ 'Skim': function('s:view_in_skim'),
      \ 'Okular': function('s:view_in_okular'),
      \ 'Zathura': function('s:view_in_zathura'),
      \ }

let s:forward_search = {
      \ 'TeXShop': function('s:search_in_texshop'),
      \ 'Skim': function('s:search_in_skim'),
      \ 'Okular': function('s:search_in_okular'),
      \ 'Zathura': function('s:search_in_zathura'),
      \ }

fun! local#tex#preview()
  let l:viewer = get(g:, 'lf_tex_previewer', s:default_viewer)
  if has_key(s:preview, l:viewer)
    call s:preview[l:viewer](shellescape(local#tex#file('pdf')))
    if !has("gui_running")
      redraw!
    endif
  else
    call local#msg#err('Unknown previewer: ' .. l:viewer .. '. Please set g:lf_tex_previewer')
  endif
endf

fun! local#tex#forward_search()
  let l:viewer = get(g:, 'lf_tex_previewer', s:default_viewer)
  if has_key(s:preview, l:viewer)
    call s:forward_search[l:viewer](expand('%:p'), line('.'))
  else
    call local#msg#err('Unknown previewer: ' .. l:viewer .. '. Please set g:lf_tex_previewer')
  endif
endf

fun! local#tex#clean()
  let l:currdir = expand("%:p:h")
  let l:tmpdirs = ['out']
  let l:suffixes = [
        \ 'aux', 'bbl', 'blg', 'dvi', 'fdb_latexmk', 'fls', 'loc', 'log', 'nav',
        \ 'out', 'snm', 'soc', 'tmp', 'toc', 'synctex', 'synctex.gz', 'synctex.gz(busy)',
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
    call delete(l:subdir, 'd') " delete directory (only if empty)
  endfor
  call local#msg#notice("Aux files removed")
endf

" Asynchronous typesetting {{{
let s:tex_jobs = []

" Print the status of TeX jobs
function! local#tex#job_status()
  let l:jobs = filter(s:tex_jobs, 'job_status(v:val) == "run"')
  let l:n = len(l:jobs)
  call local#msg#notice(
        \ 'There '.(l:n == 1 ? 'is' : 'are').' '.(l:n == 0 ? 'no' : l:n)
        \ .' job'.(l:n == 1 ? '' : 's').' running'
        \ .(l:n == 0 ? '.' : ' (' . join(l:jobs, ', ').').'))
endfunction

" Stop all TeX jobs
function! local#tex#stop_jobs()
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
    call local#msg#notice('Done. No jobs running.')
  else
    call local#msg#warn('There are still some jobs running. Please try again.')
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
    call local#msg#notice('Success!')
  else
    call local#msg#err('There are errors.')
  endif
endf

if has("nvim")
  fun! local#tex#callback(job_id, data, event)
    if a:event == 'exit'
      call s:callback(self.lf_data[0], self.lf_data[1], a:job_id, a:data)
    else
      call local#msg#err('Unexpected event')
    endif
  endf
else
  fun! local#tex#callback(bufnr, path, job, status)
    call s:callback(a:bufnr, a:path, a:job, a:status)
  endf
endif

fun! local#tex#typeset(options, ...) abort
  let l:path = fnamemodify(a:0 > 0 && strlen(a:1) > 0 ? a:1 : expand("%"), ":p") " Full path
  let l:cwd = fnamemodify(l:path, ":h")                                          " Working directory
  let l:filename = fnamemodify(l:path, ":t")                                     " Name of the file to typeset
  let l:cmd = extend(extend(["latexmk"], get(a:options, "latexmk", [])), [
        \ "-pv-",
        \ "-synctex=" . (get(b:, "tex_synctex", get(g:, "tex_synctex", 1)) ? "1" : "0"),
        \ "-file-line-error",
        \ "-interaction=nonstopmode",
        \ l:filename])
  call local#msg#notice('Typesetting...')
  if get(a:options, "use_term", 0)
    call local#term#run(l:cmd, {"cwd": l:cwd})
  else
    call add(s:tex_jobs, local#run#job(l:cmd, {
          \ "cb": "local#tex#callback",
          \ "cwd": l:cwd,
          \ "args": [bufnr("%"), l:path]
          \ }))
  endif
endf
" }}}
" vim: sw=2 fdm=marker

