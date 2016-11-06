" Useful abbreviations
iab <buffer> t. create table  (<cr><cr>);<up><c-o>3<left>
iab <buffer> tr. create trigger <cr>[before\|after\|instead of] {event}<cr>on {table}<cr>[not deferrable\|initially immediate]<cr>for each [row\|statement]<cr>execute procedure ();<c-o>5<up>

iab <buffer> s. select *<cr>  from<cr><bs> where<cr><space>order by ;<c-o>3<up>
iab <buffer> f. create or replace function N<c-o>mn (<cr>P<c-o>mp<cr>) returns T<c-o>mt<cr>language L<c-o>ml as $$<cr>B<c-o>mb<cr>$$;<esc>`n
iab <buffer> d. create domain N<c-o>mn as A<c-o>ma;
