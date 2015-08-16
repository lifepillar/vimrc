	fun! BuildHelpStatusLine(nr)
		return '%{SetupStl('.a:nr.')}
					\%#CurrMode# %{w:["active"] ? get(g:mode_map, mode(1), ["??????"])[0] . (&paste ? " PASTE" : "") : " "}
					\ %#SepMode#%{w:["active"] ? g:left_sep_sym : ""}%*
					\ %<%F
					\ %{getbufvar(w:["bufnr"], "&modified") ? g:mod_sym : " "}
					\ %{getbufvar(w:["bufnr"], "&modifiable") ? (getbufvar(w:["bufnr"], "&readonly") ? g:ro_sym : "") : g:ma_sym}
					\ %=
					\ %{w:["ft"]}
					\ %#SepMode#%{w:["active"] && w:["winwd"] >= 60 ? g:right_sep_sym : ""}
					\%#CurrMode#%{w:["winwd"] < 60 ? "" : g:pad . printf(" %d:%-2d %2d%% ", line("."), virtcol("."), 100 * line(".") / line("$"))}%*'
	endf

setlocal statusline=%!BuildHelpStatusLine(winnr())

