-module(lesson3_task02).

-export([words/1]).

%% Розділити рядок на слова
words(Text) ->
    words(Text, [<<>>]).

words(Text, [<<Word/binary>> | RestWords] = Words) ->
    case Text of
        <<$\s, Char/utf8, RestText/binary>> when Char =/= $\s ->
            words(RestText, [<<Char/utf8>> | Words]);
        <<Char/utf8, RestText/binary>> ->
            words(RestText, [<<Word/binary, Char/utf8>> | RestWords]);
        <<>> ->
            lesson3_lists:reverse(Words)
    end.
