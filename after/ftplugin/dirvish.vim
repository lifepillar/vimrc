nmap <buffer> - <plug>(dirvish_up)
silent! unmap <buffer> <c-n>
silent! unmap <buffer> <c-p>

" Open in a new tab
nnoremap <nowait> <silent> <buffer> t :call dirvish#open('tabedit', 0)<cr>
xnoremap <nowait> <silent> <buffer> t :call dirvish#open('tabedit', 0)<cr>

if has('patch-8.1.1372') " Has g:statusline_winid
  fun! LFBuildDirvishStatusLine()
    return '%#'.LFStlHighlight().'# BROWSE %* %{winnr()} %f %= %l:%v %P '
  endf
else
  call legacy#statusline#dirvish()
endif

if exists("g:default_stl")
  setlocal statusline=%!LFBuildDirvishStatusLine()
endif

