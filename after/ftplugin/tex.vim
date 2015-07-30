compiler tex

fun! TexPdfPath()
  return expand('%:p:r').'.pdf'
endf

fun! TeXPreview()
  silent exec '!open -a Skim.app ' . shellescape(TexPdfPath()) . ' >&/dev/null &'
  if !has("gui_running")
    redraw!
  endif
endf

fun! TexForwardSearch()
  silent exec join([
        \ '!${HOME}/Applications/Skim.app/Contents/SharedSupport/displayline',
        \ line('.'),
        \ shellescape(TexPdfPath()),
        \ shellescape(expand('%:p'))
        \ ])
  if !has("gui_running")
    redraw!
  endif
endf

" Typeset (uses Dispatch plugin to do it in the background):
nnoremap <silent><buffer> <Leader>ll :silent Make!<CR>

" Open PDF previewer (Skim):
nnoremap <silent><buffer> <Leader>lv :<C-U>call TeXPreview()<CR>

" Forward search using Skim:
nnoremap <silent><buffer> <Leader>ls :<C-U>call TexForwardSearch()<CR>

