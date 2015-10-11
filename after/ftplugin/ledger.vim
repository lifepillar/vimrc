" Do not use YouCompleteMe for Ledger files
if exists('g:ycm_filetype_blacklist')
  call extend(g:ycm_filetype_blacklist, { 'ledger': 1 })
endif

" Run an arbitrary ledger command.
fun! s:ledger(args)
  if getbufvar(winbufnr(winnr()), "&ft") !=# "ledger"
    echohl Error
    echomsg "Please switch to a Ledger buffer first."
    echohl None
    return
  endif
  execute 'ShellTop ' . g:ledger_bin . " -f % --check-payees --explicit --strict --wide " . a:args
  " Color negative numbers
  syntax match Macro /-\d\+\([,.]\d\+\)\+/
  " Color improper percentages
  syntax match Macro /\d\d\d\+%/
endf

command! -complete=shellcmd -nargs=+ Ledger call <sid>ledger(<q-args>)

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

set errorformat+=%f:%l\ %m

let g:ledger_reconcile_list_size = 10
let g:ledger_vertical_reconcile_list = 0
let g:ledger_reconcile_list_show_file = 0
let g:ledger_reconcile_list_options = ['--effective', '--wide']

fun! s:ledgerReconcile(account)
  lexpr system(g:ledger_bin . " -f " . shellescape(expand('%')) . " register " . a:account . " " . join(g:ledger_reconcile_list_options) . " --uncleared --prepend-format '\%(filename):\%(beg_line) \%(pending ? \"P\" : \"U\") '")
  if len(getloclist(winnr())) > 0
    execute (g:ledger_vertical_reconcile_list ? 'vert' : '') 'lopen' g:ledger_reconcile_list_size
    " Note that the following settings do not persist (e.g., when you close and re-open the quickfix window).
    " See: http://superuser.com/questions/356912/how-do-i-change-the-quickix-title-status-bar-in-vim
    let w:quickfix_title = 'Reconcile ' . a:account
    if !g:ledger_reconcile_list_show_file " Hide file name in quickfix window
      set conceallevel=2
      set concealcursor=nc
      syntax match qfFile /^[^|]*/ transparent conceal
    endif
  else
    lclose
    echomsg "Nothing to reconcile."
  endif
endf

command! -nargs=1 Reconcile call <sid>ledgerReconcile(<q-args>)

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

