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
      call WaitFor('term_getline('.b:lf_bound_terminal.')!=""')
    endfor
  endf

  " Copied verbatim from vim/src/testdir/shared.vim.
  " This appears to be more robust than term_wait(). See also:
  "
  "     https://github.com/macvim-dev/macvim/issues/542
  "     https://github.com/vim/vim/issues/1985
  func! WaitFor(expr, ...)
    let timeout = get(a:000, 0, 10)
    " using reltime() is more accurate, but not always available
    if has('reltime')
      let start = reltime()
    else
      let slept = 0
    endif
    for i in range(timeout / 10)
      try
        if eval(a:expr)
          if has('reltime')
            return float2nr(reltimefloat(reltime(start)) * 1000)
          endif
          return slept
        endif
      catch
      endtry
      if !has('reltime')
        let slept += 10
      endif
      sleep 10m
    endfor
    return timeout
  endfunc

else

  fun! lf_terminal#open()
    call lf_msg#warn("Please run Vim inside a tmux session")
  endf

  fun! lf_terminal#send(lines)
    call lf_msg#warn("Please run Vim inside a tmux session")
  endf

endif

