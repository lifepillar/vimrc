" Do not use YouCompleteMe for Ledger files
if exists('g:ycm_filetype_blacklist')
  call extend(g:ycm_filetype_blacklist, { 'ledger': 1 })
endif

hi! link ledgerTransactionDate Typedef
hi! link ledgerMetadata Statement
hi! link LedgerNegativeNumber Typedef
hi! link LedgerImproperPerc PreProc

" Toggle transaction state
nnoremap <silent><buffer> <space> :call ledger#transaction_state_toggle(line('.'), '* !')<cr>
" Set today's date as auxiliary date
nnoremap <silent><buffer> <leader>d :call ledger#transaction_date_set('.', "auxiliary")<cr>
" Autocomplete payees/accounts or align amounts at the decimal point
inoremap <silent><buffer> <tab> <c-r>=ledger#autocomplete_and_align()<cr>
vnoremap <silent><buffer> <tab> :LedgerAlign<cr>
" Enter a new transaction based on the text in the current line
nnoremap <silent><buffer> <c-t> :call ledger#entry()<cr>
inoremap <silent><buffer> <c-t> <Esc>:call ledger#entry()<cr>

" Monthly average
nnoremap <buffer> <leader>la :<c-u>Ledger reg --collapse -A -O --real --aux-date --monthly -p 'this year' expenses
" Annualized budget
nnoremap <silent><buffer> <leader>lA :<c-u>execute "Ledger budget -p 'this year' --real --aux-date --now "
      \ . strftime('%Y', localtime()) . "/12/31 expenses payable income
      \ -F '%(justify((get_at(display_total, 1) ? -scrub(get_at(display_total, 1)) : 0.0), 16, -1, true, color))
      \ %(!options.flat ? depth_spacer : \"\") %-(ansify_if(partial_account(options.flat), blue if color))\\n%/%$1 %$2 %$3\\n
      \%/%(prepend_width ? \" \" * int(prepend_width) : \"\")  --------------------------\\n'"<cr>
" Balance report
nnoremap <buffer> <leader>lb :<c-u>Ledger bal --real --aux-date assets liab
" Budget
nnoremap <buffer> <leader>lB :<c-u>Ledger budget --real -p 'this year' expenses payable
" Cleared report
nnoremap <buffer> <leader>lc :<c-u>Ledger cleared --real --aux-date assets liab
" Debit/credit report
nnoremap <buffer> <leader>ld :<c-u>Ledger reg --dc -S date --real -d 'd>=[2 months ago]' 'liabilities:credit card'
" Expense report
nnoremap <buffer> <leader>le :<c-u>Ledger bal --subtotal --aux-date --real -p 'this month' expenses
" Cash flow
nnoremap <buffer> <leader>lf :<c-u>Ledger bal --collapse --dc --related --real --aux-date --cleared -p 'last 30 days'
" Income statement
nnoremap <buffer> <leader>li :<c-u>Ledger bal --real --aux-date -p 'this month' income expenses
" Monthly expenses
nnoremap <buffer> <leader>lm :<c-u>Ledger reg --period-sort '(-amount)' --monthly --aux-date --real -p 'this month' expenses
" Net worth
nnoremap <buffer> <leader>ln :<c-u>Ledger reg -F '\%10(date)\%20(display_total)\n' --collapse --real --aux-date -d 'd>=[this year]' --monthly assets liab
" Pending/uncleared transactions
nnoremap <buffer> <leader>lp :<c-u>Ledger reg --pending
" Register
nnoremap <buffer> <leader>lr :<c-u>Ledger reg --real --aux-date -p 'this month'
" Savings
nnoremap <buffer> <leader>ls :<c-u>Ledger bal --collapse --real --aux-date -p 'last month' income expenses
" Uncleared transactions
nnoremap <buffer> <leader>lu :<c-u>Ledger reg --uncleared

