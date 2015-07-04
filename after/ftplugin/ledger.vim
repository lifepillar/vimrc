" Run an arbitrary ledger command.
func! Ledger(args)
  call RunShellCommand(g:ledger_bin . " -f % " . a:args, "r")
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

func! BalanceReport()
  call inputsave()
  let accounts = input("Accounts: ", "^asset ^liab")
  call inputrestore()
  call Ledger('cleared --real --strict --explicit --check-payees ' . accounts)
endfunc

