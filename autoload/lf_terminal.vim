if has('nvim')

  " Open a new terminal buffer and bind it to the current buffer
  fun! lf_terminal#open()
    below new
    terminal
    let l:term_id = b:terminal_job_id
    call feedkeys("\<c-\>\<c-n>") " Exit Terminal (Insert) mode
    wincmd p
    let b:lf_bound_terminal = l:term_id
  endf

  " Send the given text to a terminal window
  fun! lf_terminal#send(lines)
    if !exists('b:lf_bound_terminal') || empty(b:lf_bound_terminal)
      let b:lf_bound_terminal = input('Terminal ID: ')
    endif
    call jobsend(b:lf_bound_terminal, add(a:lines, ''))
  endf

elseif $TMUX != ""

  fun! lf_terminal#open()
    call lf_msg#warn("Not implemented yet")
  endf

  " Send the given text to a tmux pane
  fun! lf_terminal#send(lines)
    if !exists('b:lf_bound_terminal') || empty(b:lf_bound_terminal)
      let b:lf_bound_terminal = input('Tmux pane number: ')
    endif
    if len(join(a:lines)) > 1000
      let temp = tempname()
      call writefile(a:lines, temp, 'b')
      call system('tmux load-buffer '.temp.' \; paste-buffer -d -t '.b:lf_bound_terminal)
    else
      call system('tmux send-keys -l -t '.b:lf_bound_terminal.' "" '.shellescape(join(add(a:lines,''), "\r")))
    endif
  endf

else

  fun! lf_terminal#open()
    call lf_msg#warn("Not implemented yet")
  endf

  fun! lf_terminal#send(lines)
    call lf_msg#warn("Not implemented yet")
  endf

endif

