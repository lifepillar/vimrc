" Synchronously execute a non-interactive Git command in the directory
" containing the file of the current buffer, and send the output to a new
" buffer.
" args: a List providing the arguments for git
" opencmd : command to open the terminal window.
fun! lf_git#output(args, opencmd)
  let l:args = join(map(a:args, 'v:val !~# "\\v^[%#<]" || expand(v:val) == "" ? v:val : shellescape(expand(v:val))'))
  let l:gitdir = shellescape(expand("%:p:h"))
  execute a:opencmd "new"
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  execute '%!git -C' l:gitdir l:args
  setlocal nomodifiable
  wincmd p
endf

" Show a vertical diff (use <c-w> K to arrange horizontally)
" between the current buffer and its last committed version.
fun! lf_git#diff()
  let l:ft = getbufvar("%", '&ft') " Get the file type
  call lf_git#output(['show', 'HEAD:./'.shellescape(expand('%:t'))], 'rightbelow vertical')
  diffthis
  wincmd p
  let &l:filetype = l:ft
  silent file [HEAD]
  autocmd BufWinLeave <buffer> diffoff!
  diffthis
  wincmd p
endf

" Show a three-way diff. Useful for fixing merge conflicts.
" This assumes that the current file is the working copy, of course.
fun! lf_git#three_way_diff()
  let l:ft = getbufvar("%", "&ft") " Get the file type
  " Show the version from the current branch on the left
  call lf_git#output(['show', ':2:./'.shellescape(expand('%:t'))], "leftabove vertical")
  setlocal buflisted
  let &l:filetype = l:ft
  file OURS
  autocmd BufWinLeave <buffer> diffoff!
  diffthis
  wincmd p
  " Show version from the other branch on the right
  call lf_git#output(['show', ':3:./'.shellescape(expand('%:t'))], 'rightbelow vertical')
  setlocal buflisted
  let &l:filetype = l:ft
  file OTHER
  autocmd BufWinLeave <buffer> diffoff!
  diffthis
  wincmd p
  diffthis
endf

if has('terminal') " Vim 8 or later, MacVim

  fun! s:tig(cmd)
    let l:oldcwd = getcwd()
    execute 'lcd' fnameescape(expand("%:p:h"))
    echomsg getcwd()
    try
      execute 'botright terminal ++close tig' a:cmd
    finally
      execute 'lcd' fnameescape(l:oldcwd)
    endtry
  endf

  fun! lf_git#blame()
    call s:tig('blame +'.expand(line('.')).' -- %:t') " FIXME: names with spaces?
  endf

  fun! lf_git#status()
    call s:tig('status')
  endf

  fun! lf_git#push() " FIXME: names with spaces?
    execute 'terminal git -C %:p:h push'
  endf

  fun! lf_git#execute(cmd)
    execute 'botright terminal git -C %:p:h' a:cmd
  endf

else " NeoVim, older Vim

  fun! lf_git#blame()
    call lf_legacy#git#blame()
  endf

  fun! lf_git#status()
    call lf_legacy#git#status()
  endf

  fun! lf_git#push()
    call lf_legacy#git#push()
  endf

  fun! lf_git#execute(cmd)
    call lf_git#output(cmd, 'botright')
  endf
end
