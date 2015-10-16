" Do not use YouCompleteMe for Ledger files
if exists('g:ycm_filetype_blacklist')
  call extend(g:ycm_filetype_blacklist, { 'ledger': 1 })
endif

let s:winpos_map = {
      \ "T": "to new",  "t": "abo new", "B": "bo new",  "b": "bel new",
      \ "L": "to vnew", "l": "abo vnew", "R": "bo vnew", "r": "bel vnew"
      \ }


" Settings for Ledger reports
let g:ledger_winpos = 'B'  " Window position (see s:winpos_map)
let g:ledger_use_location_list = 0  " Use quickfix list by default
" Settings for the quickfix window
let g:ledger_qf_register_format = '%(date) %-50(payee) %-30(account) %15(amount) %15(total)\n'
let g:ledger_qf_reconcile_format = '%(date) %-4(code) %-50(payee) %-30(account) %15(amount)\n'
let g:ledger_qf_size = 10
let g:ledger_qf_vertical = 0
let g:ledger_qf_hide_file = 1
" Highlight groups for reports
hi! link LedgerNumber Number
hi! link LedgerNegativeNumber Special
hi! link LedgerImproperPerc Special

fun! s:errorMessage(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endf

fun! s:warningMessage(msg)
  echohl WarningMsg
  echomsg a:msg
  echohl NONE
endf

" Open the quickfix/location window when not empty.
"
" Optional parameters:
" a:1  Quickfix window title.
" a:2  Message to show when the window is empty.
fun! s:quickfixToggle(...)
  if g:ledger_use_location_list
    let l:list = 'l'
    let l:open = (len(getloclist(winnr())) > 0)
  else
    let l:list = 'c'
    let l:open = (len(getqflist()) > 0)
  endif
  if l:open
    execute (g:ledger_qf_vertical ? 'vert' : '') l:list.'open' g:ledger_qf_size
    " Note that the following settings do not persist (e.g., when you close and re-open the quickfix window).
    " See: http://superuser.com/questions/356912/how-do-i-change-the-quickix-title-status-bar-in-vim
    if g:ledger_qf_hide_file
      set conceallevel=2
      set concealcursor=nc
      syntax match qfFile /^[^|]*/ transparent conceal
    endif
    if a:0 > 0
      let w:quickfix_title = a:1
    endif
  else
    execute l:list.'close'
    call s:warningMessage((a:0 > 1) ? a:2 : 'No results')
  endif
endf

" Populate a quickfix/location window with data. The argument must be a String
" or a List.
fun! s:quickfixPopulate(data)
  " Note that cexpr/lexpr always uses the global value of errorformat
  let l:efm = &errorformat  " Save global errorformat
  set errorformat=%EWhile\ parsing\ file\ \"%f\"\\,\ line\ %l:,%ZError:\ %m,%-C%.%#
  set errorformat+=%tarning:\ \"%f\"\\,\ line\ %l:\ %m
  set errorformat+=Error:\ %m
  set errorformat+=%f:%l\ %m
  set errorformat+=%-G%.%#
  execute (g:ledger_use_location_list ? 'l' : 'c').'expr' 'a:data'
  let &errorformat = l:efm  " Restore global errorformat
  return
endf

" Parse a list of ledger arguments and build a ledger command ready to be
" executed.
"
" Note that %, # and < *at the start* of an item are expanded by Vim. If you
" want to pass such characters to Ledger, escape them with a backslash.
"
" See also http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
" See also https://groups.google.com/forum/#!topic/vim_use/4ZejMpt7TeU
fun! s:ledgerCmd(arglist)
  let l:cmd = g:ledger_bin
  for l:part in a:arglist
    if l:part =~ '\v^[%#<]'
      let l:expanded_part = expand(l:part)
      let l:cmd .= ' ' . (l:expanded_part == "" ? l:part : shellescape(l:expanded_part))
    else
      let l:cmd .= ' ' . l:part
    endif
  endfor
  return l:cmd
endf

" Run an arbitrary ledger command to process the current buffer, and show the
" output in a new buffer. If there are errors, no new buffer is opened: the
" errors are displayed in a quickfix window instead.
"
" Parameters:
" args  A string of Ledger arguments.
fun! s:ledgerReport(args)
  if getbufvar(winbufnr(winnr()), "&ft") !=# "ledger"
    call s:errorMessage("Please switch to a Ledger buffer first.")
    return
  endif
  " Run Ledger
  let l:cmd = s:ledgerCmd(['-f', '%'] + split(a:args, ' '))
  let l:output = systemlist(l:cmd)
  if v:shell_error  " If there are errors, show them in a quickfix/location list.
    call s:quickfixPopulate(l:output)
    call s:quickfixToggle('Errors executing ' . l:cmd)
    return
  endif
  if empty(l:output)
    call s:warningMessage('No results')
    return
  endif
  " Open a new buffer to show Ledger's output.
  execute get(s:winpos_map, g:ledger_winpos, "bo new")
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call append(0, l:output)
  setlocal nomodifiable
  " Set local mappings to quit window or lose focus.
  nnoremap <silent> <buffer> <tab> <c-w><c-w>
  nnoremap <silent> <buffer> q <c-w>c
  " Add some coloring to the report
  syntax match LedgerNumber /[^-]\d\+\([,.]\d\+\)\+/
  syntax match LedgerNegativeNumber /-\d\+\([,.]\d\+\)\+/
  syntax match LedgerImproperPerc /\d\d\d\+%/
endf

command! -complete=shellcmd -nargs=+ Ledger call <sid>ledgerReport(<q-args>)

" Show a register report in a quickfix list.
fun! s:ledgerRegister(args)
  call s:quickfixPopulate(systemlist(s:ledgerCmd(extend([
        \ "register",
        \ "-f", "%",
        \ "--format='" . g:ledger_qf_register_format . "'",
        \ "--prepend-format='%(filename):%(beg_line) '"
        \ ], split(a:args, ' ')))))
  call s:quickfixToggle('Register report')
endf

command! -complete=shellcmd -nargs=* Register call <sid>ledgerRegister(<q-args>)

fun! s:ledgerReconcile(account, ...)
  call s:quickfixPopulate(systemlist(s:ledgerCmd([
        \ "register",
        \ a:account,
        \ "--uncleared",
        \ "--format='" . g:ledger_qf_reconcile_format . "'",
        \ "--prepend-format='%(filename):%(beg_line) %(pending ? \"P\" : \"U\") '"
        \ ])))
  call s:quickfixToggle('Reconcile ' . a:account, 'Nothing to reconcile')
endf

command! -nargs=1 Reconcile call <sid>ledgerReconcile(<q-args>)

fun! s:clearedOrPendingBalance(account)
  echomsg a:account ': ' system(s:ledgerCmd([
        \ 'balance',
        \ a:account,
        \ "--limit",
        \ "'cleared or pending'",
        \ "--empty",
        \ "--collapse",
        \ "--format='%(scrub(display_total))'"
        \ ]))
endf

command! -nargs=1 Balance call <sid>clearedOrPendingBalance(<q-args>)

fun! s:ledgerAutocomplete()
  if pumvisible()
    return "\<c-n>"
    " See http://stackoverflow.com/questions/23323747/vim-vimscript-get-exact-character-under-the-cursor
  elseif matchstr(getline('.'), '\%' . (col('.')-1) . 'c.') =~ '\d'
    norm h
    call ledger#align_amount_at_cursor()
    return "\<c-o>A"
  endif
  return "\<c-x>\<c-o>"
endf

" Toggle transaction state
nnoremap <silent><buffer> <space> :call ledger#transaction_state_toggle(line('.'), '* !')<cr>
" Autocomplete payees/accounts or align amounts at the decimal point
inoremap <silent><buffer> <tab> <c-r>=<sid>ledgerAutocomplete()<cr>
vnoremap <silent><buffer> <tab> :LedgerAlign<cr>
" Enter a new transaction based on the text in the current line
nnoremap <silent><buffer> <c-t> :call ledger#entry()<cr>
inoremap <silent><buffer> <c-t> <Esc>:call ledger#entry()<cr>

" Balance reports
nnoremap <buffer> <leader>lb :<c-u>Ledger bal --real assets liab
nnoremap <buffer> <leader>lc :<c-u>Ledger cleared --real assets liab
" Cash flow
nnoremap <buffer> <leader>lf :<c-u>Ledger bal --collapse --dc --related --real --effective -p 'this month' cash
" Journal
nnoremap <buffer> <leader>lr :<c-u>Ledger reg --real --effective -p 'this month'
" Budget
nnoremap <buffer> <leader>lB :<c-u>Ledger budget --real --effective -p 'this year' expenses payable
" Debit/credit report
nnoremap <buffer> <leader>ld :<c-u>Ledger reg --dc -S date --real -d 'd>=[2 months ago]' 'liabilities:credit card'
" Expense report
nnoremap <buffer> <leader>le :<c-u>Ledger bal --subtotal --effective --real -p 'this month' expenses
" Income statement
nnoremap <buffer> <leader>li :<c-u>Ledger bal --real --effective -p 'this month' income expenses
" Monthly average
nnoremap <buffer> <leader>la :<c-u>Ledger reg --collapse -A -O --real --effective --monthly -p 'this year' expenses
" Monthly expenses
nnoremap <buffer> <leader>lm :<c-u>Ledger reg --period-sort '(-amount)' --monthly --effective --real -p 'this month' expenses
" Net worth
nnoremap <buffer> <leader>ln :<c-u>Ledger reg -F '\%10(date)\%20(display_total)\n' --collapse --real --effective -d 'd>=[this year]' --monthly assets liab
" Pending/uncleared transactions
nnoremap <buffer> <leader>lp :<c-u>Ledger reg --pending
nnoremap <buffer> <leader>lu :<c-u>Ledger reg --uncleared
" Savings
nnoremap <buffer> <leader>ls :<c-u>Ledger bal --collapse --real --effective -p 'last month' income expenses

