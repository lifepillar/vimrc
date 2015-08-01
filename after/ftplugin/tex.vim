compiler tex

fun! TeXPDFPath()
  return expand('%:p:r').'.pdf'
endf

fun! TeXLogPath()
  return expand('%:p:r').'.log'
endf

fun! TeXCallback(exit_status)
  " The following is adapted from LaTeX-Box
  " (commented out because we set autochdir in vimrc).
  " set cwd to expand error file correctly
  " let l:cwd = fnamemodify(getcwd(), ':p')
  " exec 'lcd ' . fnameescape(expand('%:p:h'))
  try
    exec 'cgetfile ' . fnameescape(TeXLogPath())
    " finally
    "   " restore cwd
    "   execute 'lcd ' . fnameescape(l:cwd)
  endtry
  if a:exit_status == 0
    echohl ModeMsg
    echomsg 'Success!'
    echohl None
    cclose
  else
    copen
  endif
endf

fun! TeXTypesetCommand(program)
  let env = "max_print_line=2000"
  let cmd = "latexmk"
  if a:program == "lualatex"
    let opts = "-lualatex"
  else
    let opts = " -pdf -pdflatex='pdflatex'"
  endif
  let opts .= " -cd -pv- -synctex=1 -file-line-error -interaction=nonstopmode"
  return join([env, cmd, opts, shellescape(expand('%:p'))])
endf

fun! TeXTypeset(program)
  if has('clientserver') " Typeset in the background
    echohl Statement
    echomsg "Typesetting..."
    echohl None
    silent exec '! (' . TeXTypesetCommand(a:program) . ' >/dev/null 2>&1;'
          \ . 'mvim --remote-send "<C-\><C-N>:call TeXCallback($?)<CR>") &'
  else " Synchronous typesetting
    exec '! ' . TeXTypesetCommand(a:program)
    silent call TeXCallback(v:shell_error)
  endif
endf

fun! TeXClean()
  silent exec '!latexmk -cd -c -quiet ' . shellescape(expand('%:p')) . '>/dev/null 2>&1 &'
  if !has('gui_running')
    redraw!
  endif
  echohl ModeMsg
  echomsg 'Aux files removed'
  echohl None
endf

fun! TeXPreview()
  silent exec '!open -a Skim.app ' . shellescape(TeXPDFPath()) . ' >&/dev/null 2>&1 &'
  if !has("gui_running")
    redraw!
  endif
endf

fun! TeXForwardSearch()
  silent exec join([
        \ '!${HOME}/Applications/Skim.app/Contents/SharedSupport/displayline',
        \ line('.'),
        \ shellescape(TeXPDFPath()),
        \ shellescape(expand('%:p'))
        \ ])
  if !has("gui_running")
    redraw!
  endif
endf

" Typeset:
nnoremap <silent><buffer> <Leader>tl :<C-U>call TeXTypeset('lualatex')<CR>
nnoremap <silent><buffer> <Leader>tp :<C-U>call TeXTypeset('pdflatex')<CR>
" Clean generated files:
nnoremap <silent><buffer> <Leader>tc :<C-U>call TeXClean()<CR>
" Open PDF previewer (Skim):
nnoremap <silent><buffer> <Leader>tv :<C-U>call TeXPreview()<CR>
" Forward search using Skim:
nnoremap <silent><buffer> <Leader>ts :<C-U>call TeXForwardSearch()<CR>

