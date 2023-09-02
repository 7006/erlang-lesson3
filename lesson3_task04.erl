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
            decode_array(Array)
    end.

%% ----------------------------------------------------------------------------
%% decode_array
%% ----------------------------------------------------------------------------
decode_array(Bin) ->
    decode_array(Bin, []).

decode_array(Bin, Array) ->
    case get_token(Bin) of
        {array_end, RestBin} ->
            io:format(user, "~n array_end ~p ~p~n", [RestBin, Array]),
            lists:reverse(Array);
        {comma, RestBin} ->
            io:format(user, "~n decode_array comma ~p ~p~n", [RestBin, Array]),
            decode_array(RestBin, Array);
        {atom, Atom, RestBin} ->
            io:format(user, "~n decode_array atom ~p ~p ~p~n", [Atom, RestBin, Array]),
            decode_array(RestBin, [Atom | Array]);
        {integer, Integer, RestBin} ->
            io:format(user, "~n decode_array integer ~p ~p ~p~n", [Integer, RestBin, Array]),
            decode_array(RestBin, [Integer | Array]);
        {float, Float, RestBin} ->
            io:format(user, "~n decode_array float ~p ~p ~p~n", [Float, RestBin, Array]),
            decode_array(RestBin, [Float | Array]);
        {string, String, RestBin} ->
            io:format(user, "~n decode_array string ~p ~p ~p~n", [String, RestBin, Array]),
            decode_array(RestBin, [String | Array]);
        All ->
            io:format(user, "~n decode_array CATCHALL ~p~n", [All])
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
        All ->
            io:format(user, "~n~n get_number_token CATCHALL ~p ~p ~p ~p~n", [Bin, Type, Number, All]),

            Number2 =
                case Type of
                    integer ->
                        binary_to_integer(Number);
                    float ->
                        binary_to_float(Number)
                end,

            {Type, Number2, Bin}
    end.
