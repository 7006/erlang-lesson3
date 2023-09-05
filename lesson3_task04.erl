-module(lesson3_task04).

-export([decode/1]).

-define(is_whitespace(C), (C =:= $\s orelse C =:= $\t orelse C =:= $\n)).

-define(is_digit(C), (C =:= $- orelse C >= $0 andalso C =< $9)).

% Написати парсер JSON (має вміти працювати і з map і з proplists)
decode(Text) ->
    case get_token(Text) of
        {atom, Atom, <<>>} ->
            Atom;
        {integer, Integer, <<>>} ->
            Integer;
        {float, Float, <<>>} ->
            Float;
        {string, String, <<>>} ->
            String;
        {array_start, RestText} ->
            {Array, <<>>} = decode_array(RestText),
            Array
    end.

%% ----------------------------------------------------------------------------
%% decode_array
%% ----------------------------------------------------------------------------
decode_array(Text) ->
    decode_array(Text, []).

decode_array(Text, Array) ->
    case get_token(Text) of
        {array_end, NextText} ->
            {lesson3_lists:reverse(Array), NextText};
        {comma, RestText} ->
            decode_array(RestText, Array);
        {atom, Atom, RestText} ->
            decode_array(RestText, [Atom | Array]);
        {integer, Integer, RestText} ->
            decode_array(RestText, [Integer | Array]);
        {float, Float, RestText} ->
            decode_array(RestText, [Float | Array]);
        {string, String, RestText} ->
            decode_array(RestText, [String | Array]);
        {array_start, RestText} ->
            {NestedArray, NextText} = decode_array(RestText),
            decode_array(NextText, [NestedArray | Array])
    end.

%% ----------------------------------------------------------------------------
%% get_token
%% ----------------------------------------------------------------------------
get_token(Text) ->
    case Text of
        <<C, RestText/binary>> when ?is_whitespace(C) ->
            get_token(RestText);
        <<"[", RestText/binary>> ->
            {array_start, RestText};
        <<"]", RestText/binary>> ->
            {array_end, RestText};
        <<",", RestText/binary>> ->
            {comma, RestText};
        <<"true", RestText/binary>> ->
            {atom, true, RestText};
        <<"false", RestText/binary>> ->
            {atom, false, RestText};
        <<"null", RestText/binary>> ->
            {atom, null, RestText};
        <<$", RestText/binary>> ->
            get_string_token(RestText);
        <<C, _/binary>> when ?is_digit(C) ->
            get_number_token(Text)
    end.

%% ----------------------------------------------------------------------------
%% get_string_token
%% ----------------------------------------------------------------------------
get_string_token(Text) ->
    get_string_token(Text, <<>>).

get_string_token(Text, Chars) ->
    case Text of
        <<$", RestText/binary>> ->
            {string, Chars, RestText};
        <<Char/utf8, RestText/binary>> ->
            get_string_token(RestText, <<Chars/binary, Char/utf8>>)
    end.

%% ----------------------------------------------------------------------------
%% get_number_token
%% ----------------------------------------------------------------------------
get_number_token(Text) ->
    get_number_token(Text, {integer, <<>>}).

get_number_token(Text, {Type, Number}) ->
    case Text of
        <<$., RestText/binary>> when Type =:= integer ->
            get_number_token(RestText, {float, <<Number/binary, $.>>});
        <<C, _/binary>> when ?is_digit(C) ->
            <<Digit:1/binary, RestText/binary>> = Text,
            get_number_token(RestText, {Type, <<Number/binary, Digit/binary>>});
        _ ->
            Num =
                case Type of
                    integer ->
                        binary_to_integer(Number);
                    float ->
                        binary_to_float(Number)
                end,

            {Type, Num, Text}
    end.
