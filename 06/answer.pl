/* [14,0,15,12,11,11,3,5,1,6,8,4,9,1,8,4] */
answer1(L, R) :- cycles([L], 0, R, _).

answer2(L, R) :- cycles([L], 0, _, [A|LL]),
    count(A, LL, R).

count(X, [H|_], N, R) :- X = H, R is N+1.
count(X, [_|T], N, R) :- count(X, T, N+1, R).
count(X, Xs, R) :- count(X, Xs, 0, R).

cycles([L|Seen], N, RN, RL) :-
    cycle(L, L1),
    member(L1, [L|Seen]),
    RN is N+1,
    RL = [L1,L|Seen].
cycles([L|Seen], N, RN, RL) :-
    cycle(L, L1),
    cycles([L1,L|Seen], N+1, RN, RL).

member(X, [H|_]) :- X = H.
member(X, [_|T]) :- member(X, T).

cycle(L, Res) :-
    splitMax(L, L1, [H|L2]),
    reverse(L1, L1R),
    redistribute([0|L1R], L2, H, Res).

splitMax(L, R1, R2) :- max(L, N), splitBy(L, [], N, R1, R2).

splitBy([H|T], Acc, Pivot, R1, R2) :- H = Pivot, reverse(Acc, R1), R2 = [H|T].
splitBy([H|T], Acc, Pivot, R1, R2) :- H \= Pivot, splitBy(T, [H|Acc], Pivot, R1, R2).

/* Redistribute */
/* A is reversed ~ acc representing pre-pivot */
redistribute(A, T, 0, Res) :- reverse(A, AR), append(AR, T, Res).
redistribute(A, [H|T], N, Res) :-
    N > 0, H1 is H+1, N1 is N-1, redistribute([H1|A], T, N1, Res).
redistribute(A, [], N, Res) :-
    N > 0, reverse(A, AR), redistribute([], AR, N, Res).

max([], R, R).
max([H|T], N, R) :- H > N, max(T, H, R).
max([H|T], N, R) :- H =< N, max(T, N, R).
max([H|T], R) :- max(T, H, R).

reverse([], Acc, Res) :- Res = Acc.
reverse([H|T], Acc, Res) :- reverse(T, [H|Acc], Res).
reverse(L,Res) :- reverse(L, [], Res).
