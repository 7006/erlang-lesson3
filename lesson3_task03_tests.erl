-module(lesson3_task03_tests).

-include_lib("eunit/include/eunit.hrl").

split_test_() ->
    [
        {
            "it should split ascii text to the words using a string delimiter",
            ?_assertEqual(
                [
                    <<"Col1">>,
                    <<"Col2">>,
                    <<"Col3">>,
                    <<"Col4">>,
                    <<"Col5">>
                ],
                lesson3_task03:split(<<"Col1-:-Col2-:-Col3-:-Col4-:-Col5">>, "-:-")
            )
        },
        {
            "it should split utf8 text to the words using a string delimiter",
            ?_assertEqual(
                [
                    <<"Стовпчик1"/utf8>>,
                    <<"Стовпчик2"/utf8>>,
                    <<"Стовпчик3"/utf8>>,
                    <<"Стовпчик4"/utf8>>,
                    <<"Стовпчик5"/utf8>>
                ],
                lesson3_task03:split(
                    <<"Стовпчик1-:-Стовпчик2-:-Стовпчик3-:-Стовпчик4-:-Стовпчик5"/utf8>>,
                    "-:-"
                )
            )
        },
        {
            "it should split an empty text to the words using a string delimiter",
            ?_assertEqual(
                [<<"">>],
                lesson3_task03:split(<<"">>, "-:-")
            )
        }
    ].
