-module(lesson3_task02_tests).
-import(lesson3_task02, [words/1]).

-include_lib("eunit/include/eunit.hrl").

words_test_() ->
    [
        {
            "it should split ascii text to the words using a space character as a separator",
            ?_assertEqual(
                [<<"Text">>, <<"with">>, <<"four">>, <<"words">>],
                words(<<"Text with four words">>)
            )
        },
        {
            "it should split utf8 text to the words using a space character as a separator",
            ?_assertEqual(
                [<<"Текст"/utf8>>, <<"з"/utf8>>, <<"чотирьох"/utf8>>, <<"слів"/utf8>>],
                words(<<"Текст з чотирьох слів"/utf8>>)
            )
        },
        {
            "it should get a one-element list for one-word ascii text using a space character as a separator",
            ?_assertEqual(
                [<<"Text">>],
                words(<<"Text">>)
            )
        },
        {
            "it should get a one-element list for one-word utf8 text using a space character as a separator",
            ?_assertEqual(
                [<<"Текст"/utf8>>],
                words(<<"Текст"/utf8>>)
            )
        },
        {
            "it should get a one-element list with empty string for an empty string",
            ?_assertEqual(
                [<<"">>],
                words(<<"">>)
            )
        }
    ].
