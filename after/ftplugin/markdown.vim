setlocal autoindent
setlocal conceallevel=2
setlocal dictionary=/usr/share/dict/words
" Disable HTML completion function set by the Markdown plugin.
setlocal omnifunc=
setlocal spell
setlocal spelllang=en

" Better syntax highlighting
syn clear markdownItalic
syn clear markdownBold
syn clear markdownBoldItalic
syn region markdownItalic     matchgroup=markdownItalicDelimiter     start="\(^\|[^0-9A-Za-z_{}]\)\@<=\*\S\@="     end="\S\@<=\*\(\W\|$\)\@="     keepend contains=markdownLineStart concealends
syn region markdownItalic     matchgroup=markdownItalicDelimiter     start="\(^\|[^0-9A-Za-z_{}]\)\@<=_\S\@="      end="\S\@<=_\(\W\|$\)\@="      keepend contains=markdownLineStart concealends
syn region markdownBold       matchgroup=markdownBoldDelimiter       start="\(^\|[^0-9A-Za-z_{}]\)\@<=\*\*\S\@="   end="\S\@<=\*\*\(\W\|$\)\@="   keepend contains=markdownLineStart,markdownItalic concealends
syn region markdownBold       matchgroup=markdownBoldDelimiter       start="\(^\|[^0-9A-Za-z_{}]\)\@<=__\S\@="     end="\S\@<=__\(\W\|$\)\@="     keepend contains=markdownLineStart,markdownItalic concealends
syn region markdownBoldItalic matchgroup=markdownBoldItalicDelimiter start="\(^\|[^0-9A-Za-z_{}]\)\@<=\*\*\*\S\@=" end="\S\@<=\*\*\*\(\W\|$\)\@=" keepend contains=markdownLineStart concealends
syn region markdownBoldItalic matchgroup=markdownBoldItalicDelimiter start="\(^\|[^0-9A-Za-z_{}]\)\@<=___\S\@="    end="\S\@<=___\(\W\|$\)\@="    keepend contains=markdownLineStart concealends
syn clear markdownError
hi def link markdownItalicDelimiter       markdownItalic
hi def link markdownBoldDelimiter         markdownBold
hi def link markdownBoldItalicDelimiter   markdownBoldItalic

" Folding rule
setlocal foldmethod=syntax
syn region markdownHeaderFold
      \ start="^\s*\z(#\+\)"
      \ skip="^\s*\z1#\+"
      \ end="^\(\s*#\)\@="
      \ fold contains=TOP

