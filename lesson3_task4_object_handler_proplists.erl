-module(lesson3_task4_object_handler_proplists).

-behaviour(lesson3_task4_object_handler).

-export([
    new/0,
    put/3,
    done/1
]).

new() ->
    [].

put(Key, Value, Object) ->
    [{Key, Value} | Object].

done(Object) ->
    lesson3_lists:reverse(Object).
