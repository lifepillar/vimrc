nmap <buffer> - <plug>(dirvish_up)
silent! unmap <buffer> <c-n>
silent! unmap <buffer> <c-p>

" Refresh buffer
nnoremap <silent> <buffer> <c-l> :<c-u>Dirvish %<cr>

" Open in a new tab
nnoremap <nowait> <silent> <buffer> t :call dirvish#open('tabedit', 0)<cr>
xnoremap <nowait> <silent> <buffer> t :call dirvish#open('tabedit', 0)<cr>

" Hide dot-prefixed files (restore with <c-l>)
nnoremap <nowait> <silent> <buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>
