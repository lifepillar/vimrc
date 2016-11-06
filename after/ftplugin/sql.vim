" Use <c-i> and <c-o> (in Normal mode) to jump between the different parts of a snippet.
iab <buffer> t… create table <c-o>ma (<cr><c-o>mb<cr>);<esc>`a`b<c-o>a<c-r>=lf_text#eatchar('\s')<cr>

iab <buffer> tr… create trigger<space><c-o>ma<cr><c-o>mb[before\|after\|instead of] {event}<cr>on
      \ <c-o>mc[not deferrable\|initially immediate]<cr>for each <c-o>md[row\|statement]<cr><c-d>execute procedure
      \ (<c-o>me);<cr><esc>`a`b`c`d`e4<c-o>a<c-r>=lf_text#eatchar('\s')<cr>

iab <buffer> s… select *<c-o>ma<cr>  from <c-o>mb<cr><bs> where <c-o>mc<cr>
      \ order by <c-o>md;<esc>`a`b`c`d3<c-o>R<c-r>=lf_text#eatchar('\s')<cr>

iab <buffer> f… create or replace function <c-o>ma (<cr><c-o>mb<cr>) returns
      \ <c-o>mc<cr>language <c-o>md as $$<cr><c-o>me<cr>$$;<esc>`a`b`c`d`e4<c-o>a<c-r>=lf_text#eatchar('\s')<cr>

