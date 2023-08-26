-module(lesson3_task01_tests).
-import(lesson3_task01, [first_word/1]).

-include_lib("eunit/include/eunit.hrl").

first_word_test_() ->
    [
        {
            "it should get a first word",
            ?_assertEqual(
                <<"Some">>,
                first_word(<<"Some Text">>)
            )
        }
    ].
