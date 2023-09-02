-module(lesson3_task01).

-export([first_word/1]).

%% Витягти з рядка перше слово
first_word(Text) ->
    first_word(Text, <<>>).

first_word(Text, Word) ->
    case Text of
        <<Character/utf8, $\s, _/binary>> when Character =/= $\s ->
            <<Word/binary, Character/utf8>>;
        <<Character/utf8, RestText/binary>> ->
            first_word(RestText, <<Word/binary, Character/utf8>>);
        <<>> ->
            Word
    end.
