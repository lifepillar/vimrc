" Ignore syntax highlighting, filetype, etc…
" See also: http://vim.wikia.com/wiki/Faster_loading_of_large_files
fun! lf_buffer#large(name)
  let b:lf_large_file = 1
  syntax clear
  set eventignore+=FileType
  let &backupskip = join(add(split(&backupskip, ','), a:name), ',')
  setlocal foldmethod=manual nofoldenable noswapfile noundofile
  augroup lf_large_buffer
    autocmd!
    autocmd BufWinEnter <buffer> call <sid>restore_eventignore()
  augroup END
endf

fun! s:restore_eventignore()
  set eventignore-=FileType
  autocmd! lf_large_buffer
  augroup! lf_large_buffer
endf

" Delete all buffers except the current one
fun! lf_buffer#delete_others()
  let l:bl = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  execute (bufnr('') > l:bl[0] ? 'confirm '.l:bl[0].',.-bd' : '') (bufnr('') < l:bl[-1] ? '|confirm .+,$bd' : '')
endf

" Wipe all buffers except the current one
fun! lf_buffer#wipe_others()
  let l:min = min(filter(range(1, bufnr('$')), 'bufexists(v:val)'))
  execute (bufnr('') > l:min ? 'confirm '.l:min.',.-bw' : '') (bufnr('') < bufnr('$') ? '|confirm .+,$bw' : '')
endf

" Clear (delete the content) of the given buffer.
fun! lf_buffer#clear(file_pattern)
  if bufnr(a:file_pattern) > -1
    silent execute bufnr(a:file_pattern) 'bufdo' '1,$delete'
    silent execute 'buffer' bufnr(@#)
  endif
endf

fun! lf_buffer#swap_exists(file)
  " Note that glob() honors 'wildignore', which contains *.swp (see my vimrc)
  " So, l:n is the number of *additional* swap files.
  let l:n = len(split(glob(fnamemodify(v:swapname, ":r").".*"), "\n"))
  echohl WarningMsg
  echon 'A swap file exists: ' . fnamemodify(v:swapname, ":t") .
        \ (l:n > 0 ? ' (and ' . l:n . ' more)' : '')
  echohl None
  echon "\n". 'read-(o)nly (e)dit (r)ecover (d)elete (q)uit (a)bort (ENTER for details) '
  let v:swapchoice = nr2char(getchar())
  echo "\r"
endf

