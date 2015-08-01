" Do not use YouCompleteMe for Ledger files
call extend(g:ycm_filetype_blacklist, { 'ledger': 1 })

" Run an arbitrary ledger command.
func! Ledger(args)
  call RunShellCommand(g:ledger_bin . " -f % --check-payees --explicit --strict --wide " . a:args, "T")
  " Color negative numbers
  syntax match Macro /-\d\+\([,.]\d\+\)\+/
endfunc

command! -complete=shellcmd -nargs=+ Ledger call Ledger(<q-args>)

func! LedgerAutocomplete()
  if pumvisible()
    return "\<c-n>"
  " See http://stackoverflow.com/questions/23323747/vim-vimscript-get-exact-character-under-the-cursor
  elseif matchstr(getline('.'), '\%' . (col('.')-1) . 'c.') =~ '\d'
    norm h
    call ledger#align_amount_at_cursor()
    return "\<c-o>A"
  endif
  return "\<c-x>\<c-o>"
endfunc

" Toggle transaction state
nnoremap <silent><buffer> <Space> :call ledger#transaction_state_toggle(line('.'), '* !')<CR>
" Autocomplete payees/accounts or align amounts at the decimal point
inoremap <silent><buffer> <Tab> <C-r>=LedgerAutocomplete()<CR>
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
nnoremap <buffer> <Leader>le :<C-u>Ledger bal --subtotal --effective --real -p 'this month' expenses
" Income statement
nnoremap <buffer> <Leader>li :<C-u>Ledger bal --real -p 'this month' income expenses
" Monthly average
nnoremap <buffer> <Leader>la :<C-u>Ledger reg --collapse -A -O --real --monthly -p 'this year' expenses
" Monthly expenses
nnoremap <buffer> <Leader>lm :<C-u>Ledger reg --period-sort '(-amount)' --monthly --effective --real -p 'this month' expenses
" Net worth
nnoremap <buffer> <Leader>ln :<C-u>Ledger reg -F '\%10(date)\%20(display_total)\n' --collapse --real -d 'd>=[this year]' --monthly assets liab
" Pending/uncleared transactions
nnoremap <buffer> <Leader>lp :<C-u>Ledger reg --pending
nnoremap <buffer> <Leader>lu :<C-u>Ledger reg --uncleared
" Savings
nnoremap <buffer> <Leader>ls :<C-u>Ledger bal --collapse --real -p 'last month' income expenses

