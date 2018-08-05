" Synchronously execute a non-interactive Git command in the directory
" containing the file of the current buffer, and send the output to a new
" buffer.
" args: a List providing the arguments for git
" where: a Vim command specifying where the window should be opened
fun! lf_git#output(args, where) abort
  call lf_buffer#cmd(expand("%:p:h"), ['git'] + a:args, a:where)
  setlocal nomodifiable
endf

" Show a vertical diff (use <c-w> K to arrange horizontally)
" between the current buffer and its last committed version.
fun! lf_git#diff() abort
  let l:ft = getbufvar("%", '&ft') " Get the file type
  let l:fn = expand('%:t')
  call lf_git#output(['show', 'HEAD:./'.l:fn], 'rightbelow vertical')
  let &l:filetype = l:ft
  execute 'silent file' l:fn '[HEAD]'
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  diffthis
endf

" Show a three-way diff. Useful for fixing merge conflicts.
" This assumes that the current file is the working copy, of course.
fun! lf_git#three_way_diff() abort
  let l:ft = getbufvar("%", "&ft") " Get the file type
  let l:fn = expand('%:t')
  " Show the version from the current branch on the left
  call lf_git#output(['show', ':2:./'.l:fn], "leftabove vertical")
  let &l:filetype = l:ft
  execute 'silent file' l:fn '[OURS]'
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  " Show version from the other branch on the right
  call lf_git#output(['show', ':3:./'.l:fn], 'rightbelow vertical')
  let &l:filetype = l:ft
  execute 'silent file' l:fn '[OTHER]'
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  diffthis
endf

if has('terminal') " Vim 8 or later, MacVim

  fun! s:tig(cmd)
    botright call term_start(extend(['tig'], a:cmd), { 'cwd': expand("%:p:h"), 'term_finish': 'close' })
  endf

  fun! lf_git#blame()
    call s:tig(['blame', '+'.expand(line('.')), '--', expand('%:t')])
  endf

  fun! lf_git#status()
    call s:tig(['status'])
  endf

  fun! lf_git#push()
    call lf_msg#notice('Pushing...')
    call term_start(['git', '-C', expand("%:p:h"), 'push'],
          \ { 'exit_cb': function('lf_job#callback', [bufnr('%')])})
    wincmd p
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
    call lf_git#output([a:cmd], 'botright')
  endf
end
