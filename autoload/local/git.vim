" Synchronously execute a non-interactive Git command in the directory
" containing the file of the current buffer, and send the output to a new
" buffer.
"
" args: a List providing the arguments for git
" where: a Vim command specifying where the window should be opened
fun! s:git(args, where) abort
  call lf_run#cmd(['git'] + a:args, {'pos': a:where})
  setlocal nomodifiable
endf

" Show a vertical diff between the current buffer and its last committed
" version.
fun! local#git#diff() abort
  let l:ft = getbufvar("%", '&ft') " Get the file type
  let l:fn = expand('%:t')
  call s:git(['show', 'HEAD:./' .. l:fn], 'rightbelow vertical')
  let &l:filetype = l:ft
  execute 'silent file' l:fn '[HEAD]'
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  diffthis
endf

" Show a three-way diff. Useful for fixing merge conflicts.
" This assumes that the current file is the working copy, of course.
fun! local#git#three_way_diff() abort
  let l:ft = getbufvar("%", "&ft") " Get the file type
  let l:fn = expand('%:t')
  " Show the version from the current branch on the left
  call s:git(['show', ':2:./' .. l:fn], "leftabove vertical")
  let &l:filetype = l:ft
  execute 'silent file' l:fn '[OURS]'
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  " Show version from the other branch on the right
  call s:git(['show', ':3:./' .. l:fn], 'rightbelow vertical')
  let &l:filetype = l:ft
  execute 'silent file' l:fn '[OTHER]'
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  diffthis
endf

