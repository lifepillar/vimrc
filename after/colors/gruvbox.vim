let s:contrast_levels =  [ "hard",           "medium",         "soft"         ]

if &background ==# "dark"
  let s:bg_color       = [['#1d2021', 234], ['#282828', 235], ['#32302f', 236]]
  let s:fg_color       = [['#bdae93', 248], ['#a89984', 246], ['#928374', 245]]
  let s:red            = [['#fb4934', 167], ['#fb4934', 167], ['#cc241d', 124]]
  let s:green          = [['#b8bb26', 142], ['#b8bb26', 142], ['#98971a', 106]]
  let s:yellow         = [['#fabd2f', 214], ['#fabd2f', 214], ['#d79921', 172]]
  let s:blue           = [['#83a598', 109], ['#83a598', 109], ['#458588',  66]]
  let s:purple         = [['#d3869b', 175], ['#d3869b', 175], ['#b16286', 132]]
  let s:aqua           = [['#8ec07c', 108], ['#8ec07c', 108], ['#689d6a',  72]]
  let s:orange         = [['#fe8019', 208], ['#fe8019', 208], ['#d65d0e', 166]]
else
  let s:bg_color       = [['#f9f5d7', 230], ['#fdf4c1', 229], ['#f2e5bc', 228]]
  let s:fg_color       = [['#665c54', 241], ['#7c6f64', 243], ['#928374', 244]]
  let s:red            = [['#9d0006',  88], ['#9d0006',  88], ['#cc241d', 124]]
  let s:green          = [['#79740e', 100], ['#79740e', 100], ['#98971a', 106]]
  let s:yellow         = [['#b57614', 136], ['#b57614', 136], ['#d79921', 172]]
  let s:blue           = [['#076678',  24], ['#076678',  24], ['#458588',  66]]
  let s:purple         = [['#8f3f71',  96], ['#8f3f71',  96], ['#b16286', 132]]
  let s:aqua           = [['#427b58',  66], ['#427b58',  66], ['#689d6a',  72]]
  let s:orange         = [['#af3a03', 130], ['#af3a03', 130], ['#d65d0e', 166]]
endif

let s:i    = !has("gui_running")
let s:c    = index(s:contrast_levels, g:gruvbox_contrast)
let s:mode = ["gui", "cterm"]
let s:bg   = s:mode[0] . "bg="
let s:fg   = s:mode[0] . "fg="

execute "hi NormalMode"  s:bg.s:fg_color[s:c][s:i] s:fg.s:bg_color[s:c][s:i] s:mode[s:i]."=NONE"
execute "hi InsertMode"  s:bg.s:blue[s:c][s:i]     s:fg.s:bg_color[s:c][s:i] s:mode[s:i]."=NONE"
execute "hi ReplaceMode" s:bg.s:aqua[s:c][s:i]     s:fg.s:bg_color[s:c][s:i] s:mode[s:i]."=NONE"
execute "hi VisualMode"  s:bg.s:orange[s:c][s:i]   s:fg.s:bg_color[s:c][s:i] s:mode[s:i]."=NONE"
execute "hi CommandMode" s:bg.s:purple[s:c][s:i]   s:fg.s:bg_color[s:c][s:i] s:mode[s:i]."=NONE"
execute "hi Warnings"    s:bg.s:orange[s:c][s:i]   s:fg.s:bg_color[s:c][s:i] s:mode[s:i]."=NONE"

command! IncreaseContrast
      \ let g:gruvbox_contrast =
      \ get(s:contrast_levels, (2 + index(s:contrast_levels, g:gruvbox_contrast)) % 3) |
      \ colorscheme gruvbox

command! ReduceContrast
      \ let g:gruvbox_contrast =
      \ get(s:contrast_levels, (1 + index(s:contrast_levels, g:gruvbox_contrast)) % 3) |
      \ colorscheme gruvbox

