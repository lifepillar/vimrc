" Enable a Pathogen blacklisted plugin.
fun! lf_loader#loadPlugin(plugin_name)
  " Remove the plugin from Pathogen's blacklist
  call filter(g:pathogen_blacklist, "v:val !=? '" . a:plugin_name ."'")
  " Update runtimepath
  call pathogen#surround($HOME . "/.vim/bundle/" . tolower(a:plugin_name))
  " Load the plugin
  " Note that this loads only one file (which is usually fine):
  runtime plugin/*.vim
  " Note that this uses the plugin name exactly as typed by the user:
  execute 'runtime! after/plugin/**/' . a:plugin_name . '.vim'
  " Plugin-specific activation
  if tolower(a:plugin_name) == 'youcompleteme'
    call youcompleteme#Enable()
  endif
endf

" See h :command
fun! lf_loader#complete(argLead, cmdLine, cursorPos)
  return filter(g:pathogen_blacklist, "v:val =~? '^" . a:argLead . "'")
endf

