syn region markdownInternalLink matchgroup=Delimiter start=/\[\[/ end=/\]\]/
syn match markdownTag /#\S\+/

hi link markdownInternalLink Underlined
hi link markdownTag Constant
