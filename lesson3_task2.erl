-module(lesson3_task2).

-export([words/1]).

%% Розділити рядок на слова
words(Text) ->
    words(Text, <<>>, []).

words(Text, <<Word/binary>>, Words) ->
    case Text of
        <<$\s, RestText/binary>> ->
            words(RestText, Word, Words);
        <<Char/utf8>> ->
            words(<<>>, <<>>, [<<Word/binary, Char/utf8>> | Words]);
        <<Char/utf8, $\s, RestText/binary>> ->
            words(RestText, <<>>, [<<Word/binary, Char/utf8>> | Words]);
        <<Char/utf8, RestText/binary>> ->
            words(RestText, <<Word/binary, Char/utf8>>, Words);
        <<>> ->
            reverse(Words)
    end.

reverse(L) ->
    reverse(L, []).

reverse([H | T], Acc) ->
    reverse(T, [H | Acc]);
reverse([], Acc) ->
    Acc.
