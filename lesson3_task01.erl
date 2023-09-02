-module(lesson3_task01).

-export([first_word/1]).

% Витягти з рядка перше слово
first_word(Text) ->
    case Text of
        <<PrevChar/utf8, Char/utf8, _/binary>> when PrevChar =/= $\s, Char =:= $\s ->
            <<PrevChar/utf8>>;
        <<Char/utf8, RestText/binary>> ->
            NextText = first_word(RestText),
            <<Char/utf8, NextText/binary>>;
        <<>> ->
            <<>>
    end.
