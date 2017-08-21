if has("nvim")

  fun! lf_legacy#git#blame()
    execute 'split +terminal\ cd\ '.shellescape(expand('%:p:h')).'&&tig\ blame\ '
          \ .shellescape(expand('%:t')).'\ +'.expand(line('.'))
  endf

  fun! lf_legacy#git#status()
    execute 'split +terminal\ cd\ '.shellescape(expand('%:p:h')).'&&tig\ status'
  endf

else " Older Vim

  fun! lf_legacy#git#blame()
    silent execute '!cd '.shellescape(expand('%:p:h')).'&& tig blame '
          \ .shellescape(expand('%:t')).' +'.expand(line('.'))
    redraw!
  endf

  fun! lf_legacy#git#status()
    silent execute '!cd '.shellescape(expand('%:p:h')).'&& tig status'
    redraw!
  endf

endif

fun! lf_legacy#git#push()
  call lf_git#output(['push'], 'botright')
endf
