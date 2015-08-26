" Do not use YouCompleteMe for Ledger files
call extend(g:ycm_filetype_blacklist, { 'ledger': 1 })

" Run an arbitrary ledger command.
fun! s:ledger(args)
  if getbufvar(winbufnr(winnr()), "&ft") !=# "ledger"
    echohl Error
    echomsg "Please switch to a Ledger buffer first."
    echohl None
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
nnoremap <buffer> <leader>lB :<c-u>Ledger budget --real -p 'this year' expenses payable
" Debit/credit report
nnoremap <buffer> <leader>ld :<c-u>Ledger reg --dc -S date --real -d 'd>=[2 months ago]' 'liabilities:credit card'
" Expense report
nnoremap <buffer> <leader>le :<c-u>Ledger bal --subtotal --effective --real -p 'this month' expenses
" Income statement
nnoremap <buffer> <leader>li :<c-u>Ledger bal --real -p 'this month' income expenses
" Monthly average
nnoremap <buffer> <leader>la :<c-u>Ledger reg --collapse -A -O --real --monthly -p 'this year' expenses
" Monthly expenses
nnoremap <buffer> <leader>lm :<c-u>Ledger reg --period-sort '(-amount)' --monthly --effective --real -p 'this month' expenses
" Net worth
nnoremap <buffer> <leader>ln :<c-u>Ledger reg -F '\%10(date)\%20(display_total)\n' --collapse --real -d 'd>=[this year]' --monthly assets liab
" Pending/uncleared transactions
nnoremap <buffer> <leader>lp :<c-u>Ledger reg --pending
nnoremap <buffer> <leader>lu :<c-u>Ledger reg --uncleared
" Savings
nnoremap <buffer> <leader>ls :<c-u>Ledger bal --collapse --real -p 'last month' income expenses

