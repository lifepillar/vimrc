fun! lf_file#swap_exists()
  echohl WarningMsg
  echon 'Swap file exists: ' . v:swapname
  echohl None
  echon "\n". 'read-(o)nly (e)dit (r)ecover (d)elete (q)uit (a)bort (ENTER for details) '
  let v:swapchoice = nr2char(getchar())
  echo "\r"
endf
