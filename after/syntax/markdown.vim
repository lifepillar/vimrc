syn region markdownInternalLink matchgroup=Delimiter start=/\[\[/ end=/\]\]/ oneline
syn match markdownTag /#\S\+/

hi link markdownInternalLink Underlined
hi link markdownTag Constant
hi link markdownCode PreProc
hi link markdownCodeBlock PreProc
