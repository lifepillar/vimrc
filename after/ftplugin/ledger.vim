" Search include files when auto-completing with <c-n>
setlocal complete+=i

let g:ledger_table_sep = "\t"

let g:ledger_tables = {
      \ 'register':  {
        \ 'names': ['date', 'week_day', 'amount', 'total', 'payee', 'account'],
        \ 'fields': [
        \   '%(format_date(date,"' . join(['%Y-%m-%d', '%a'], g:ledger_table_sep) . '"))',
        \   '%(quantity(scrub(display_amount)))',
        \   '%(quantity(scrub(display_total)))',
        \   '%(payee)',
        \   '%(display_account)\n'
        \   ]
        \ },
      \ 'cleared': {
        \ 'names': ['latest', 'latest_cleared', 'balance', 'uncleared',  'partial_account', 'account'],
        \ 'fields': [
        \   '%(latest ? format_date(latest) : "         ")',
        \   '%(latest_cleared ? format_date(latest_cleared) : "         ")',
        \   '%(quantity(scrub(get_at(display_total, 0))))',
        \   '%(quantity(scrub(get_at(display_total, 1))))',
        \   '%(partial_account)',
        \   '%(account)\n%/'
        \   ]
        \ },
      \ 'budget': {
        \ 'names': ['actual', 'budgeted', 'remaining', 'used',  'partial_account', 'account'],
        \ 'fields': [
        \   '%(quantity(scrub(get_at(display_total, 0))))',
        \   '%(get_at(display_total, 1) ? quantity(-scrub(get_at(display_total, 1))) : 0.0)',
        \   '%(get_at(display_total, 1) ? (get_at(display_total, 0) ? quantity(-scrub(get_at(display_total, 1) + get_at(display_total, 0))) : quantity(-scrub(get_at(display_total, 1)))) : quantity(-scrub(get_at(display_total, 0))))',
        \   '%(get_at(display_total, 1) ? quantity(100% * (get_at(display_total, 0) ? scrub(get_at(display_total, 0)) : 0.0) / -scrub(get_at(display_total, 1))) : "na")',
        \   '%(partial_account)',
        \   '%(account)\n%/'
        \   ]
        \ }
      \ }

fun! s:ledgerTable(type, args)
  let l:format = join(g:ledger_tables[a:type].fields, g:ledger_table_sep)
  if ledger#output(ledger#report(g:ledger_main, join([a:type, a:args, "-F '".l:format."'"])))
    set modifiable
    call setline(1, join(g:ledger_tables[a:type].names, "\t")) " Add header
    setlocal filetype=csv
    set nomodifiable
  endif
endf

command! -buffer -nargs=+ LedgerTable  call <sid>ledgerTable('register', <q-args>)
command! -buffer -nargs=+ BalanceTable call <sid>ledgerTable('cleared', <q-args>)
command! -buffer -nargs=+ BudgetTable  call <sid>ledgerTable('budget', <q-args>)

" Waiting for https://github.com/ledger/vim-ledger/pull/27 to be merged.
fun! s:AutocompleteOrAlign()
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
nnoremap <silent><buffer> <enter> :call ledger#transaction_state_toggle(line('.'), '* !')<cr>
" Set today's date as auxiliary date
nnoremap <silent><buffer> <leader>d :call ledger#transaction_date_set('.', "auxiliary")<cr>
" Autocompletion and alignment
inoremap <silent><buffer> <tab> <c-r>=<sid>AutocompleteOrAlign()<cr>
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
nnoremap <buffer> <leader>lC :<c-u>Ledger cleared --real --aux-date --current assets liab
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
nnoremap <buffer> <leader>ln :<c-u>Ledger reg -F '%10(date)%20(display_total)\n' --collapse --real --aux-date -d 'd>=[this year]' --monthly assets liab
" Pending/uncleared transactions
nnoremap <buffer> <leader>lp :<c-u>Register --pending
" Register
nnoremap <buffer> <leader>lr :<c-u>Ledger reg --real --aux-date -p 'this month'
" Savings
nnoremap <buffer> <leader>ls :<c-u>Ledger bal --collapse --real --aux-date -p 'last month' income expenses
" Uncleared transactions
nnoremap <buffer> <leader>lu :<c-u>Register--uncleared

