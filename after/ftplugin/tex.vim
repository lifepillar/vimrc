compiler tex

" See :h <SID>
fun! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endf

fun! s:TeXPDFPath()
  return expand('%:p:r').'.pdf'
endf

fun! s:TeXLogPath()
  return expand('%:p:r').'.log'
endf

fun! s:TeXCallback(exit_status)
  " The following is adapted from LaTeX-Box
  " set cwd to expand error file correctly
  let l:cwd = fnamemodify(getcwd(), ':p')
  execute 'lcd ' . fnameescape(expand('%:p:h'))
  try
    execute 'cgetfile ' . fnameescape(s:TeXLogPath())
  finally
    " restore cwd
    execute 'lcd ' . fnameescape(l:cwd)
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

fun! s:TeXTypesetCommand(program)
  let l:env = "max_print_line=2000"
  let l:cmd = "latexmk"
  if a:program == "lualatex"
    let l:opts = "-lualatex"
  else
    let l:opts = " -pdf -pdflatex='pdflatex'"
  endif
  let l:opts .= " -cd -pv- -synctex=1 -file-line-error -interaction=nonstopmode"
  return join([l:env, l:cmd, l:opts, shellescape(expand('%:p'))])
endf

fun! s:TeXTypeset(program)
  if has('clientserver') " Typeset in the background
    echohl Statement
    echomsg "Typesetting..."
    echohl None
    let l:callbackfun = s:SID() . '_TeXCallback'
    silent execute '! (' . s:TeXTypesetCommand(a:program) . ' >/dev/null 2>&1;'
          \ . 'mvim --remote-send "<C-\><C-N>:call <SNR>' . l:callbackfun . '($?)<cr>") &'
  else " Synchronous typesetting
    execute '! ' . s:TeXTypesetCommand(a:program)
    silent call s:TeXCallback(v:shell_error)
  endif
endf

fun! s:TeXClean()
  silent execute '!latexmk -cd -c -quiet ' . shellescape(expand('%:p')) . '>/dev/null 2>&1 &'
  if !has('gui_running')
    redraw!
  endif
  echohl ModeMsg
  echomsg 'Aux files removed'
  echohl None
endf

fun! s:TeXPreview()
  silent execute '!open -a Skim.app ' . shellescape(s:TeXPDFPath()) . ' >&/dev/null 2>&1 &'
  if !has("gui_running")
    redraw!
  endif
endf

fun! s:TeXForwardSearch()
  silent execute join([
        \ '!${HOME}/Applications/Skim.app/Contents/SharedSupport/displayline',
        \ line('.'),
        \ shellescape(s:TeXPDFPath()),
        \ shellescape(expand('%:p'))
        \ ])
  if !has("gui_running")
    redraw!
  endif
endf

" Typeset:
nnoremap <silent><buffer> <leader>tl :<c-u>call <sid>TeXTypeset('lualatex')<cr>
nnoremap <silent><buffer> <leader>tp :<c-u>call <sid>TeXTypeset('pdflatex')<cr>
" Clean generated files:
nnoremap <silent><buffer> <leader>tc :<c-u>call <sid>TeXClean()<cr>
" Open PDF previewer (Skim):
nnoremap <silent><buffer> <leader>tv :<c-u>call <sid>TeXPreview()<cr>
" Forward search using Skim:
nnoremap <silent><buffer> <leader>ts :<c-u>call <sid>TeXForwardSearch()<cr>

