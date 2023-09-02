-module(lesson3_task01_tests).

-import(lesson3_task01, [first_word/1]).

-include_lib("eunit/include/eunit.hrl").

first_word_test_() ->
    [
        {
            "it should get a first word for ascii text",
            ?_assertEqual(
                <<"Some">>,
                first_word(<<"Some Text">>)
            )
        },
        {
            "it should get a first word for utf8 text",
            ?_assertEqual(
                <<"Якийсь">>,
                first_word(<<"Якийсь текст">>)
            )
        },
        {
            "it should get a first word for ascii text with spaces at the beginning",
            ?_assertEqual(
                <<"    Some">>,
                first_word(<<"    Some Text">>)
            )
        },
        {
            "it should get a first word for utf8 text with spaces at the beginning",
            ?_assertEqual(
                <<"    Якийсь">>,
                first_word(<<"    Якийсь текст">>)
            )
        },
        {
            "it should get a empty string for an empty string",
            ?_assertEqual(
                <<"">>,
                first_word(<<"">>)
            )
        }
    ].
