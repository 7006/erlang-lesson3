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
        {array_start, Array} ->
            {array_done, Array2, <<>>} = decode_array(Array),
            Array2
    end.

%% ----------------------------------------------------------------------------
%% decode_array
%% ----------------------------------------------------------------------------
decode_array(Bin) ->
    decode_array(Bin, []).

decode_array(Bin, Array) ->
    case get_token(Bin) of
        {array_end, RestBin} ->
            {array_done, lists:reverse(Array), RestBin};
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
            {array_done, Array2, RestBin2} = decode_array(RestBin),
            decode_array(RestBin2, [Array2 | Array])
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
        <<Digit, RestBin/binary>> when Digit =:= $. andalso Type =:= integer ->
            get_number_token(RestBin, {float, <<Number/binary, Digit>>});
        <<C, _/binary>> when ?is_digit(C) ->
            <<Digit:1/binary, RestBin/binary>> = Bin,
            get_number_token(RestBin, {Type, <<Number/binary, Digit/binary>>});
        _ ->
            Number2 =
                case Type of
                    integer ->
                        binary_to_integer(Number);
                    float ->
                        binary_to_float(Number)
                end,

            {Type, Number2, Bin}
    end.
