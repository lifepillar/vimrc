" Execute a non-interactive Git command in the directory containing
" the file of the current buffer, and send the output to a new buffer.
" args: a string of arguments for the commmand
" pos: a letter specifying the position of the new buffer (see s:runShellCommand()).
fun! lf_git#exec(args, pos)
  call lf_shell#run("git -C %:p:h " . a:args, a:pos)
endf

" Show a vertical diff (use <c-w> K to arrange horizontally)
" between the current buffer and its last committed version.
fun! lf_git#diff()
  let l:ft = getbufvar("%", '&ft') " Get the file type
  call lf_git#exec("show HEAD:./" . shellescape(expand("%:t")), 'r')
  let &l:filetype = l:ft
  file HEAD
  autocmd BufWinLeave <buffer> diffoff!
  diffthis
  wincmd p
  diffthis
endf

" Show a three-way diff. Useful for fixing merge conflicts.
" This assumes that the current file is the working copy, of course.
fun! lf_git#three_way_diff()
  let l:filename = shellescape(expand("%:t"))
  let l:ft = getbufvar("%", "&ft") " Get the file type
  " Show the version from the current branch on the left
  call lf_git#exec("show :2:./" . l:filename, "l")
  setlocal buflisted
  let &l:filetype = l:ft
  file OURS
  autocmd BufWinLeave <buffer> diffoff!
  diffthis
  wincmd p
  " Show version from the other branch on the right
  call lf_git#exec("show :3:./" . l:filename, "r")
  setlocal buflisted
  let &l:filetype = l:ft
  file OTHER
  autocmd BufWinLeave <buffer> diffoff!
  diffthis
  wincmd p
  diffthis
endf

