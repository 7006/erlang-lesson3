-module(lesson3_task04_object_handler_map).

-behaviour(lesson3_task04_object_handler).

-export([
    new/0,
    put/3,
    done/3
]).

new() ->
    maps:new().

put(Key, Value, Object) ->
    maps:put(Key, Value, Object).

done(Key, Value, Object) ->
    Object.
