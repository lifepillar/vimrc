" Do not use YouCompleteMe for SQL files
if exists('g:ycm_filetype_blacklist')
  call extend(g:ycm_filetype_blacklist, { 'sql': 1 })
endif

" See also: http://vim.wikia.com/wiki/Autocomplete_with_TAB_when_typing_words
fun! s:TabComplete()
  if pumvisible()
    return "\<c-n>"
  elseif col('.') > 1 && strpart(getline('.'), col('.') - 2, 3) =~ '^\w'
    " See :h sql-completion-static
    call sqlcomplete#Map('syntax')
    return "\<c-x>\<c-o>"
  else
    return "\<tab>"
  endif
endf

fun! s:ShiftTabComplete()
  return pumvisible() ? "\<c-p>" : "\<s-tab>"
endf

" Enable autocompletion with tab
imap <silent><buffer> <tab> <c-r>=<sid>TabComplete()<cr>
imap <silent><buffer> <s-tab> <c-r>=<sid>ShiftTabComplete()<cr>

