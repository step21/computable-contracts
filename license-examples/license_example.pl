person(arnold). %arbiter
person(lorna). %licensor
person(lisa). %licenscee
person(sunny). % sublicensee
asset(work). % add asset
current_time(D) :-
    get_time(X), stamp_date_time(X, Y, local), date_time_value('date', Y, D).

% set this if removal was requested. though prob not correct as likely that is called each time ...
% maybe this is not possible in prolog but needs some extensions?
% also - list of licenses ?
requested_removal(lorna, lisa, D) :-
    current_time(D).

% limited(license). % or where to
made_offer(lorna, lisa).
accepts_offer(lisa, lorna).
paid_fee(lisa, lorna, fee).
approves_comments(lorna, lisa).
commissions(lorna, lisa).
%comission_fee(lorna, lisa).

licensor(X) :-
    licenses(X, _).

licensee(Y) :-
    licenses(_, Y).

arbiter(A) :-
    assigned_as_arbiter(A, _). % assigned arbiter to license

licenses(X, Y, A, D) :- % licensor, licensee, asset, time/license term ( or take license term out again)
    asset(A),
    person(X),
    person(Y),
    made_offer(X, Y),
    accepts_offer(Y, X),
    paid_fee(Y, X, _),
    current_time(D).

licenses(lorna, lisa, asset, D).
%maybe this should set time...

may_sublicense(Y) :-
    licenses(_, Y, _, _).

may_publish(Y) :-
    licenses(X, Y, _, _),
    approves_comments(X,Y).

% Art 2
must_publish(Y) :- % licensee must publish if ...
    licenses(X, Y, _, _), % ... there is a license between X and Y
    approves_comments(X,Y), % ... X approves of the comments Y made
    commission_fee(Y, X), %
    commissions(X,Y). % ... and X commissioned Y to comment.

%Art 3 % deontic logic
forbidden_publish(Y) :- %forbidden to publish if not approved
    not(approves_comments(_, Y)).

forbidden_publish(Y) :- % forbidden to publish if not licensed ( could be combined with above)
    not(licenses(_, Y, _, _)).

must_remove_comments(Y, T) :-
    requested_removal(_, Y, T).
    %licenses(_, Y, _, T2). % which time handling makes sense but is not too convuluted?

breach(Y, T):- % this is not working yet because not sure how to do date arithmetic
    must_remove_comments(Y, T).
    %T is T+24. % fix

% Art 4
breach(SL) :- % breach of L means breach of SL
    breach(_, _).

terminates(_, Y) :- % this currently treats var names for L and SL differently but does not make sense and should be reduced
    breach(Y, _).

terminates(_, Y) :-
    breach(Y, _).

breach_fee(L, _) :-
    breach(L, _).

%breach_fee(Y, _) :-
%    breach(Y, _).

