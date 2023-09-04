-module(lesson3_task02_tests).

-include_lib("eunit/include/eunit.hrl").

words_test_() ->
    [
        {
            "it should get words from ascii text separated by whitespace",
            ?_assertEqual(
                [<<"Text">>, <<"with">>, <<"four">>, <<"words">>],
                lesson3_task02:words(<<"Text with four words">>)
            )
        },
        {
            "it should get words from ascii text separated by mixed count of whitespaces",
            ?_assertEqual(
                [<<"Text">>, <<"with">>, <<"four">>, <<"words">>],
                lesson3_task02:words(<<"Text with  four    words">>)
            )
        },
        {
            "it should get words from ascii text separated by whitespace with a whitespace prefix",
            ?_assertEqual(
                [<<"Text">>, <<"with">>, <<"four">>, <<"words">>],
                lesson3_task02:words(<<"    Text with four words">>)
            )
        },
        {
            "it should get words from ascii text separated by whitespace with a whitespace suffix",
            ?_assertEqual(
                [<<"Text">>, <<"with">>, <<"four">>, <<"words">>],
                lesson3_task02:words(<<"Text with four words    ">>)
            )
        },
        {
            "it should get 1 word from one-word ascii text",
            ?_assertEqual(
                [<<"Text">>],
                lesson3_task02:words(<<"Text">>)
            )
        },
        {
            "it should get 1 word from one-word ascii text with a whitespace prefix",
            ?_assertEqual(
                [<<"Text">>],
                lesson3_task02:words(<<"     Text">>)
            )
        },
        {
            "it should get 1 word from one-word ascii text with a whitespace suffix",
            ?_assertEqual(
                [<<"Text">>],
                lesson3_task02:words(<<"Text     ">>)
            )
        },
        {
            "it should get words from utf8 text separated by whitespace",
            ?_assertEqual(
                [<<"Текст"/utf8>>, <<"з"/utf8>>, <<"чотирьох"/utf8>>, <<"слів"/utf8>>],
                lesson3_task02:words(<<"Текст з чотирьох слів"/utf8>>)
            )
        },
        {
            "it should get words from utf8 text separated by mixed count of whitespaces",
            ?_assertEqual(
                [<<"Текст"/utf8>>, <<"з"/utf8>>, <<"чотирьох"/utf8>>, <<"слів"/utf8>>],
                lesson3_task02:words(<<"Текст з  чотирьох   слів"/utf8>>)
            )
        },
        {
            "it should get words from utf8 text separated by whitespace with a whitespace prefix",
            ?_assertEqual(
                [<<"Текст"/utf8>>, <<"з"/utf8>>, <<"чотирьох"/utf8>>, <<"слів"/utf8>>],
                lesson3_task02:words(<<"    Текст з чотирьох слів"/utf8>>)
            )
        },
        {
            "it should get words from utf8 text separated by whitespace with a whitespace suffix",
            ?_assertEqual(
                [<<"Текст"/utf8>>, <<"з"/utf8>>, <<"чотирьох"/utf8>>, <<"слів"/utf8>>],
                lesson3_task02:words(<<"Текст з чотирьох слів    "/utf8>>)
            )
        },
        {
            "it should get 1 word from one-word utf8 text",
            ?_assertEqual(
                [<<"Текст"/utf8>>],
                lesson3_task02:words(<<"Текст"/utf8>>)
            )
        },
        {
            "it should get 1 word from one-word utf8 text with a whitespace prefix",
            ?_assertEqual(
                [<<"Текст"/utf8>>],
                lesson3_task02:words(<<"     Текст"/utf8>>)
            )
        },
        {
            "it should get 1 word from one-word utf8 text with a whitespace suffix",
            ?_assertEqual(
                [<<"Текст"/utf8>>],
                lesson3_task02:words(<<"Текст     "/utf8>>)
            )
        },
        {
            "it should get 0 words from empty text",
            ?_assertEqual(
                [],
                lesson3_task02:words(<<>>)
            )
        },
        {
            "it should get 0 words from blank text",
            ?_assertEqual(
                [],
                lesson3_task02:words(<<"    ">>)
            )
        }
    ].
