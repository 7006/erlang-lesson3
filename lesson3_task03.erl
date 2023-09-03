-module(lesson3_task03).

-export([split/2]).

%% Розділити рядок на частини з явною вказівкою роздільника
split(Text, Delimiter) ->
    split(Text, [<<>>], convert_delimiter(Delimiter)).

split(Text, [<<Word/binary>> | RestWords] = Words, {Bin, Size} = Delimiter) ->
    case Text of
        <<_/binary>> when Size =:= 0 ->
            [Text];
        <<Bin:Size/binary, Bin:Size/binary, RestText/binary>> ->
            split(<<Bin:Size/binary, RestText/binary>>, [<<>> | Words], Delimiter);
        <<Bin:Size/binary, RestText/binary>> ->
            split(<<RestText/binary>>, [<<>> | Words], Delimiter);
        <<Bin:Size/binary, Char/utf8, RestText/binary>> ->
            split(RestText, [<<Char/utf8>> | Words], Delimiter);
        <<Char/utf8, RestText/binary>> ->
            split(RestText, [<<Word/binary, Char/utf8>> | RestWords], Delimiter);
        <<>> ->
            reverse(Words)
    end.

convert_delimiter(String) ->
    Bin = <<<<Int/integer>> || Int <- String>>,
    Size = byte_size(Bin),
    {Bin, Size}.

reverse(L) ->
    reverse(L, []).

reverse([H | T], Acc) ->
    reverse(T, [H | Acc]);
reverse([], Acc) ->
    Acc.
