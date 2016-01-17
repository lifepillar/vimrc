" Open a new terminal buffer and bind it to the current buffer
fun! lf_nvim_terminal#open()
  below new
  terminal
  let l:term_id = b:terminal_job_id
  call feedkeys("\<c-\>\<c-n>") " Exit Terminal (Insert) mode
  wincmd p
  let b:lifepillar_bound_terminal = l:term_id
endf

fun! lf_nvim_terminal#send(...)
  if !exists('b:lifepillar_bound_terminal')
    let b:lifepillar_bound_terminal = input('Terminal ID: ')
  endif
  if a:0 == 0
    let lines = [getline('.')]
  elseif getpos("'>") != [0, 0, 0, 0]
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    call setpos("'>", [0, 0, 0, 0])
    call setpos("'<", [0, 0, 0, 0])

    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][:col2 - 1]
    let lines[0] = lines[0][col1 - 1:]
  else
    let lines = getline(a:1, a:2)
  end
  call jobsend(b:lifepillar_bound_terminal, add(lines, ''))
endf

