if has('terminal') " Vim 8 or later, MacVim

  " Asynchronously run an interactive shell command in a terminal window.
  " By default, the command is run in the directory of the current buffer, and
  " the terminal window is closed as soon as the job is done.
  "
  " cmd: the command to be run with its arguments, as a List
  " ...: an optional Dictionary of additional options, which are passed to
  " term_start().
  "
  " Returns: the buffer number of the terminal window.
  fun! local#term#run(cmd, ...) abort
    let l:bufnr = term_start(a:cmd, extend({
          \ 'cwd': expand('%:p:h'),
          \ 'term_rows': 20,
          \ }, get(a:000, 0, {})))
    return l:bufnr
  endf

  fun! local#term#send_keys(what)
    call term_sendkeys('', a:what)
    return ''
  endf

  " Open a new terminal buffer and bind it to the current buffer
  fun! local#term#open()
    let l:term_id = term_start(&shell, {'term_name': 'Terminal'})
    wincmd p
    let b:lf_bound_terminal = l:term_id
  endf

  fun! local#term#send(lines)
    if empty(get(b:, 'lf_bound_terminal', '')) || !bufexists(b:lf_bound_terminal)
      let b:lf_bound_terminal = str2nr(input('Terminal buffer: '))
    endif
    for l:line in a:lines
      if &ft == 'outlaw'
        let l:line = substitute(l:line, '^\s*|\s*', '', '')  " Remove leading |
      endif
      call term_sendkeys(b:lf_bound_terminal, l:line .. "\r")
      call s:term_wait(b:lf_bound_terminal)
    endfor
    call cursor(line('.') + 1, 1)
  endf

  if has('gui_running')
    fun! s:term_wait(bn)
    endf
  else
    fun! s:term_wait(bn)
      call term_wait(a:bn)
    endf
  endif

  fun! local#term#enter_normal_mode()
    return &buftype ==# 'terminal' && mode('') ==# 't' ? "\<c-w>N\<c-y>" : ''
  endf

  fun! local#term#toggle_scrollwheelup()
    if maparg('<scrollwheelup>', 't') ==# ''
      tnoremap <silent> <expr> <scrollwheelup> local#term#enter_normal_mode()
    else
      tunmap <scrollwheelup>
    endif
  endf

else

  fun! local#term#run(cmd, ...)
    call local#msg#err("Function non implemented")
  endf

  if !empty($TMUX)

    fun! local#term#open()
      call system('tmux split-window')
      call system('tmux last-pane')
    endf

    " Send the given text to a tmux pane
    fun! local#term#send(lines)
      if !exists('b:lf_bound_terminal') || empty(b:lf_bound_terminal)
        let b:lf_bound_terminal = input('Tmux pane number: ')
      endif
      for line in a:lines
        if &ft == 'outlaw'
          let l:line = substitute(l:line, '^\s*|\s*', '', '')  " Remove leading |
        endif
        call system('tmux -u send-keys -l -t ' .. b:lf_bound_terminal .. ' "" ' .. shellescape(line .. "\r"))
      endfor
    endf

  else

    fun! local#term#open()
      call local#msg#err("Function non implemented")
    endf

    fun! local#term#send(lines)
      call local#msg#err("Function non implemented")
    endf

  endif

endif

