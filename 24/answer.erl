-module(answer).
-export([main/0]).

matches(N, {N,_}) -> true;
matches(N, {_,N}) -> true;
matches(_, _) -> false.

other(N, {N, X}) -> X;
other(N, {X, N}) -> X.

chains(Target, Chain, Rest) ->
    Candidates = lists:filter(fun (C) -> matches(Target, C) end, Rest),
    [Chain | lists:flatmap(fun (Z) -> chains(other(Target, Z), [flip(Target, Z)|Chain], lists:filter(fun (ZZ) -> ZZ /= Z end, Rest)) end, Candidates) ].

flip(A, {A,B}) -> {A, B};
flip(A, {B,A}) -> {A, B}.

answer() ->
    % Input = [{0,2},{2,2},{2,3},{3,4},{3,5},{0,1},{10,1},{9,10}],
    Input = [
        {48,5},
        {25,10},
        {35,49},
        {34,41},
        {35,35},
        {47,35},
        {34,46},
        {47,23},
        {28,8},
        {27,21},
        {40,11},
        {22,50},
        {48,42},
        {38,17},
        {50,33},
        {13,13},
        {22,33},
        {17,29},
        {50,0},
        {20,47},
        {28,0},
        {42,4},
        {46,22},
        {19,35},
        {17,22},
        {33,37},
        {47,7},
        {35,20},
        {8,36},
        {24,34},
        {6,7},
        {7,43},
        {45,37},
        {21,31},
        {37,26},
        {16,5},
        {11,14},
        {7,23},
        {2,23},
        {3,25},
        {20,20},
        {18,20},
        {19,34},
        {25,46},
        {41,24},
        {0,33},
        {3,7},
        {49,38},
        {47,22},
        {44,15},
        {24,21},
        {10,35},
        {6,21},
        {14,50}
    ],
    Res = chains(0, [], Input),
    lists:map(fun (Chain) -> { lists:foldl(fun ({A,B}, N) -> N+A+B end, 0, Chain), Chain } end, Res).

main() ->
    Ans = answer(),

    % Answer1 
    {Answer1, _} = lists:max(Ans),
    io:write(Answer1), io:nl(),

    % Answer 2
    AnsLengths = lists:map(fun ({N,C}) -> {length(C), N} end, Ans),
    {_, Answer2} = lists:max(AnsLengths),
    io:write(Answer2), io:nl().
