fun! MyComplete()
  call complete(1, ['Hello', 'World'])
  return ''
endf

set ignorecase
set omnifunc=MyComplete

autocmd CompleteDone * echomsg "CompleteDone!"

fun! MyComplete(findstart, base)
  if a:findstart
    return match(getline('.'), '\S\+\%'.col('.').'c')
  else
    return filter(split("January Jane Janus Jank Janitor"), { i,v -> v =~ '^'.a:base })
endfun
