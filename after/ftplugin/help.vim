	fun! BuildHelpStatusLine(nr)
		return '%{SetupStl('.a:nr.')}
					\%#CurrMode# HELP %#SepMode#%{w:["active"] ? g:left_sep_sym : ""}%*
					\ %<%f
					\ %{getbufvar(w:["bufnr"], "&modified") ? g:mod_sym : " "}
					\ %{getbufvar(w:["bufnr"], "&modifiable") ? (getbufvar(w:["bufnr"], "&readonly") ? g:ro_sym : "") : g:ma_sym}
					\ %=
					\ %#SepMode#%{w:["active"] && w:["winwd"] >= 60 ? g:right_sep_sym : ""}
					\%#CurrMode#%{w:["winwd"] < 60 ? "" : g:pad . printf(" %d:%-2d %2d%% ", line("."), virtcol("."), 100 * line(".") / line("$"))}%*'
	endf

setlocal statusline=%!BuildHelpStatusLine(winnr())

