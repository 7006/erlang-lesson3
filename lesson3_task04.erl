-module(lesson3_task04).
-export([decode/1]).

-define(is_white_space(C), (C =:= $\s orelse C =:= $\t orelse C =:= $\n)).

-define(is_digit(C), (C =:= $- orelse C >= $0 andalso C =< $9)).

% Написати парсер JSON (має вміти працювати і з map і з proplists)
decode(Bin) ->
    case get_token(Bin) of
        {atom, Val} ->
            binary_to_atom(Val);
        {integer, Val} ->
            binary_to_integer(Val);
        {float, Val} ->
            binary_to_float(Val);
        {string, Val} ->
            Val
    end.

%% ----------------------------------------------------------------------------
%% get_token
%% ----------------------------------------------------------------------------
get_token(Bin) when is_binary(Bin) ->
    case Bin of
        <<C, RestBin/binary>> when ?is_white_space(C) ->
            get_token(RestBin);
        <<"true">> ->
            get_atom_token(Bin);
        <<"false">> ->
            get_atom_token(Bin);
        <<"null">> ->
            get_atom_token(Bin);
        <<$", RestBin/binary>> ->
            get_string_token(RestBin);
        <<C, _/binary>> when ?is_digit(C) ->
            get_number_token(Bin)
    end.

%% ----------------------------------------------------------------------------
%% get_atom_token
%% ----------------------------------------------------------------------------
get_atom_token(Bin) ->
    {atom, Bin}.

%% ----------------------------------------------------------------------------
%% get_string_token
%% ----------------------------------------------------------------------------
get_string_token(Bin) ->
    get_string_token(Bin, <<>>).

get_string_token(Bin, Chars) ->
    case Bin of
        <<$">> ->
            {string, Chars};
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
        <<Digit:1/binary, RestBin/binary>> ->
            get_number_token(RestBin, {Type, <<Number/binary, Digit/binary>>});
        <<>> ->
            {Type, Number}
    end.
