" Do not use YouCompleteMe for SQL files
if exists('g:ycm_filetype_blacklist')
  call extend(g:ycm_filetype_blacklist, { 'sql': 1 })
endif

let b:lf_tab_complete = "\<c-c>a"

