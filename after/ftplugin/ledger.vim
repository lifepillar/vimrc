" Run an arbitrary ledger command.
func! Ledger(args)
  call RunShellCommand(g:ledger_bin . " -f % --check-payees --explicit --strict --wide " . a:args, "T")
  " Color negative numbers
  syntax match Macro /-\d\+\([,.]\d\+\)*/
endfunc

command! -complete=shellcmd -nargs=+ Ledger call Ledger(<q-args>)

func! LedgerAutocomplete()
  " See http://stackoverflow.com/questions/23323747/vim-vimscript-get-exact-character-under-the-cursor
  if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\d'
    call ledger#align_amount_at_cursor()
  else
    call feedkeys("\<c-x>\<c-o>")
  endif
endfunc

" Toggle transaction state
nnoremap <silent><buffer> <Space> :call ledger#transaction_state_toggle(line('.'), '* !')<CR>
" Autocomplete payees/accounts or align amounts at the decimal point
inoremap <silent><buffer> <Tab> <C-o>:call LedgerAutocomplete()<CR>
vnoremap <silent><buffer> <Tab> :LedgerAlign<CR>
" Enter a new transaction based on the text in the current line
nnoremap <silent><buffer> <C-t> :call ledger#entry()<CR>
inoremap <silent><buffer> <C-t> <Esc>:call ledger#entry()<CR>

" Balance reports
nnoremap <buffer> <Leader>lb :<C-u>Ledger bal --real assets liab
nnoremap <buffer> <Leader>lc :<C-u>Ledger cleared --real assets liab
" Cash flow
nnoremap <buffer> <Leader>lf :<C-u>Ledger bal --collapse --dc --related --real --effective -p 'this month' cash
" Journal
nnoremap <buffer> <Leader>lr :<C-u>Ledger reg --real --effective -p 'this month'
" Budget
nnoremap <buffer> <Leader>lB :<C-u>Ledger budget --real -p 'this year' expenses payable
" Debit/credit report
nnoremap <buffer> <Leader>ld :<C-u>Ledger reg --dc -S date --real -d 'd>=[2 months ago]' 'liabilities:credit card'
" Expense report
nnoremap <buffer> <Leader>le :<C-u>Ledger bal --subtotal --real -p 'this month' expenses
" Income statement
nnoremap <buffer> <Leader>li :<C-u>Ledger bal --real -p 'this month' income expenses
" Monthly average
nnoremap <buffer> <Leader>la :<C-u>Ledger reg --collapse -A -O --real --monthly -p 'this year' expenses
" Monthly expenses
nnoremap <buffer> <Leader>lm :<C-u>Ledger reg --period-sort '(-amount)' --monthly --effective --real -p 'this month' expenses
" Net worth
nnoremap <buffer> <Leader>ln :<C-u>Ledger reg -F '\%10(date)\%20(display_total)\n' --collapse --real -d 'd>=[this year]' --monthly assets liab
" Pending/uncleared transactions
nnoremap <buffer> <Leader>lp :<C-u>Ledger reg --pending<CR>
nnoremap <buffer> <Leader>lu :<C-u>Ledger reg --uncleared<CR>
" Savings
nnoremap <buffer> <Leader>ls :<C-u>Ledger bal --collapse --real -p 'last month' income expenses

