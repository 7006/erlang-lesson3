-module(lesson3_task4).

-export([decode/2]).

-define(is_whitespace(C), (C =:= $\s orelse C =:= $\t orelse C =:= $\n orelse C =:= $\r)).

-define(is_digit(C), (C >= $0 andalso C =< $9)).

%% Написати парсер JSON
%% має вміти працювати з map
%% має вміти працювати з proplists
decode(Text, Format) when Format =:= map; Format =:= proplists ->
    {Result, LastText} =
        case get_token(Text) of
            {value, Value, RestText} ->
                {Value, RestText};
            {enter_object, RestText} ->
                decode_object(RestText, Format);
            {enter_array, RestText} ->
                decode_array(RestText, Format)
        end,
    {end_of_text} = get_token(LastText),
    Result.

%% ----------------------------------------------------------------------------
%% decode_object
%% ----------------------------------------------------------------------------
decode_object(Text, Format) ->
    Object =
        case Format of
            map ->
                #{};
            proplists ->
                []
        end,
    decode_object(Text, Object, no_key, no_value, Format).

decode_object(Text, Object, Key, Value, Format) ->
    case get_token(Text) of
        {value, K, RestText} when Key =:= no_key, Value =:= no_value ->
            decode_object(RestText, Object, K, no_value, Format);
        {colon, RestText} when Key =/= no_key, Value =:= no_value ->
            decode_object(RestText, Object, Key, no_value, Format);
        {value, Val, RestText} when Key =/= no_key, Value =:= no_value ->
            decode_object(RestText, Object, Key, Val, Format);
        {enter_array, RestText} when Key =/= no_key, Value =:= no_value ->
            {Array, NextText} = decode_array(RestText, Format),
            decode_object(NextText, Object, Key, Array, Format);
        {enter_object, RestText} when Key =/= no_key, Value =:= no_value ->
            {NestedObject, NextText} = decode_object(RestText, Format),
            decode_object(NextText, Object, Key, NestedObject, Format);
        {comma, RestText} when Key =/= no_key, Value =/= no_value ->
            NextObject =
                case Format of
                    map ->
                        Object#{Key => Value};
                    proplists ->
                        [{Key, Value} | Object]
                end,
            decode_object(RestText, NextObject, no_key, no_value, Format);
        {exit_object, RestText} when Key =:= no_key, Value =:= no_value ->
            {Object, RestText};
        {exit_object, RestText} when Key =/= no_key, Value =/= no_value ->
            NextObject =
                case Format of
                    map ->
                        Object#{Key => Value};
                    proplists ->
                        reverse([{Key, Value} | Object])
                end,
            {NextObject, RestText}
    end.

%% ----------------------------------------------------------------------------
%% decode_array
%% ----------------------------------------------------------------------------
decode_array(Text, Format) ->
    decode_array(Text, [], no_value, Format).

decode_array(Text, Array, Value, Format) ->
    case get_token(Text) of
        {value, Val, RestText} when Value =:= no_value ->
            decode_array(RestText, Array, Val, Format);
        {enter_array, RestText} when Value =:= no_value ->
            {NestedArray, NextText} = decode_array(RestText, Format),
            decode_array(NextText, Array, NestedArray, Format);
        {enter_object, RestText} when Value =:= no_value ->
            {NestedObject, NextText} = decode_object(RestText, Format),
            decode_array(NextText, Array, NestedObject, Format);
        {comma, RestText} when Value =/= no_value ->
            decode_array(RestText, [Value | Array], no_value, Format);
        {exit_array, NextText} when Value =/= no_value ->
            {reverse([Value | Array]), NextText};
        {exit_array, NextText} when Value =:= no_value ->
            {reverse(Array), NextText}
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
        <<$', RestText/binary>> ->
            get_string_token(RestText);
        <<C, _/binary>> when C =:= $-; ?is_digit(C) ->
            get_number_token(Text);
        <<>> ->
            {end_of_text}
    end.

%% ----------------------------------------------------------------------------
%% get_string_token
%% ----------------------------------------------------------------------------
get_string_token(Text) ->
    get_string_token(Text, <<>>).

get_string_token(Text, Chars) ->
    case Text of
        <<$', RestText/binary>> ->
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

%% ----------------------------------------------------------------------------
%% reverse
%% ----------------------------------------------------------------------------
reverse(L) ->
    reverse(L, []).

reverse([H | T], Acc) ->
    reverse(T, [H | Acc]);
reverse([], Acc) ->
    Acc.
