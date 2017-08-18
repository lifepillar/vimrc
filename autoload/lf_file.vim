fun! lf_file#swap_exists(file)
  " Note that glob() honors 'wildignore', which contains *.swp (see my vimrc)
  " So, l:n is the number of *additional* swap files.
  let l:n = len(split(glob(fnamemodify(v:swapname, ":r").".*"), "\n"))
  echohl WarningMsg
  echon 'A swap file exists: ' . fnamemodify(v:swapname, ":t") .
        \ (l:n > 0 ? ' (and ' . l:n . ' more)' : '')
  echohl None
  echon "\n". 'read-(o)nly (e)dit (r)ecover (d)elete (q)uit (a)bort (ENTER for details) '
  let v:swapchoice = nr2char(getchar())
  echo "\r"
endf
