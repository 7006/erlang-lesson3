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
            get_string_token(RestBin);
        <<Digit, _/binary>> when Digit =:= $-; Digit >= $0, Digit =< $9 ->
            get_number_token(Bin)
    end.

get_string_token(Bin) ->
    get_string_token(Bin, <<>>).

get_string_token(<<$">>, S) ->
    S;
get_string_token(<<C/utf8, Bin/binary>>, S) ->
    get_string_token(Bin, <<S/binary, C/utf8>>).

get_number_token(Bin) ->
    get_number_token(Bin, {integer, <<>>}).

get_number_token(Bin, {Type, Number}) ->
    case Bin of
        <<Digit, RestBin/binary>> when Digit =:= $. andalso Type =:= integer ->
            get_number_token(RestBin, {float, <<Number/binary, Digit>>});
        <<Digit:1/binary, RestBin/binary>> ->
            get_number_token(RestBin, {Type, <<Number/binary, Digit/binary>>});
        <<>> ->
            {Type, Number}
    end.
