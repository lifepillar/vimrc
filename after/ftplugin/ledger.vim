" Do not use YouCompleteMe for Ledger files
if exists('g:ycm_filetype_blacklist')
  call extend(g:ycm_filetype_blacklist, { 'ledger': 1 })
endif

let g:ledger_report_sep = ';'

let g:ledger_reports = {
      \ 'register': {
        \ 'fields': [
        \   '%(format_date(date,"' . join(['%Y-%m-%d', '%Y', '%b', '%m', '%a', '%u', '%W', '%d'], g:ledger_report_sep) . '"))',
        \   '%(quantity(scrub(display_amount)))',
        \   '%(quantity(scrub(display_total)))',
        \   '%(payee)',
        \   '%(display_account)\n'
        \ ],
        \ 'names': ["date", "year", "month", "month_num", "wday", "wday_num", "week", "mday", "amount", "total", "payee", "account"],
        \ 'classes': ['Date', 'integer', 'factor', 'factor', 'factor', 'factor', 'integer', 'integer', 'numeric', 'numeric', 'factor', 'factor']
        \ },
      \ 'balance': {
        \ 'fields': [
        \   '%(quantity(scrub(get_at(display_total, 0))))',
        \   '%(quantity(scrub(get_at(display_total, 1))))',
        \   '%(account)',
        \   '%(partial_account)\n%/'
        \ ],
        \ 'names': ["balance", "uncleared_balance", "account", "partial_account"],
        \ 'classes': ['numeric', 'numeric', 'factor', 'factor']
        \ },
      \ 'budget': {
        \ 'fields': [
        \   '%(quantity(-scrub(get_at(display_total, 1) + get_at(display_total, 0))))',
        \   '%(quantity(-scrub(get_at(display_total, 1))))',
        \   '%(quantity(-scrub(get_at(display_total, 1) + get_at(display_total, 0))))',
        \   '%(quantity(get_at(display_total, 1) ? (100% * scrub(get_at(display_total, 0))) / -scrub(get_at(display_total, 1)) : "na"))',
        \   '%(account)',
        \   '%(partial_account)\n%/'
        \ ],
        \ 'names': ["actual", "budgeted", "remaining", "used", "account", "partial_account"],
        \ 'classes': ['numeric', 'numeric', 'numeric', 'numeric', 'factor', 'factor']
        \ }
      \ }

fun! Statistics(file, report_type, args, script)
  " Generate report data in a format suitable for parsing by R
  try
    let l:data = ledger#exec(a:file,
          \ a:report_type
          \ . " --format '" . join(g:ledger_reports[a:report_type].fields, g:ledger_report_sep) . "' "
          \ . a:args)
  catch /.*/
    return
  endtry
  " Prepare R script
  let l:r_script = [
        \ "ledger_data <- read.csv(stdin(), header=F, sep='" . g:ledger_report_sep . "', "
        \ . "colClasses=c(" . join(map(g:ledger_reports[a:report_type].classes, '"''".v:val."''"'), ",") . "))"
        \ ] + l:data + [
        \ '',
        \ 'names(ledger_data) <- c(' . join(map(g:ledger_reports[a:report_type].names, '"''".v:val."''"'), ",") . ')'
        \ ]
  let l:res = system("r --vanilla --slave --no-readline --encoding=UTF-8", l:r_script + a:script)
  bo new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  put =l:res
  setlocal nomodifiable
endf

hi! link ledgerTransactionDate Typedef
hi! link ledgerMetadata Statement
hi! link LedgerNegativeNumber Typedef
hi! link LedgerImproperPerc PreProc

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
nnoremap <buffer> <leader>lp :<c-u>Ledger reg --pending
" Register
nnoremap <buffer> <leader>lr :<c-u>Ledger reg --real --aux-date -p 'this month'
" Savings
nnoremap <buffer> <leader>ls :<c-u>Ledger bal --collapse --real --aux-date -p 'last month' income expenses
" Uncleared transactions
nnoremap <buffer> <leader>lu :<c-u>Ledger reg --uncleared

