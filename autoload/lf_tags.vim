" Switch between header and implementation files.
" A tags file must have been previously created with `ctags --extra=+f`.
" The dictionary maps the suffix of the current file to a list of candidate
" suffixes for alternate files.
fun! lf_tags#alt_file()
  execute "tjump" '/^'.expand("%:t:r").'\.\('.join(get(
        \ {
        \ 'c':   ['h'],
        \ 'cpp': ['h','hpp'],
        \ 'h':   ['c','cpp'],
        \ 'hpp': ['cpp']
        \ },
        \  expand("%:e"), ['UNKNOWN EXTENSION']), '\\|') . '\)$'
endf

fun! lf_tags#ctags(args)
  if empty(tagfiles()) " New tags file
    let l:idx = inputlist(["Choose which directory to process:", "1. ".getcwd(), "2. ".expand("%:p:h"), "3. Other"])
    let l:dir = (l:idx == 1 ? getcwd() : (l:idx == 2 ? expand("%:p:h") : (l:idx == 3 ? fnamemodify(input("Directory: ", "", "file"), ':p') : "")))
    if strlen(l:dir) <= 0
      call lf_msg#notice("Cancelled.")
      return
    endif
    let l:dirs = [fnamemodify(l:dir, ':p')]
  else
    let l:dirs = map(tagfiles(), { i,v -> fnamemodify(v, ':p:h') })
  endif
  for l:tagdir in l:dirs
    if !isdirectory(l:tagdir)
      call lf_msg#warn("Directory " . l:tagdir . " does not exist.")
      return
    endif
    call lf_msg#notice('Tagging ' . l:tagdir)
    let l:oldcwd = getcwd()
    execute 'lcd' l:tagdir
    try
      let s:res = lf_job#start(['ctags',
            \ '-R',
            \ '--sort=foldcase',
            \ '--extra=+fq',
            \ '--fields=+iaS',
            \ '--c++-kinds=+p',
            \ '--exclude=cache',
            \ '--exclude=third_party',
            \ '--exclude=tmp',
            \ '--exclude=*.html'] + split(a:args))
    finally
      execute 'lcd' l:oldcwd
    endtry
  endfor
endf

