-module(lesson3_task02).
-export([words/1]).

-define(is_space(Char), (Char =:= 32)).

% Розділити рядок на слова
words(Text) ->
    words(Text, [<<>>]).

words(
    <<Char/utf8, NextChar/utf8, Text/binary>>,
    Words
) when
    ?is_space(Char),
    not ?is_space(NextChar)
->
    words(
        Text,
        [<<NextChar/utf8>> | Words]
    );
words(
    <<Char/utf8, Text/binary>>,
    [<<Word/binary>> | Words]
) ->
    words(
        Text,
        [<<Word/binary, Char/utf8>> | Words]
    );
words(<<>>, Words) ->
    lists:reverse(Words).
