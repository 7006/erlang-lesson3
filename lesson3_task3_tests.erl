-module(lesson3_task3_tests).

-include_lib("eunit/include/eunit.hrl").

split_test_() ->
    [
        {
            "it should split ascii text by delimiter",
            ?_assertEqual(
                [
                    <<"Col1">>,
                    <<"Col2">>,
                    <<"Col3">>,
                    <<"Col4">>,
                    <<"Col5">>
                ],
                lesson3_task3:split(
                    <<"Col1-:-Col2-:-Col3-:-Col4-:-Col5">>,
                    "-:-"
                )
            )
        },
        {
            "it should split utf8 text by delimiter",
            ?_assertEqual(
                [
                    <<"Стовпчик1"/utf8>>,
                    <<"Стовпчик2"/utf8>>,
                    <<"Стовпчик3"/utf8>>,
                    <<"Стовпчик4"/utf8>>,
                    <<"Стовпчик5"/utf8>>
                ],
                lesson3_task3:split(
                    <<"Стовпчик1-:-Стовпчик2-:-Стовпчик3-:-Стовпчик4-:-Стовпчик5"/utf8>>,
                    "-:-"
                )
            )
        },
        {
            %% https://www.erlang.org/doc/man/string#split-3
            "it should split the text just like the string:split/3 does",
            [
                t(
                    "text contains delimiter and delimiter is 1 character long",
                    #{text => <<"aBaBa">>, delimiter => "B"}
                ),
                t(
                    "text contains delimiter and delimiter is 2 character long",
                    #{text => <<"aBcaBca">>, delimiter => "Bc"}
                ),
                t(
                    "text does not contain delimiter at all and delimiter is 1 character long",
                    #{text => <<"aaa">>, delimiter => "b"}
                ),
                t(
                    "text does not contain delimiter at all and delimiter is 2 character long",
                    #{text => <<"aaa">>, delimiter => "bc"}
                ),
                t(
                    "text consists only from delimiters and delimiter is 1 character long",
                    #{text => <<"aaa">>, delimiter => "a"}
                ),
                t(
                    "text consists only from delimiters and delimiter is 2 character long",
                    #{text => <<"aBaBaB">>, delimiter => "aBaBaB"}
                ),
                t(
                    "text consists only from delimiters and delimiter is 3 character long",
                    #{text => <<"aBcaBcaBc">>, delimiter => "aBcaBcaBc"}
                ),
                t(
                    "text is empty and delimiter is empty",
                    #{text => <<>>, delimiter => ""}
                ),
                t(
                    "text and delimiter are equal and both is 1 character long",
                    #{text => <<"a">>, delimiter => "a"}
                ),
                t(
                    "text and delimiter are equal and both is 2 character long",
                    #{text => <<"aa">>, delimiter => "aa"}
                ),
                t(
                    "text and delimiter are equal and both is 1 character whitespace",
                    #{text => <<" ">>, delimiter => " "}
                ),
                t(
                    "text and delimiter are equal and both is 2 character whitespace",
                    #{text => <<"  ">>, delimiter => "  "}
                ),
                t(
                    "text is not empty and delimiter is 1 character whitespace",
                    #{text => <<"abc">>, delimiter => " "}
                ),
                t(
                    "text is not empty and delimiter is 2 character whitespace",
                    #{text => <<"abc">>, delimiter => "  "}
                ),
                t(
                    "utf8 text contains delimiter and delimiter is 1 character long",
                    #{text => <<"їжаКxїжаКxїжаК"/utf8>>, delimiter => "x"}
                ),
                t(
                    "utf8 text contains delimiter and delimiter is 2 character long",
                    #{text => <<"їжаКxYїжаКxYїжаК"/utf8>>, delimiter => "xY"}
                ),
                t(
                    "utf8 text does not contain delimiter at all and delimiter is 1 character long",
                    #{text => <<"їжак"/utf8>>, delimiter => "x"}
                ),
                t(
                    "utf8 text does not contain delimiter at all and delimiter is 2 character long",
                    #{text => <<"їжак"/utf8>>, delimiter => "xY"}
                ),
                t(
                    "utf8 text is not empty and delimiter is 1 character whitespace",
                    #{text => <<"їжак"/utf8>>, delimiter => " "}
                ),
                t(
                    "utf8 text is not empty and delimiter is 2 character whitespace",
                    #{text => <<"їжак"/utf8>>, delimiter => "  "}
                )
            ]
        }
    ].

t(Comment, #{text := Text, delimiter := Delimiter}) ->
    {
        Comment,
        ?_assertEqual(
            string:split(Text, Delimiter, all),
            lesson3_task3:split(Text, Delimiter)
        )
    }.
