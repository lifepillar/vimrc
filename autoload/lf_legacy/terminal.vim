if has("nvim")

  fun! lf_legacy#terminal#open()
    botright new
    terminal
    let l:term_id = b:terminal_job_id
    call feedkeys("\<c-\>\<c-n>") " Exit Terminal (Insert) mode
    wincmd p
    let b:lf_bound_terminal = l:term_id
  endf

  fun! lf_legacy#terminal#send(lines)
    if !exists('b:lf_bound_terminal') || empty(b:lf_bound_terminal)
      let b:lf_bound_terminal = input('Terminal ID: ')
    endif
    call jobsend(b:lf_bound_terminal, add(a:lines, ''))
  endf

else " Older Vim

  fun! lf_legacy#terminal#open()
    call lf_msg#warn("Please run Vim inside a tmux session")
  endf

  fun! lf_legacy#terminal#send(lines)
    call lf_msg#warn("Please run Vim inside a tmux session")
  endf

endif
