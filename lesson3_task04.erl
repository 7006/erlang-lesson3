-module(lesson3_task04).
-export([decode/2]).

% Написати парсер jSON (має вміти працювати і з map і з proplists)
decode(JsonText, proplists) ->
    ok;
decode(JsonText, map) ->
    ok.
