-module(lesson3_task04_object_handler).

-callback new() -> term().

-callback put(Key :: binary(), Value :: term(), Object :: term()) -> term().

-callback done(Object :: term()) -> term().
