compiler tex

" Better auto-completion for things like '\label{fig:...'
setlocal iskeyword+=:
" See :h tex-conceal
setlocal conceallevel=0

" Typeset with lualatex/pdflatex
nnoremap <silent><buffer> <leader>tt :<c-u>update<cr>:LuaLaTeX<cr>
nnoremap <silent><buffer> <leader>tp :<c-u>update<cr>:PdfLaTeX<cr>
" Clean generated files:
nnoremap <silent><buffer> <leader>tc :<c-u>call local#tex#clean()<cr>
" Open PDF previewer (Skim):
nnoremap <silent><buffer> <leader>tv :<c-u>call local#tex#preview()<cr>
" Forward search using Skim:
nnoremap <silent><buffer> <leader>ts :<c-u>call local#tex#forward_search()<cr>

let s:tp_regex = '^$\|^\s*\(\\item\|\\begin\|\\end\|\\\(sub\)*section\|\\label\|\(small\|med\|big\)skip\)'

fun! s:tp()
  call cursor(search(s:tp_regex, 'bcW')+1, 1)
  normal! V
  call cursor(search(s:tp_regex, 'W')-1, 1)
endf

" Reflow paragraph with gqtp ("gq TeX paragraph")
omap     <silent><buffer> tp :<c-u>call <sid>tp()<cr>
" Select TeX paragraph
vnoremap <silent><buffer> tp <esc>:<c-u>call <sid>tp()<cr>

" $...$ text object
onoremap <silent><buffer> i$ :<c-u>normal! T$vt$<cr>
onoremap <silent><buffer> a$ :<c-u>normal! F$vf$<cr>
vnoremap <buffer> i$ T$ot$
vnoremap <buffer> a$ F$of$

command! -buffer -nargs=? -complete=file LuaLaTeX       call local#tex#typeset({'latexmk': ['-lualatex']}, <q-args>)
command! -buffer -nargs=? -complete=file PdfLaTeX       call local#tex#typeset({'latexmk': ['-pdf']}, <q-args>)
command!         -nargs=0                LaTeXJobStatus call local#tex#job_status()
command!         -nargs=0                LatexStopJobs  call local#tex#stop_jobs()

call local#text#load_snippets()
