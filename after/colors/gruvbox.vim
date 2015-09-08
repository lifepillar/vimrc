let s:contrast_levels =  [ "hard",           "medium",         "soft"         ]

if &background ==# "dark"
  let s:bg_color       = [[234, '#1d2021'], [235, '#282828'], [236, '#32302f']]
  let s:fg_color       = [[248, '#bdae93'], [246, '#a89984'], [245, '#928374']]
  let s:red            = [[167, '#fb4934'], [167, '#fb4934'], [124, '#cc241d']]
  let s:green          = [[142, '#b8bb26'], [142, '#b8bb26'], [106, '#98971a']]
  let s:yellow         = [[214, '#fabd2f'], [214, '#fabd2f'], [172, '#d79921']]
  let s:blue           = [[109, '#83a598'], [109, '#83a598'], [ 66, '#458588']]
  let s:purple         = [[175, '#d3869b'], [175, '#d3869b'], [132, '#b16286']]
  let s:aqua           = [[108, '#8ec07c'], [108, '#8ec07c'], [ 72, '#689d6a']]
  let s:orange         = [[208, '#fe8019'], [208, '#fe8019'], [166, '#d65d0e']]
else
  let s:bg_color       = [[230, '#f9f5d7'], [229, '#fdf4c1'], [228, '#f2e5bc']]
  let s:fg_color       = [[241, '#665c54'], [243, '#7c6f64'], [244, '#928374']]
  let s:red            = [[ 88, '#9d0006'], [ 88, '#9d0006'], [124, '#cc241d']]
  let s:green          = [[100, '#79740e'], [100, '#79740e'], [106, '#98971a']]
  let s:yellow         = [[136, '#b57614'], [136, '#b57614'], [172, '#d79921']]
  let s:blue           = [[ 24, '#076678'], [ 24, '#076678'], [ 66, '#458588']]
  let s:purple         = [[ 96, '#8f3f71'], [ 96, '#8f3f71'], [132, '#b16286']]
  let s:aqua           = [[ 66, '#427b58'], [ 66, '#427b58'], [ 72, '#689d6a']]
  let s:orange         = [[130, '#af3a03'], [130, '#af3a03'], [166, '#d65d0e']]
endif

let s:i    = has("gui_running")
let s:c    = index(s:contrast_levels, g:gruvbox_contrast)
let s:mode = ["cterm", "gui"]
let s:bg   = s:mode[s:i] . "bg="
let s:fg   = s:mode[s:i] . "fg="

execute "hi NormalMode"  s:bg.s:bg_color[s:c][s:i] s:fg.s:fg_color[s:c][s:i] s:mode[s:i]."=reverse"
execute "hi InsertMode"  s:bg.s:bg_color[s:c][s:i] s:fg.s:blue[s:c][s:i]     s:mode[s:i]."=reverse"
execute "hi ReplaceMode" s:bg.s:bg_color[s:c][s:i] s:fg.s:aqua[s:c][s:i]     s:mode[s:i]."=reverse"
execute "hi VisualMode"  s:bg.s:bg_color[s:c][s:i] s:fg.s:orange[s:c][s:i]   s:mode[s:i]."=reverse"
execute "hi CommandMode" s:bg.s:bg_color[s:c][s:i] s:fg.s:purple[s:c][s:i]   s:mode[s:i]."=reverse"
execute "hi Warnings"    s:bg.s:bg_color[s:c][s:i] s:fg.s:orange[s:c][s:i]   s:mode[s:i]."=reverse"

command! IncreaseContrast
      \ let g:gruvbox_contrast =
      \ get(s:contrast_levels, (2 + index(s:contrast_levels, g:gruvbox_contrast)) % 3) |
      \ colorscheme gruvbox

command! ReduceContrast
      \ let g:gruvbox_contrast =
      \ get(s:contrast_levels, (1 + index(s:contrast_levels, g:gruvbox_contrast)) % 3) |
      \ colorscheme gruvbox

