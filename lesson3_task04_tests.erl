-module(lesson3_task04_tests).
-import(lesson3_task04, [decode/1]).

-include_lib("eunit/include/eunit.hrl").

decode_test_() ->
    [
        {"it should decode atoms", [
            {"null", ?_assertEqual(null, decode(<<"null">>))},
            {"true", ?_assertEqual(true, decode(<<"true">>))},
            {"false", ?_assertEqual(false, decode(<<"false">>))}
        ]},
        {"it should decode number", [
            {"zero", ?_assertEqual(0, decode(<<"0">>))},
            {"integer", ?_assertEqual(925, decode(<<"925">>))},
            {"negative integer", ?_assertEqual(-541, decode(<<"-541">>))},
            {"float", ?_assertEqual(12.58, decode(<<"12.58">>))},
            {"negative float", ?_assertEqual(-1.23, decode(<<"-1.23">>))},
            {"fraction", ?_assertEqual(0.63, decode(<<"0.63">>))},
            {"negative fraction", ?_assertEqual(-0.82, decode(<<"-0.82">>))}
        ]},
        {"it should decode string", [
            {"empty", ?_assertEqual(<<"">>, decode(<<"\"\"">>))},
            {"lower", ?_assertEqual(<<"foobar">>, decode(<<"\"foobar\"">>))},
            {"upper", ?_assertEqual(<<"BARBAZ">>, decode(<<"\"BARBAZ\"">>))},
            {"digits", ?_assertEqual(<<"444">>, decode(<<"\"444\"">>))},
            {"mixed", ?_assertEqual(<<"4aBc9">>, decode(<<"\"4aBc9\"">>))},
            {"utf8", ?_assertEqual(<<"південь"/utf8>>, decode(<<$", "південь"/utf8, $">>))}
        ]}
    ].
