-module(lesson3_task04_object_handler_proplists).

-behaviour(lesson3_task04_object_handler).

-export([
    new/0,
    put/3,
    done/3
]).

new() ->
    [].

put(Key, Value, Object) ->
    [{Key, Value} | Object].

done(Key, Value, Object) ->
    lesson3_lists:reverse(put(Key, Value, Object)).
