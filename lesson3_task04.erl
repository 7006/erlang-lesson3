-module(lesson3_task04).
-export([decode/1]).

% Написати парсер JSON (має вміти працювати і з map і з proplists)
decode(Bin) ->
    case get_token(Bin) of
        {atom, Atom} ->
            binary_to_atom(Atom);
        {integer, Integer} ->
            binary_to_integer(Integer);
        {float, Float} ->
            binary_to_float(Float);
        Token ->
            Token
    end.

get_token(Bin) when is_binary(Bin) ->
    case Bin of
        <<$t, $r, $u, $e>> ->
            {atom, Bin};
        <<$f, $a, $l, $s, $e>> ->
            {atom, Bin};
        <<$n, $u, $l, $l>> ->
            {atom, Bin};
        <<$", RestBin/binary>> ->
            decode_string(RestBin);
        <<C, _/binary>> when C =:= $-; C >= $0, C =< $9 ->
            get_number_token(Bin)
    end.

decode_string(Bin) ->
    decode_string(Bin, <<>>).

decode_string(<<$">>, S) ->
    S;
decode_string(<<C/utf8, Bin/binary>>, S) ->
    decode_string(Bin, <<S/binary, C/utf8>>).

get_number_token(Bin) ->
    get_number_token(Bin, {integer, <<>>}).

get_number_token(<<$., _/binary>> = Bin, {integer, Num}) ->
    get_number_token(Bin, {float, Num});
get_number_token(<<N:1/binary, Bin/binary>>, {Fn, Num}) ->
    get_number_token(Bin, {Fn, <<Num/binary, N/binary>>});
get_number_token(<<>>, Token) ->
    Token.
