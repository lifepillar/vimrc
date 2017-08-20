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

elseif !empty($TMUX)

  fun! lf_terminal#open()
    call system('tmux split-window')
    call system('tmux last-pane')
  endf

  " Send the given text to a tmux pane
  fun! lf_terminal#send(lines)
    if !exists('b:lf_bound_terminal') || empty(b:lf_bound_terminal)
      let b:lf_bound_terminal = input('Tmux pane number: ')
    endif
    for line in a:lines
      call system('tmux -u send-keys -l -t '.b:lf_bound_terminal.' "" '.shellescape(line."\r"))
    endfor
  endf

elseif has('terminal')

  " Open a new terminal buffer and bind it to the current buffer
  fun! lf_terminal#open()
    let l:term_id = term_start(&shell, {'term_name': 'Terminal'})
    wincmd p " Back to previous window
    let b:lf_bound_terminal = l:term_id
  endf

  fun! lf_terminal#send(lines)
    if !exists('b:lf_bound_terminal') || empty(b:lf_bound_terminal)
      let b:lf_bound_terminal = str2nr(input('Terminal buffer: '))
    endif
    for l:line in a:lines
      call term_sendkeys(b:lf_bound_terminal, l:line . "\<cr>")
      call s:term_wait(b:lf_bound_terminal)
    endfor
  endf

  if has('gui')
    fun! s:term_wait(bn)
    endf
  else
    fun! s:term_wait(bn)
      call term_wait(a:bn)
    endf
  endif
else

  fun! lf_terminal#open()
    call lf_msg#warn("Please run Vim inside a tmux session")
  endf

  fun! lf_terminal#send(lines)
    call lf_msg#warn("Please run Vim inside a tmux session")
  endf

endif

