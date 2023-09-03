-module(lesson3_task02_tests).

-include_lib("eunit/include/eunit.hrl").

words_test_() ->
    [
        {
            "it should split ascii text to the words using a space character as a separator",
            ?_assertEqual(
                [<<"Text">>, <<"with">>, <<"four">>, <<"words">>],
                lesson3_task02:words(<<"Text with four words">>)
            )
        },
        {
            "it should split utf8 text to the words using a space character as a separator",
            ?_assertEqual(
                [<<"Текст"/utf8>>, <<"з"/utf8>>, <<"чотирьох"/utf8>>, <<"слів"/utf8>>],
                lesson3_task02:words(<<"Текст з чотирьох слів"/utf8>>)
            )
        },
        {
            "it should get a one-element list for one-word ascii text using a space character as a separator",
            ?_assertEqual(
                [<<"Text">>],
                lesson3_task02:words(<<"Text">>)
            )
        },
        {
            "it should get a one-element list for one-word utf8 text using a space character as a separator",
            ?_assertEqual(
                [<<"Текст"/utf8>>],
                lesson3_task02:words(<<"Текст"/utf8>>)
            )
        },
        {
            "it should get a one-element list with empty string for an empty string",
            ?_assertEqual(
                [<<"">>],
                lesson3_task02:words(<<"">>)
            )
        },
        {
            "it should get a one-element list with a 5-character blank string for a 5-character blank string",
            ?_assertEqual(
                [<<"     ">>],
                lesson3_task02:words(<<"     ">>)
            )
        }
    ].
