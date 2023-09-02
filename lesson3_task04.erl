-module(lesson3_task04).
-export([decode/1]).

-define(is_whitespace(C), (C =:= $\s orelse C =:= $\t orelse C =:= $\n)).

-define(is_digit(C), (C =:= $- orelse C >= $0 andalso C =< $9)).

% Написати парсер JSON (має вміти працювати і з map і з proplists)
decode(Bin) ->
    case get_token(Bin) of
        {atom, Atom, <<>>} ->
            Atom;
        {integer, Integer, <<>>} ->
            Integer;
        {float, Float, <<>>} ->
            Float;
        {string, String, <<>>} ->
            String;
        {array_start, RestBin} ->
            {Array, <<>>} = decode_array(RestBin),
            Array
    end.

%% ----------------------------------------------------------------------------
%% decode_array
%% ----------------------------------------------------------------------------
decode_array(Bin) ->
    decode_array(Bin, []).

decode_array(Bin, Array) ->
    case get_token(Bin) of
        {array_end, NextBin} ->
            {lists:reverse(Array), NextBin};
        {comma, RestBin} ->
            decode_array(RestBin, Array);
        {atom, Atom, RestBin} ->
            decode_array(RestBin, [Atom | Array]);
        {integer, Integer, RestBin} ->
            decode_array(RestBin, [Integer | Array]);
        {float, Float, RestBin} ->
            decode_array(RestBin, [Float | Array]);
        {string, String, RestBin} ->
            decode_array(RestBin, [String | Array]);
        {array_start, RestBin} ->
            {NestedArray, NextBin} = decode_array(RestBin),
            decode_array(NextBin, [NestedArray | Array])
    end.

%% ----------------------------------------------------------------------------
%% get_token
%% ----------------------------------------------------------------------------
get_token(Bin) when is_binary(Bin) ->
    case Bin of
        <<C, RestBin/binary>> when ?is_whitespace(C) ->
            get_token(RestBin);
        <<"[", RestBin/binary>> ->
            {array_start, RestBin};
        <<"]", RestBin/binary>> ->
            {array_end, RestBin};
        <<",", RestBin/binary>> ->
            {comma, RestBin};
        <<"true", RestBin/binary>> ->
            {atom, true, RestBin};
        <<"false", RestBin/binary>> ->
            {atom, false, RestBin};
        <<"null", RestBin/binary>> ->
            {atom, null, RestBin};
        <<$", RestBin/binary>> ->
            get_string_token(RestBin);
        <<C, _/binary>> when ?is_digit(C) ->
            get_number_token(Bin)
    end.

%% ----------------------------------------------------------------------------
%% get_string_token
%% ----------------------------------------------------------------------------
get_string_token(Bin) ->
    get_string_token(Bin, <<>>).

get_string_token(Bin, Chars) ->
    case Bin of
        <<$", RestBin/binary>> ->
            {string, Chars, RestBin};
        <<Char/utf8, RestBin/binary>> ->
            get_string_token(RestBin, <<Chars/binary, Char/utf8>>)
    end.

%% ----------------------------------------------------------------------------
%% get_number_token
%% ----------------------------------------------------------------------------
get_number_token(Bin) ->
    get_number_token(Bin, {integer, <<>>}).

get_number_token(Bin, {Type, Number}) ->
    case Bin of
        <<$., RestBin/binary>> when Type =:= integer ->
            get_number_token(RestBin, {float, <<Number/binary, $.>>});
        <<C, _/binary>> when ?is_digit(C) ->
            <<Digit:1/binary, RestBin/binary>> = Bin,
            get_number_token(RestBin, {Type, <<Number/binary, Digit/binary>>});
        _ ->
            Num =
                case Type of
                    integer ->
                        binary_to_integer(Number);
                    float ->
                        binary_to_float(Number)
                end,

            {Type, Num, Bin}
    end.
