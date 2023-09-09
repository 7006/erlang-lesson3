-module(lesson3_task1_tests).

-include_lib("eunit/include/eunit.hrl").

first_word_test_() ->
    [
        {
            "it should get a first word for ascii text",
            ?_assertEqual(
                <<"Some">>,
                lesson3_task1:first_word(<<"Some Text">>)
            )
        },
        {
            "it should get a first word for ascii text with whitespace prefix",
            ?_assertEqual(
                <<"Some">>,
                lesson3_task1:first_word(<<"    Some Text">>)
            )
        },
        {
            "it should get a first word for a one-word ascii text",
            ?_assertEqual(
                <<"foobar">>,
                lesson3_task1:first_word(<<"foobar">>)
            )
        },
        {
            "it should get a first word for a one-word ascii text with whitespace prefix",
            ?_assertEqual(
                <<"foobar">>,
                lesson3_task1:first_word(<<"          foobar">>)
            )
        },
        {
            "it should get a first word for a one-character ascii text",
            ?_assertEqual(
                <<"a">>,
                lesson3_task1:first_word(<<"a">>)
            )
        },
        {
            "it should get a first word for a one-character ascii text with whitespace prefix",
            ?_assertEqual(
                <<"a">>,
                lesson3_task1:first_word(<<"          a">>)
            )
        },
        {
            "it should get a first word for utf8 text",
            ?_assertEqual(
                <<"Якийсь"/utf8>>,
                lesson3_task1:first_word(<<"Якийсь текст"/utf8>>)
            )
        },
        {
            "it should get a first word for utf8 text with whitespace prefix",
            ?_assertEqual(
                <<"Якийсь"/utf8>>,
                lesson3_task1:first_word(<<"    Якийсь текст"/utf8>>)
            )
        },
        {
            "it should get a first word for a one-word utf8 text",
            ?_assertEqual(
                <<"гіроскоп"/utf8>>,
                lesson3_task1:first_word(<<"гіроскоп"/utf8>>)
            )
        },
        {
            "it should get a first word for a one-word utf8 text with whitespace prefix",
            ?_assertEqual(
                <<"гіроскоп"/utf8>>,
                lesson3_task1:first_word(<<"          гіроскоп"/utf8>>)
            )
        },
        {
            "it should get a first word for a one-character utf8 text",
            ?_assertEqual(
                <<"і"/utf8>>,
                lesson3_task1:first_word(<<"і"/utf8>>)
            )
        },
        {
            "it should get a first word for a one-character utf8 text with whitespace prefix",
            ?_assertEqual(
                <<"і"/utf8>>,
                lesson3_task1:first_word(<<"          і"/utf8>>)
            )
        },
        {
            "it should get none for an empty string",
            ?_assertEqual(
                none,
                lesson3_task1:first_word(<<>>)
            )
        },
        {
            "it should get none for a blank string",
            ?_assertEqual(
                none,
                lesson3_task1:first_word(<<"    ">>)
            )
        }
    ].
