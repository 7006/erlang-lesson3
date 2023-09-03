-module(lesson3_task03).

-export([split/2]).

%% Розділити рядок на частини з явною вказівкою роздільника
split(Text, DelimiterString) ->
    DelimiterBin = <<<<Char/utf8>> || Char <- DelimiterString>>,
    Delimiter = {DelimiterBin, byte_size(DelimiterBin)},
    split(Text, Delimiter, [<<>>]).

split(Text, {Bin, Size} = Delimiter, [<<Word/binary>> | RestWords] = Words) ->
    case Text of
        <<Bin:Size/binary, Char/utf8, RestText/binary>> ->
            split(RestText, Delimiter, [<<Char/utf8>> | Words]);
        <<Char/utf8, RestText/binary>> ->
            split(RestText, Delimiter, [<<Word/binary, Char/utf8>> | RestWords]);
        <<>> ->
            reverse(Words)
    end.

reverse(L) ->
    reverse(L, []).

reverse([H | T], Acc) ->
    reverse(T, [H | Acc]);
reverse([], Acc) ->
    Acc.
