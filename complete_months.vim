set ignorecase
set omnifunc=MyComplete

fun! MyComplete(findstart, base)
  if a:findstart
    return match(getline('.'), '\S\+\%'.col('.').'c')
  else
    return filter(split("January Jane Janus Jank Janitor"), { i,v -> v =~ '^'.a:base })
endfun

" January Jane Janus Jank Janitor
" janus

