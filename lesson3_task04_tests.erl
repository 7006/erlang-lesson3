-module(lesson3_task04_tests).
-import(lesson3_task04, [decode/1]).

-include_lib("eunit/include/eunit.hrl").

decode_test_() ->
    [
        t("null", null),
        t("boolean true", true),
        t("boolean false", false),
        t("number zero", 0),
        t("number integer", 925),
        t("number integer negative", -541),
        t("number float", 12.58),
        t("number float negative", -1.23),
        t("number fraction", 0.63),
        t("number fraction negative", -0.82),
        t("string empty", <<"">>),
        t("string lower", <<"foobar">>),
        t("string upper", <<"BARBAZ">>),
        t("string digits", <<"444">>),
        t("string mixed", <<"4aBc9">>),
        t("string utf8", <<"південь"/utf8>>)
        % t("array empty", []),
        % t("array booleans", [true, false, true]),
        % t("array null", [null, null, null]),
        % t("array numbers", [999, -20, 5.36, -108.99, 0, 0.81, -0.256]),
        % t("array strings", [<<"abc">>, <<"DEF">>, <<"hIjK">>, <<"">>, <<"1111">>]),
        % t("array mixed", [1, <<"foobar">>, <<"QuuX">>, 0.38, 0]),
        % t("array nested", [<<"foobar">>, [true, false], [null], 88]),
        % t("array nested empty", [[], [[]], [[[]]], [[[[]]]]])
    ].

t(Comment, Expected) ->
    Basename = string:join(
        string:replace(Comment, " ", "_", all),
        ""
    ),

    Filename = string:join(
        ["json_examples", "/", Basename, ".", "json"],
        ""
    ),

    {ok, Json} = file:read_file(Filename),

    Test = ?_assertEqual(Expected, decode(Json)),

    {Comment, Test}.
