-module(lesson3_task01).
-export([first_word/1]).

-define(is_space(Char), (Char =:= 32)).

% Витягти з рядка перше слово
first_word(<<Char/utf8, NextChar/utf8, _/binary>>) when
    not ?is_space(Char),
    ?is_space(NextChar)
->
    <<Char/utf8>>;
first_word(<<Char/utf8, Text/binary>>) ->
    <<Char/utf8, (first_word(Text))/binary>>;
first_word(<<>>) ->
    <<>>.
