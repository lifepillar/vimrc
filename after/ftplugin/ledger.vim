" Do not use YouCompleteMe for Ledger files
if exists('g:ycm_filetype_blacklist')
  call extend(g:ycm_filetype_blacklist, { 'ledger': 1 })
endif

" Toggle transaction state
nnoremap <silent><buffer> <space> :call ledger#transaction_state_toggle(line('.'), '* !')<cr>
" Autocomplete payees/accounts or align amounts at the decimal point
inoremap <silent><buffer> <tab> <c-r>=ledger#autocomplete_and_align()<cr>
vnoremap <silent><buffer> <tab> :LedgerAlign<cr>
" Enter a new transaction based on the text in the current line
nnoremap <silent><buffer> <c-t> :call ledger#entry()<cr>
inoremap <silent><buffer> <c-t> <Esc>:call ledger#entry()<cr>

" Balance reports
nnoremap <buffer> <leader>lb :<c-u>Ledger bal --real --effective assets liab
nnoremap <buffer> <leader>lc :<c-u>Ledger cleared --real --effective assets liab
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

