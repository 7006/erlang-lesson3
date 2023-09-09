-module(lesson3_task4).

-export([decode/2]).

-define(is_whitespace(C), (C =:= $\s orelse C =:= $\t orelse C =:= $\n orelse C =:= $\r)).

-define(is_digit(C), (C >= $0 andalso C =< $9)).

%% Написати парсер JSON
%% має вміти працювати з map
%% має вміти працювати з proplists
decode(Text, proplists) ->
    decode(Text, lesson3_task4_object_handler_proplists);
decode(Text, map) ->
    decode(Text, lesson3_task4_object_handler_map);
decode(Text, ObjectHandler) ->
    case get_token(Text) of
        {value, Value, <<>>} ->
            Value;
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
        {colon, RestText} when Key =/= no_key, Value =:= no_value ->
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
            NextObject = ObjectHandler:put(Key, Value, Object),
            NextObject2 = ObjectHandler:done(NextObject),
            {NextObject2, RestText}
    end.

%% ----------------------------------------------------------------------------
%% decode_array
%% ----------------------------------------------------------------------------
decode_array(Text, ObjectHandler) ->
    decode_array(Text, [], no_value, ObjectHandler).

decode_array(Text, Array, Value, ObjectHandler) ->
    case get_token(Text) of
        {value, Val, RestText} when Value =:= no_value ->
            decode_array(RestText, Array, Val, ObjectHandler);
        {enter_array, RestText} when Value =:= no_value ->
            {NestedArray, NextText} = decode_array(RestText, ObjectHandler),
            decode_array(NextText, Array, NestedArray, ObjectHandler);
        {enter_object, RestText} when Value =:= no_value ->
            {NestedObject, NextText} = decode_object(RestText, ObjectHandler),
            decode_array(NextText, Array, NestedObject, ObjectHandler);
        {comma, RestText} when Value =/= no_value ->
            decode_array(RestText, [Value | Array], no_value, ObjectHandler);
        {exit_array, NextText} when Value =/= no_value ->
            {lesson3_lists:reverse([Value | Array]), NextText};
        {exit_array, NextText} when Value =:= no_value ->
            {lesson3_lists:reverse(Array), NextText}
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
        <<C, _/binary>> when C =:= $-; ?is_digit(C) ->
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
    get_number_token(Text, 1, 0, no_fraction).

get_number_token(Text, Sign, Number, Decimal) ->
    case Text of
        <<$-, RestText/binary>> when Sign =/= -1 ->
            get_number_token(RestText, -1, Number, Decimal);
        <<Int/integer, RestText/binary>> when ?is_digit(Int), Decimal =:= no_fraction ->
            get_number_token(RestText, Sign, 10 * Number + (Int - $0), Decimal);
        <<$., RestText/binary>> when Decimal =:= no_fraction ->
            get_number_token(RestText, Sign, Number, 1);
        <<Int/integer, RestText/binary>> when ?is_digit(Int), Decimal =/= no_fraction ->
            get_number_token(RestText, Sign, 10 * Number + (Int - $0), 10 * Decimal);
        <<RestText/binary>> when Decimal =/= no_fraction ->
            {value, Sign * Number / Decimal, RestText};
        <<RestText/binary>> when Decimal =:= no_fraction ->
            {value, Sign * Number, RestText}
    end.
