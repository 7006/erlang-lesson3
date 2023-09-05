-module(lesson3_task04).

-export([decode/1]).

-define(is_whitespace(C), (C =:= $\s orelse C =:= $\t orelse C =:= $\n)).

-define(is_digit(C), (C =:= $- orelse C >= $0 andalso C =< $9)).

% Написати парсер JSON (має вміти працювати і з map і з proplists)
decode(Text) ->
    case get_token(Text) of
        {value, V, <<>>} ->
            V;
        {enter_object, RestText} ->
            {Object, <<>>} = decode_object(RestText),
            Object;
        {enter_array, RestText} ->
            {Array, <<>>} = decode_array(RestText),
            Array
    end.
%% ----------------------------------------------------------------------------
%% decode_object
%% ----------------------------------------------------------------------------
decode_object(Text) ->
    decode_object(Text, [], no_key, no_value).

% { "a" : 1, "b" : [true], "c": ["aaaa"] }
decode_object(Text, Object, Key1, Value1) ->
    case get_token(Text) of
        {value, Key, RestText} when Key1 =:= no_key, Value1 =:= no_value ->
            io:format(user, "~n~n1 ~p ~p ~p ~p ~p~n", [
                Key,
                RestText,
                Key1,
                Value1,
                Object
            ]),
            decode_object(RestText, Object, Key, no_value);
        {colon, RestText} when Key1 =/= no_key ->
            io:format(user, "~n~ncolon ~p ~p ~p ~p ~p~n", [
                xxx,
                RestText,
                Key1,
                Value1,
                Object
            ]),
            decode_object(RestText, Object, Key1, no_value);
        {value, Value, RestText} when Key1 =/= no_key, Value1 =:= no_value ->
            io:format(user, "~n~n3 ~p ~p ~p ~p ~p~n", [
                Value,
                RestText,
                Key1,
                Value1,
                Object
            ]),
            decode_object(RestText, Object, Key1, Value);
        {enter_array, RestText} when Key1 =/= no_key, Value1 =:= no_value ->
            {Array, NextText} = decode_array(RestText),
            decode_object(NextText, Object, Key1, Array);
        {enter_object, RestText} when Key1 =/= no_key, Value1 =:= no_value ->
            {NestedObject, NextText} = decode_object(RestText),
            decode_object(NextText, Object, Key1, NestedObject);
        {comma, RestText} when Key1 =/= no_key, Value1 =/= no_value ->
            % M1 = maps:put(Key1, Value1, M),
            Object1 = [{Key1, Value1} | Object],
            decode_object(RestText, Object1, no_key, no_value);
        {exit_object, RestText} when Key1 =:= no_key, Value1 =:= no_value ->
            {Object, RestText};
        {exit_object, RestText} when Key1 =/= no_key, Value1 =/= no_value ->
            io:format(user, "~n~nexit object ~p ~p ~p ~p ~p~n", [
                yyy,
                RestText,
                Key1,
                Value1,
                Object
            ]),
            Object1 = [{Key1, Value1} | Object],
            Object2 = lists:reverse(Object1),

            io:format(user, "~n~nexit object ~p ~p~n", [
                RestText,
                Object2
            ]),

            {Object2, RestText}
    end.

%% ----------------------------------------------------------------------------
%% decode_array
%% ----------------------------------------------------------------------------
decode_array(Text) ->
    decode_array(Text, []).

decode_array(Text, Array) ->
    case get_token(Text) of
        {exit_array, NextText} ->
            {lesson3_lists:reverse(Array), NextText};
        {comma, RestText} ->
            decode_array(RestText, Array);
        {value, Value, RestText} ->
            decode_array(RestText, [Value | Array]);
        {enter_array, RestText} ->
            {NestedArray, NextText} = decode_array(RestText),
            decode_array(NextText, [NestedArray | Array]);
        {enter_object, RestText} ->
            {NestedObject, NextText} = decode_object(RestText),
            decode_array(NextText, [NestedObject | Array])
    end.

%% ----------------------------------------------------------------------------
%% get_token
%% ----------------------------------------------------------------------------
get_token(Text) ->
    case Text of
        <<C, RestText/binary>> when ?is_whitespace(C) ->
            get_token(RestText);
        <<"{", RestText/binary>> ->
            {enter_object, RestText};
        <<"}", RestText/binary>> ->
            {exit_object, RestText};
        <<"[", RestText/binary>> ->
            {enter_array, RestText};
        <<"]", RestText/binary>> ->
            {exit_array, RestText};
        <<":", RestText/binary>> ->
            {colon, RestText};
        <<",", RestText/binary>> ->
            {comma, RestText};
        <<"true", RestText/binary>> ->
            {value, true, RestText};
        <<"false", RestText/binary>> ->
            {value, false, RestText};
        <<"null", RestText/binary>> ->
            {value, null, RestText};
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
            {value, Chars, RestText};
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

            {value, Num, Text}
    end.
