-module(lesson3_task02).

-export([words/1]).

%% Розділити рядок на слова
words(Text) ->
    words(Text, [<<>>]).

words(Text, Words) ->
    case Text of
        <<PrevChar/utf8, Char/utf8, RestText/binary>> when PrevChar =:= $\s, Char =/= $\s ->
            NextWords = [<<Char/utf8>> | Words],
            words(RestText, NextWords);
        <<Char/utf8, RestText/binary>> ->
            [<<Chars/binary>> | RestWords] = Words,
            NextWords = [<<Chars/binary, Char/utf8>> | RestWords],
            words(RestText, NextWords);
        <<>> ->
            reverse(Words)
    end.

reverse(L) ->
    reverse(L, []).

reverse([H | T], Acc) ->
    reverse(T, [H | Acc]);
reverse([], Acc) ->
    Acc.
