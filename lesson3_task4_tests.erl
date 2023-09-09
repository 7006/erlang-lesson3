-module(lesson3_task4_tests).

-include_lib("eunit/include/eunit.hrl").

decode_test_() ->
    [
        {
            "1 quote key-string",
            ?_assertEqual(
                #{<<"key">> => <<"value">>},
                lesson3_task4:decode(<<"{'key': 'value'}">>, map)
            )
        },
        {
            "1 quote key-array",
            ?_assertEqual(
                #{<<"key">> => [<<"el1">>, <<"el2">>]},
                lesson3_task4:decode(<<"{'key': ['el1', 'el2']}">>, map)
            )
        },
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
        ]),
        t(map, "null", null),
        t(map, "boolean true", true),
        t(map, "boolean false", false),
        t(map, "number zero", 0),
        t(map, "number integer", 925),
        t(map, "number integer negative", -541),
        t(map, "number float", 12.58),
        t(map, "number float negative", -1.23),
        t(map, "number fraction", 0.63),
        t(map, "number fraction negative", -0.82),
        t(map, "string empty", <<"">>),
        t(map, "string lower", <<"foobar">>),
        t(map, "string upper", <<"BARBAZ">>),
        t(map, "string digits", <<"444">>),
        t(map, "string mixed", <<"4aBc9">>),
        t(map, "string utf8", <<"південь"/utf8>>),
        t(map, "whitespace", <<"skip whitespace characters">>),
        t(map, "array empty", []),
        t(map, "array booleans", [true, false, true]),
        t(map, "array null", [null, null, null]),
        t(map, "array numbers", [999, -20, 5.36, -108.99, 0, 0.81, -0.256]),
        t(map, "array strings", [<<"abc">>, <<"DEF">>, <<"hIjK">>, <<"">>, <<"1111">>]),
        t(map, "array mixed", [
            1, <<"foobar">>, <<"QuuX">>, 0.38, 0, false, true, null, -22, -0.5
        ]),
        t(map, "array nested", [<<"foobar">>, [true, false], [null], 88]),
        t(map, "array nested empty", [[], [[]], [[[]]], [[[[]]]]]),
        t(map, "array_nested_object", [
            #{
                <<"a">> => 1,
                <<"b">> => 2
            },
            #{
                <<"x">> => <<"xxxx">>,
                <<"y">> => <<"yyy">>
            }
        ]),
        t(map, "object empty", #{}),
        t(map, "object pair single", #{
            <<"enabled">> => true
        }),
        t(map, "object pairs two", #{
            <<"enabled">> => false,
            <<"is_new">> => true
        }),
        t(map, "object pairs mixed", #{
            <<"available">> => true,
            <<"model">> => <<"T-1000">>,
            <<"parts">> => null,
            <<"release_year">> => 1994,
            <<"price">> => 10.27,
            <<"rating">> => 0.8
        }),
        t(map, "object pairs array", #{
            <<"task_id">> => 4758,
            <<"subtask_ids">> => [1084, 1102, 1103],
            <<"affected_releases">> => [<<"BGT/12">>, <<"LAG/2">>]
        }),
        t(map, "object pairs nested object", #{
            <<"a">> => 1,
            <<"b">> => #{
                <<"aa">> => true,
                <<"bb">> => #{
                    <<"aaa">> => 4.23,
                    <<"bbb">> => #{
                        <<"aaaa">> => <<"cccc">>,
                        <<"bbbb">> => #{
                            <<"aaaaa">> => [],
                            <<"bbbbb">> => #{}
                        }
                    }
                }
            }
        }),
        t(map, "squad", #{
            <<"squadName">> => <<"Super hero squad">>,
            <<"homeTown">> => <<"Metro City">>,
            <<"formed">> => 2016,
            <<"secretBase">> => <<"Super tower">>,
            <<"active">> => true,
            <<"members">> => [
                #{
                    <<"name">> => <<"Molecule Man">>,
                    <<"age">> => 29,
                    <<"secretIdentity">> => <<"Dan Jukes">>,
                    <<"powers">> => [
                        <<"Radiation resistance">>,
                        <<"Turning tiny">>,
                        <<"Radiation blast">>
                    ]
                },
                #{
                    <<"name">> => <<"Madame Uppercut">>,
                    <<"age">> => 39,
                    <<"secretIdentity">> => <<"Jane Wilson">>,
                    <<"powers">> => [
                        <<"Million tonne punch">>,
                        <<"Damage resistance">>,
                        <<"Superhuman reflexes">>
                    ]
                },
                #{
                    <<"name">> => <<"Eternal Flame">>,
                    <<"age">> => 1000000,
                    <<"secretIdentity">> => <<"Unknown">>,
                    <<"powers">> => [
                        <<"Immortality">>,
                        <<"Heat Immunity">>,
                        <<"Inferno">>,
                        <<"Teleportation">>,
                        <<"Interdimensional travel">>
                    ]
                }
            ]
        }),
        t_invalid(map, "number double fraction"),
        t_invalid(map, "number double sign"),
        t_invalid(map, "array comma"),
        t_invalid(map, "array close bracket"),
        t_invalid(map, "array open bracket"),
        t_invalid(map, "array open curly bracket"),
        t_invalid(map, "array close curly bracket"),
        t_invalid(map, "object colon"),
        t_invalid(map, "object colon value"),
        t_invalid(map, "object colon key"),
        t_invalid(map, "object colon key array"),
        t_invalid(map, "object colon key object")
    ].

t(ObjectHandler, Description, Expected) ->
    Comment = string:join(["<", atom_to_list(ObjectHandler), "> ", Description], ""),
    JsonDocument = read_json_document(Description, "json_documents"),
    Test = ?_assertEqual(
        Expected,
        lesson3_task4:decode(JsonDocument, ObjectHandler)
    ),
    {Comment, Test}.

t_invalid(ObjectHandler, Description) ->
    Comment = string:join(["<", atom_to_list(ObjectHandler), "> ", Description], ""),
    InvalidJsonDocument = read_json_document(Description, "json_documents/_invalid"),
    Test = ?_assertError(
        _,
        lesson3_task4:decode(InvalidJsonDocument, ObjectHandler)
    ),
    {Comment, Test}.

read_json_document(Description, Dirname) ->
    Basename = string:join(string:replace(Description, " ", "_", all), ""),
    Filename = string:join([Dirname, "/", Basename, ".", "json"], ""),
    {ok, Json} = file:read_file(Filename),
    Json.
