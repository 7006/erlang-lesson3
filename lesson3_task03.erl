-module(lesson3_task03).

-export([split/2]).

%% Розділити рядок на частини з явною вказівкою роздільника
split(Text, Delimiter) ->
    DelimiterBin = list_to_binary(Delimiter),
    DelimiterSize = byte_size(DelimiterBin),
    <<DelimiterInt:DelimiterSize/binary>> = DelimiterBin,
    split(Text, [<<>>], DelimiterInt, DelimiterSize).

split(Text, Words, DelimiterInt, DelimiterSize) ->
    case Text of
        <<DelimiterInt:DelimiterSize/binary, Char/utf8, RestText/binary>> ->
            NextWords = [<<Char/utf8>> | Words],
            split(RestText, NextWords, DelimiterInt, DelimiterSize);
        <<Char/utf8, RestText/binary>> ->
            [<<Chars/binary>> | RestWords] = Words,
            NextWords = [<<Chars/binary, Char/utf8>> | RestWords],
            split(RestText, NextWords, DelimiterInt, DelimiterSize);
        <<>> ->
            reverse(Words)
    end.

reverse(L) ->
    reverse(L, []).

reverse([H | T], Acc) ->
    reverse(T, [H | Acc]);
reverse([], Acc) ->
    Acc.
