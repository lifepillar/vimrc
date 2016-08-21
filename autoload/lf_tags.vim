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


