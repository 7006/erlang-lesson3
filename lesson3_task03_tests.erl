-module(lesson3_task03_tests).
-import(lesson3_task03, [split/2]).

-include_lib("eunit/include/eunit.hrl").

split_test_() ->
    [
        {
            "it should split a text to the words using a separator",
            ?_assertEqual(
                [<<"Col1">>, <<"Col2">>, <<"Col3">>, <<"Col4">>, <<"Col5">>],
                split(<<"Col1-:-Col2-:-Col3-:-Col4-:-Col5">>, "-:-")
            )
        }
    ].
