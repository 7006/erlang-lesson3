-module(lesson3_task04).
-export([decode/1]).

% Написати парсер JSON (має вміти працювати і з map і з proplists)
decode(Bin) when is_binary(Bin) ->
    case Bin of
        <<"true">> ->
            decode_atom(Bin);
        <<"false">> ->
            decode_atom(Bin);
        <<"null">> ->
            decode_atom(Bin);
        <<$", RestBin/binary>> ->
            decode_string(RestBin);
        <<C, _/binary>> when C =:= $-; C >= $0, C =< $9 ->
            decode_number(Bin)
    end.

decode_atom(Bin) ->
    binary_to_atom(Bin).

decode_string(Bin) ->
    decode_string(Bin, <<>>).

decode_string(<<$">>, S) ->
    S;
decode_string(<<C/utf8, Bin/binary>>, S) ->
    decode_string(Bin, <<S/binary, C/utf8>>).

decode_number(Bin) ->
    decode_number(Bin, {integer, <<>>}).

decode_number(<<$., _/binary>> = Bin, {integer, Num}) ->
    decode_number(Bin, {float, Num});
decode_number(<<N:1/binary, Bin/binary>>, {Fn, Num}) ->
    decode_number(Bin, {Fn, <<Num/binary, N/binary>>});
decode_number(<<>>, {integer, Num}) ->
    binary_to_integer(Num);
decode_number(<<>>, {float, Num}) ->
    binary_to_float(Num).
