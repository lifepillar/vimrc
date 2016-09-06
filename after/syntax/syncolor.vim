if exists("syntax_cmd") && syntax_cmd == "reset"
  " Set the default values of our highlight groups for the status line
  hi! link Warnings    ErrorMsg
  hi! link NormalMode  StatusLine
  hi! link InsertMode  DiffText
  hi! link VisualMode  Visual
  hi! link ReplaceMode DiffChange
  hi! link CommandMode PmenuSel
endif

