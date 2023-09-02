-module(lesson3_task01).

-export([first_word/1]).

% Витягти з рядка перше слово
first_word(Text) ->
    case Text of
        <<PrevChar/utf8, Char/utf8, _/binary>> when PrevChar =/= $\s, Char =:= $\s ->
            <<PrevChar/utf8>>;
        <<Char/utf8, RestText/binary>> ->
            <<Char/utf8, (first_word(RestText))/binary>>;
        <<>> ->
            <<>>
    end.
