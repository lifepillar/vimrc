" Run an arbitrary ledger command.
func! Ledger(args)
  call RunShellCommand(g:ledger_bin . " -f % " . a:args, "r")
endfunc

command! -complete=shellcmd -nargs=+ Ledger call Ledger(<q-args>)

" Toggle transaction state
nnoremap <silent><buffer> <Space> :call ledger#transaction_state_toggle(line('.'), '* !')<CR>
" Autocomplete
inoremap <silent><buffer> <Tab> <C-x><C-o>
" Enter a new transaction based on the text in the current line
nnoremap <silent><buffer> <C-t> :call ledger#entry()<CR>
inoremap <silent><buffer> <C-t> <Esc>:call ledger#entry()<CR>
" Align amounts at the decimal point
vnoremap <silent><buffer> <Leader>a :LedgerAlign<CR>
inoremap <silent><buffer> <C-l> <Esc>:call ledger#align_amount_at_cursor()<CR>

func! BalanceReport()
  call inputsave()
  let accounts = input("Accounts: ", "^asset ^liab")
  call inputrestore()
  call Ledger('cleared --real --strict --explicit --check-payees ' . accounts)
endfunc

