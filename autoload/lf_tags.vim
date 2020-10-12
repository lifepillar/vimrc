" Jump from the current file to related files based on file suffixes (e.g.,
" from Foo.cpp to Foo.hpp and vice versa).
"
" Note: Requires a `tags` file created by `ctags` with the option `--extra=+f`.
"
" The dictionary below maps the suffix of the current file to a list of
" candidate suffixes for alternate files.
fun! lf_tags#alt_file()
  execute "tjump" '/^'.expand("%:t:r").'\.\('.join(get(
        \ {
        \ 'c':   ['h'],
        \ 'cpp': ['h','hpp'],
        \ 'h':   ['c','cpp'],
        \ 'hpp': ['cpp'],
        \ 'vim': ['vim']
        \ },
        \  expand("%:e"), ['UNKNOWN EXTENSION']), '\\|') . '\)$'
endf

fun! lf_tags#ctags(args)
  if empty(tagfiles()) " New tags file
    let l:dir = local#search#choose_dir('Create tags in:')
    if empty(l:dir) | return | endif
    let l:dirs = [fnamemodify(l:dir, ':p')]
  else
    let l:dirs = map(tagfiles(), { i,v -> fnamemodify(v, ':p:h') })
  endif
  for l:tagdir in l:dirs
    if !isdirectory(l:tagdir)
      call lf_msg#warn("Directory " . l:tagdir . " does not exist.")
      return
    endif
    call lf_msg#notice('Tagging ' . l:tagdir)
    let s:res = lf_run#job(['ctags',
          \ '-R',
          \ '--sort=foldcase',
          \ '--extra=+fq',
          \ '--fields=+iaS',
          \ '--c++-kinds=+p',
          \ '--exclude=cache',
          \ '--exclude=third_party',
          \ '--exclude=tmp',
          \ '--exclude=*.html'] + split(a:args),
          \ { 'cwd': l:tagdir })
  endfor
endf

fun! lf_tags#cscope(args)
  let l:dir = getcwd()
  if l:dir != expand("%:p:h")
    let l:dir = local#search#choose_dir()
    if empty(l:dir) | return | endif
  endif
  let s:res = lf_run#job(['cscope', '-R', '-q', '-b'] + split(a:args), {'cwd': l:dir})
endf

fun! lf_tags#load_cscope_db()
  let l:db = findfile("cscope.out", ".;") " See :h findfile()
  if !empty(l:db)
    execute "cscope add" fnameescape(l:db)
  endif
  return !empty(l:db)
endf

" Adapted from CtrlP's buffertag.vim
let s:types = {
  \ 'ant':        '%sant',
  \ 'asm':        '%sasm',
  \ 'aspperl':    '%sasp',
  \ 'aspvbs':     '%sasp',
  \ 'awk':        '%sawk',
  \ 'beta':       '%sbeta',
  \ 'c':          '%sc',
  \ 'cpp':        '%sc++',
  \ 'cs':         '%sc#',
  \ 'cobol':      '%scobol',
  \ 'context':    '%scontext',
  \ 'delphi':     '%spascal',
  \ 'dosbatch':   '%sdosbatch',
  \ 'eiffel':     '%seiffel',
  \ 'erlang':     '%serlang',
  \ 'expect':     '%stcl',
  \ 'fortran':    '%sfortran',
  \ 'go':         '%sgo',
  \ 'html':       '%shtml',
  \ 'java':       '%sjava',
  \ 'javascript': '%sjavascript',
  \ 'lisp':       '%slisp',
  \ 'lua':        '%slua',
  \ 'make':       '%smake',
  \ 'markdown':   '%smarkdown',
  \ 'matlab':     '%smatlab',
  \ 'mf':         '%smetapost',
  \ 'mp':         '%smetapost',
  \ 'ocaml':      '%socaml',
  \ 'pascal':     '%spascal',
  \ 'perl':       '%sperl',
  \ 'php':        '%sphp',
  \ 'python':     '%spython',
  \ 'rexx':       '%srexx',
  \ 'rmd':        '%srmarkdown',
  \ 'ruby':       '%sruby',
  \ 'rust':       '%srust',
  \ 'scheme':     '%sscheme',
  \ 'sh':         '%ssh',
  \ 'csh':        '%ssh',
  \ 'zsh':        '%ssh',
  \ 'scala':      '%sscala',
  \ 'slang':      '%sslang',
  \ 'sml':        '%ssml',
  \ 'sql':        '%spgsql',
  \ 'tex':        '%slatex',
  \ 'tcl':        '%stcl',
  \ 'vera':       '%svera',
  \ 'verilog':    '%sverilog',
  \ 'vhdl':       '%svhdl',
  \ 'vim':        '%svim',
  \ 'yacc':       '%syacc',
  \ }

call map(s:types, 'printf(v:val, "--language-force=")')

fun! lf_tags#file_tags(path, ft)
    return systemlist('ctags -f - --sort=no --excmd=number --fields= --extra= --file-scope=yes '
          \ . get(s:types, a:ft, '') . ' '
          \ . shellescape(expand(a:path)))
endf
