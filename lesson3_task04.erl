-module(lesson3_task04).

-export([decode/1, decode/2]).

-define(is_whitespace(C), (C =:= $\s orelse C =:= $\t orelse C =:= $\n)).

-define(is_digit(C), (C =:= $- orelse C >= $0 andalso C =< $9)).

%% Написати парсер JSON
%% має вміти працювати з map
%% має вміти працювати з proplists
decode(Text) ->
    decode(Text, proplists).

decode(Text, proplists) ->
    decode(Text, lesson3_task04_object_handler_proplists);
decode(Text, map) ->
    decode(Text, lesson3_task04_object_handler_map);
decode(Text, ObjectHandler) ->
    case get_token(Text) of
        {value, V, <<>>} ->
            V;
        {enter_object, RestText} ->
            {Object, <<>>} = decode_object(RestText, ObjectHandler),
            Object;
        {enter_array, RestText} ->
            {Array, <<>>} = decode_array(RestText, ObjectHandler),
            Array
    end.

%% ----------------------------------------------------------------------------
%% decode_object
%% ----------------------------------------------------------------------------
decode_object(Text, ObjectHandler) ->
    Object = ObjectHandler:new(),
    decode_object(Text, Object, no_key, no_value, ObjectHandler).

decode_object(Text, Object, Key, Value, ObjectHandler) ->
    case get_token(Text) of
        {value, K, RestText} when Key =:= no_key, Value =:= no_value ->
            decode_object(RestText, Object, K, no_value, ObjectHandler);
        {colon, RestText} when Key =/= no_key ->
            decode_object(RestText, Object, Key, no_value, ObjectHandler);
        {value, Val, RestText} when Key =/= no_key, Value =:= no_value ->
            decode_object(RestText, Object, Key, Val, ObjectHandler);
        {enter_array, RestText} when Key =/= no_key, Value =:= no_value ->
            {Array, NextText} = decode_array(RestText, ObjectHandler),
            decode_object(NextText, Object, Key, Array, ObjectHandler);
        {enter_object, RestText} when Key =/= no_key, Value =:= no_value ->
            {NestedObject, NextText} = decode_object(RestText, ObjectHandler),
            decode_object(NextText, Object, Key, NestedObject, ObjectHandler);
        {comma, RestText} when Key =/= no_key, Value =/= no_value ->
            NextObject = ObjectHandler:put(Key, Value, Object),
            decode_object(RestText, NextObject, no_key, no_value, ObjectHandler);
        {exit_object, RestText} when Key =:= no_key, Value =:= no_value ->
            {Object, RestText};
        {exit_object, RestText} when Key =/= no_key, Value =/= no_value ->
            NextObject = ObjectHandler:done(Key, Value, Object),
            {NextObject, RestText}
    end.

%% ----------------------------------------------------------------------------
%% decode_array
%% ----------------------------------------------------------------------------
decode_array(Text, ObjectHandler) ->
    decode_array(Text, [], ObjectHandler).

decode_array(Text, Array, ObjectHandler) ->
    case get_token(Text) of
        {exit_array, NextText} ->
            {lesson3_lists:reverse(Array), NextText};
        {comma, RestText} ->
            decode_array(RestText, Array, ObjectHandler);
        {value, Value, RestText} ->
            decode_array(RestText, [Value | Array], ObjectHandler);
        {enter_array, RestText} ->
            {NestedArray, NextText} = decode_array(RestText, ObjectHandler),
            decode_array(NextText, [NestedArray | Array], ObjectHandler);
        {enter_object, RestText} ->
            {NestedObject, NextText} = decode_object(RestText, ObjectHandler),
            decode_array(NextText, [NestedObject | Array], ObjectHandler)
    end.

%% ----------------------------------------------------------------------------
%% get_token
%% ----------------------------------------------------------------------------
get_token(Text) ->
    case Text of
        <<ObjectHandler, RestText/binary>> when ?is_whitespace(ObjectHandler) ->
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
