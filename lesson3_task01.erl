-module(lesson3_task01).

-export([first_word/1]).

%% Витягти з рядка перше слово
first_word(Text) ->
    first_word(Text, <<>>).

first_word(Text, Word) ->
    case Text of
        <<Char/utf8, $\s, _/binary>> when Char =/= $\s ->
            first_word(<<>>, <<Word/binary, Char/utf8>>);
        <<Char/utf8, RestText/binary>> ->
            first_word(RestText, <<Word/binary, Char/utf8>>);
        <<>> ->
            Word
    end.
