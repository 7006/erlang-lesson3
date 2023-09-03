-module(lesson3_task02).

-export([words/1]).

%% Розділити рядок на слова
words(Text) ->
    words(Text, [<<>>]).

words(Text, Words) ->
    case Text of
        <<$\s, Char/utf8, RestText/binary>> when Char =/= $\s ->
            words(RestText, [<<Char/utf8>> | Words]);
        <<Char/utf8, RestText/binary>> ->
            [<<Word/binary>> | RestWords] = Words,
            words(RestText, [<<Word/binary, Char/utf8>> | RestWords]);
        <<>> ->
            reverse(Words)
    end.

reverse(L) ->
    reverse(L, []).

reverse([H | T], Acc) ->
    reverse(T, [H | Acc]);
reverse([], Acc) ->
    Acc.
