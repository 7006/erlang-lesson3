-module(lesson3_task04_tests).

-include_lib("eunit/include/eunit.hrl").

decode_test_() ->
    [
        t(proplists, "null", null),
        t(proplists, "boolean true", true),
        t(proplists, "boolean false", false),
        t(proplists, "number zero", 0),
        t(proplists, "number integer", 925),
        t(proplists, "number integer negative", -541),
        t(proplists, "number float", 12.58),
        t(proplists, "number float negative", -1.23),
        t(proplists, "number fraction", 0.63),
        t(proplists, "number fraction negative", -0.82),
        t(proplists, "string empty", <<"">>),
        t(proplists, "string lower", <<"foobar">>),
        t(proplists, "string upper", <<"BARBAZ">>),
        t(proplists, "string digits", <<"444">>),
        t(proplists, "string mixed", <<"4aBc9">>),
        t(proplists, "string utf8", <<"південь"/utf8>>),
        t(proplists, "whitespace", <<"skip whitespace characters">>),
        t(proplists, "array empty", []),
        t(proplists, "array booleans", [true, false, true]),
        t(proplists, "array null", [null, null, null]),
        t(proplists, "array numbers", [999, -20, 5.36, -108.99, 0, 0.81, -0.256]),
        t(proplists, "array strings", [<<"abc">>, <<"DEF">>, <<"hIjK">>, <<"">>, <<"1111">>]),
        t(proplists, "array mixed", [
            1, <<"foobar">>, <<"QuuX">>, 0.38, 0, false, true, null, -22, -0.5
        ]),
        t(proplists, "array nested", [<<"foobar">>, [true, false], [null], 88]),
        t(proplists, "array nested empty", [[], [[]], [[[]]], [[[[]]]]]),
        t(proplists, "array_nested_object", [
            [
                {<<"a">>, 1},
                {<<"b">>, 2}
            ],
            [
                {<<"x">>, <<"xxxx">>},
                {<<"y">>, <<"yyy">>}
            ]
        ]),
        t(proplists, "object empty", []),
        t(proplists, "object pair single", [
            {<<"enabled">>, true}
        ]),
        t(proplists, "object pairs two", [
            {<<"enabled">>, false},
            {<<"is_new">>, true}
        ]),
        t(proplists, "object pairs mixed", [
            {<<"available">>, true},
            {<<"model">>, <<"T-1000">>},
            {<<"parts">>, null},
            {<<"release_year">>, 1994},
            {<<"price">>, 10.27},
            {<<"rating">>, 0.8}
        ]),
        t(proplists, "object pairs array", [
            {<<"task_id">>, 4758},
            {<<"subtask_ids">>, [1084, 1102, 1103]},
            {<<"affected_releases">>, [<<"BGT/12">>, <<"LAG/2">>]}
        ]),
        t(proplists, "object pairs nested object", [
            {<<"a">>, 1},
            {<<"b">>, [
                {<<"aa">>, true},
                {<<"bb">>, [
                    {<<"aaa">>, 4.23},
                    {<<"bbb">>, [
                        {<<"aaaa">>, <<"cccc">>},
                        {<<"bbbb">>, [
                            {<<"aaaaa">>, []},
                            {<<"bbbbb">>, []}
                        ]}
                    ]}
                ]}
            ]}
        ]),
        t(proplists, "squad", [
            {<<"squadName">>, <<"Super hero squad">>},
            {<<"homeTown">>, <<"Metro City">>},
            {<<"formed">>, 2016},
            {<<"secretBase">>, <<"Super tower">>},
            {<<"active">>, true},
            {<<"members">>, [
                [
                    {<<"name">>, <<"Molecule Man">>},
                    {<<"age">>, 29},
                    {<<"secretIdentity">>, <<"Dan Jukes">>},
                    {<<"powers">>, [
                        <<"Radiation resistance">>,
                        <<"Turning tiny">>,
                        <<"Radiation blast">>
                    ]}
                ],
                [
                    {<<"name">>, <<"Madame Uppercut">>},
                    {<<"age">>, 39},
                    {<<"secretIdentity">>, <<"Jane Wilson">>},
                    {<<"powers">>, [
                        <<"Million tonne punch">>,
                        <<"Damage resistance">>,
                        <<"Superhuman reflexes">>
                    ]}
                ],
                [
                    {<<"name">>, <<"Eternal Flame">>},
                    {<<"age">>, 1000000},
                    {<<"secretIdentity">>, <<"Unknown">>},
                    {<<"powers">>, [
                        <<"Immortality">>,
                        <<"Heat Immunity">>,
                        <<"Inferno">>,
                        <<"Teleportation">>,
                        <<"Interdimensional travel">>
                    ]}
                ]
            ]}
        ])
    ].

t(ObjectHandler, Comment, Expected) ->
    {
        Comment,
        ?_assertEqual(
            Expected,
            lesson3_task04:decode(read_json_document(Comment), ObjectHandler)
        )
    }.

read_json_document(Comment) ->
    Basename = string:join(string:replace(Comment, " ", "_", all), ""),
    Filename = string:join(["json_documents", "/", Basename, ".", "json"], ""),
    {ok, Json} = file:read_file(Filename),
    Json.
