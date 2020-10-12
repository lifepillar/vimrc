" Diff between the current buffer and the version currently checked out.
fun! local#fossil#diff() abort
  let l:ft = getbufvar("%", '&ft')
  let l:fn = expand('%:t')
  call local#run#cmd(['fossil', 'cat', l:fn], { 'pos': 'rightbelow vertical'})
  let &l:filetype = l:ft
  execute 'silent file' l:fn '[CHECKOUT]'
  setlocal nomodifiable
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  diffthis
endf

fun! local#fossil#three_way_diff() abort
  let l:ft = getbufvar("%", "&ft") " Get the file type
  " Show the version from the current branch on the left
  execute 'leftabove vsplit' expand("%:p") .. '-baseline'
  let &l:filetype = l:ft
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  " Show version from the other branch on the right
  execute 'rightbelow vsplit' expand("%:p") .. '-merge'
  let &l:filetype = l:ft
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  diffthis
endf

