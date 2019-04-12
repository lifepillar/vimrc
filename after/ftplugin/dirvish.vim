nmap <buffer> - <plug>(dirvish_up)
silent! unmap <buffer> <c-n>
silent! unmap <buffer> <c-p>

" Open in a new tab
nnoremap <nowait> <silent> <buffer> t :call dirvish#open('tabedit', 0)<cr>
xnoremap <nowait> <silent> <buffer> t :call dirvish#open('tabedit', 0)<cr>

fun! BuildDirvishStatusLine(nr)
  return '%{SetupStl('.a:nr.')}
        \%#CurrMode#%{w:["lf_active"] ? "  BROWSE " : ""}%*
        \%{w:["lf_active"] ? "" : "  BROWSE "} %{winnr()} %f %= %l:%v %P '
endf

if exists("g:default_stl")
  setlocal statusline=%!BuildDirvishStatusLine(winnr())
endif
