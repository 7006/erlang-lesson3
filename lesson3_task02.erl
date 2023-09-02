-module(lesson3_task02).

-export([words/1]).

-define(is_space(Char), (Char =:= $\s)).

% Розділити рядок на слова
words(Text) ->
    words(Text, [<<>>]).

words(Text, Words) ->
    case Text of
        <<PrevChar/utf8, Char/utf8, RestText/binary>> when
            ?is_space(PrevChar), not ?is_space(Char)
        ->
            NextWords = [<<Char/utf8>> | Words],
            words(RestText, NextWords);
        <<Char/utf8, RestText/binary>> ->
            [<<Chars/binary>> | RestWords] = Words,
            NextWords = [<<Chars/binary, Char/utf8>> | RestWords],
            words(RestText, NextWords);
        <<>> ->
            lists:reverse(Words)
    end.
