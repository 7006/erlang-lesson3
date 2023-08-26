-module(lesson3_task02_tests).
-import(lesson3_task02, [words/1]).

-include_lib("eunit/include/eunit.hrl").

words_test_() ->
    [
        {
            "it should split a text to the words using a space character as a separator",
            ?_assertEqual(
                [<<"Text">>, <<"with">>, <<"four">>, <<"words">>],
                words(<<"Text with four words">>)
            )
        }
    ].
