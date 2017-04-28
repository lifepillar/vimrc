let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

set completeopt+=menuone,noinsert,noselect
set lazyredraw
set spell

imap <expr> <plug>(SendKey) MyComplete()
imap <expr> <plug>(Verify) <sid>verify_completion()

fun! ActOnInsertCharPre()
  return feedkeys("\<plug>(SendKey)", 'i')
endf

autocmd TextChangedI * noautocmd call ActOnInsertCharPre()

fun! s:act_on_pumvisible()
  return ''
endf

fun! s:verify_completion()
  return pumvisible()
            \ ? s:act_on_pumvisible()
            \ : ''
endf

fun! MyComplete()
  return "\<c-g>\<c-g>\<c-x>\<c-n>\<c-r>\<c-r>=''\<cr>\<plug>(Verify)"
endf
