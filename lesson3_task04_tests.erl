-module(lesson3_task04_tests).
-import(lesson3_task04, [decode/1]).

-include_lib("eunit/include/eunit.hrl").

decode_test_() ->
    [
        t("null", null),
        t("boolean_true", true),
        t("boolean_false", false),
        t("number_zero", 0),
        t("number_integer", 925),
        t("number_integer_negative", -541),
        t("number_float", 12.58),
        t("number_float_negative", -1.23),
        t("number_fraction", 0.63),
        t("number_fraction_negative", -0.82),
        t("string_empty", <<"">>),
        t("string_lower", <<"foobar">>),
        t("string_upper", <<"BARBAZ">>),
        t("string_digits", <<"444">>),
        t("string_mixed", <<"4aBc9">>),
        t("string_utf8", <<"південь"/utf8>>),
        t("array_empty", []),
        t("array_booleans", [true, false, true]),
        t("array_null", [null, null, null]),
        t("array_numbers", [999, -20, 5.36, -108.99, 0, 0.81, -0.256]),
        t("array_strings", [<<"abc">>, <<"DEF">>, <<"hIjK">>, <<"">>, <<"1111">>]),
        t("array_mixed", [1, <<"foobar">>, <<"QuuX">>, 0.38, 0]),
        t("array_nested", [<<"foobar">>, [true, false], [null], 88]),
        t("array_nested_empty", [[], [[]], [[[]]], [[[[]]]]])
    ].

t(Name, Expected) ->
    Comment = string:join(
        string:replace(Name, "_", " ", all),
        ""
    ),

    {ok, Json} = file:read_file(
        string:join(
            ["json_examples", "/", Name, ".", "json"],
            ""
        )
    ),

    Test = ?_assertEqual(Expected, decode(Json)),

    {Comment, Test}.
