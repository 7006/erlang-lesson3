-module(lesson3_task02).

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
            lesson3_lists:reverse(Words)
    end.
