fun! lf_file#swap_exists(file)
  let l:n = len(split(glob(fnamemodify(v:swapname, ":r").".*"), "\n"))
  echohl WarningMsg
  echon 'Swap file exists: ' . fnamemodify(v:swapname, ":t") .
        \ (l:n > 1 ? ' (and other ' . (l:n-1) . ' swap file' . (l:n > 2 ? 's' : '') . ')' : '')
  echohl None
  echon "\n". 'read-(o)nly (e)dit (r)ecover (d)elete (q)uit (a)bort (ENTER for details) '
  let v:swapchoice = nr2char(getchar())
  echo "\r"
endf
