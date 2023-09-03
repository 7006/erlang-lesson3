-module(lesson3_task01_tests).

-include_lib("eunit/include/eunit.hrl").

first_word_test_() ->
    [
        {
            "it should get a first word for ascii text",
            ?_assertEqual(
                <<"Some">>,
                lesson3_task01:first_word(<<"Some Text">>)
            )
        },
        {
            "it should get a first word for utf8 text",
            ?_assertEqual(
                <<"Якийсь"/utf8>>,
                lesson3_task01:first_word(<<"Якийсь текст"/utf8>>)
            )
        },
        {
            "it should get a first word for ascii text with spaces at the beginning",
            ?_assertEqual(
                <<"    Some">>,
                lesson3_task01:first_word(<<"    Some Text">>)
            )
        },
        {
            "it should get a first word for utf8 text with spaces at the beginning",
            ?_assertEqual(
                <<"    Якийсь"/utf8>>,
                lesson3_task01:first_word(<<"    Якийсь текст"/utf8>>)
            )
        },
        {
            "it should get a first word for a one-word ascii text",
            ?_assertEqual(
                <<"foobar">>,
                lesson3_task01:first_word(<<"foobar">>)
            )
        },
        {
            "it should get a first word for a one-word utf8 text",
            ?_assertEqual(
                <<"гіроскоп"/utf8>>,
                lesson3_task01:first_word(<<"гіроскоп"/utf8>>)
            )
        },
        {
            "it should get an empty string for an empty string",
            ?_assertEqual(
                <<"">>,
                lesson3_task01:first_word(<<"">>)
            )
        }
    ].
