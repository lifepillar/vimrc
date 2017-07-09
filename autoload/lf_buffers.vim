" Send the output of a Vim command to a new scratch buffer
fun! lf_buffers#cmd(cmd)
  botright new +setlocal\ buftype=nofile\ bufhidden=wipe\ nobuflisted\ noswapfile\ nowrap
  call append(0, split(execute(a:cmd), "\n"))
endf
