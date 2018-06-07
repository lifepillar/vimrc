" Jump from the current file to related files based on file suffixes (e.g.,
" from Foo.cpp to Foo.hpp and vice versa).
"
" Note: Requires a `tags` file created by `ctags` with the option `--extra=+f`.
"
" The dictionary below maps the suffix of the current file to a list of
" candidate suffixes for alternate files.
fun! lf_tags#alt_file()
  execute "tjump" '/^'.expand("%:t:r").'\.\('.join(get(
        \ {
        \ 'c':   ['h'],
        \ 'cpp': ['h','hpp'],
        \ 'h':   ['c','cpp'],
        \ 'hpp': ['cpp'],
        \ 'vim': ['vim']
        \ },
        \  expand("%:e"), ['UNKNOWN EXTENSION']), '\\|') . '\)$'
endf

fun! lf_tags#ctags(args)
  if empty(tagfiles()) " New tags file
    let l:dir = lf_find#choose_dir('Create tags in:')
    if empty(l:dir) | return | endif
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

fun! lf_tags#load_cscope_db()
  let l:db = findfile("cscope.out", ".;") " See :h findfile()
  if !empty(l:db)
    execute "cscope add" fnameescape(l:db)
  endif
  return !empty(l:db)
endf

