-module(lesson3_task01).

-export([first_word/1]).

% Витягти з рядка перше слово
first_word(Text) ->
    case Text of
        <<Character/utf8, $\s, _/binary>> when Character =/= $\s ->
            <<Character/utf8>>;
        <<Character/utf8, RestText/binary>> ->
            <<Character/utf8, (first_word(RestText))/binary>>;
        <<>> ->
            <<>>
    end.
