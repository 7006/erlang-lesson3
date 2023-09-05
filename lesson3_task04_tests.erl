-module(lesson3_task04_tests).

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
        t("string utf8", <<"південь"/utf8>>),
        t("whitespace", <<"skip whitespace characters">>),
        t("array empty", []),
        t("array booleans", [true, false, true]),
        t("array null", [null, null, null]),
        t("array numbers", [999, -20, 5.36, -108.99, 0, 0.81, -0.256]),
        t("array strings", [<<"abc">>, <<"DEF">>, <<"hIjK">>, <<"">>, <<"1111">>]),
        t("array mixed", [1, <<"foobar">>, <<"QuuX">>, 0.38, 0, false, true, null, -22, -0.5]),
        t("array nested", [<<"foobar">>, [true, false], [null], 88]),
        t("array nested empty", [[], [[]], [[[]]], [[[[]]]]]),
        t("array_nested_object", [
            [
                {<<"a">>, 1},
                {<<"b">>, 2}
            ],
            [
                {<<"x">>, <<"xxxx">>},
                {<<"y">>, <<"yyy">>}
            ]
        ]),
        t("object empty", []),
        t("object pair single", [
            {<<"enabled">>, true}
        ]),
        t("object pairs two", [
            {<<"enabled">>, false},
            {<<"is_new">>, true}
        ]),
        t("object pairs mixed", [
            {<<"available">>, true},
            {<<"model">>, <<"T-1000">>},
            {<<"parts">>, null},
            {<<"release_year">>, 1994},
            {<<"price">>, 10.27},
            {<<"rating">>, 0.8}
        ]),
        t("object pairs array", [
            {<<"task_id">>, 4758},
            {<<"subtask_ids">>, [1084, 1102, 1103]},
            {<<"affected_releases">>, [<<"BGT/12">>, <<"LAG/2">>]}
        ]),
        t("object pairs nested object", [
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
        t("squad", [
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

t(Comment, Expected) ->
    Text = read_json_document(Comment),
    Test = ?_assertEqual(Expected, lesson3_task04:decode(Text, proplists)),
    {Comment, Test}.

read_json_document(Comment) ->
    Basename = string:join(string:replace(Comment, " ", "_", all), ""),
    Filename = string:join(["json_documents", "/", Basename, ".", "json"], ""),
    {ok, Json} = file:read_file(Filename),
    Json.
