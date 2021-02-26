person(arnold). %arbiter
person(lorna). %licensor
person(lisa). %licenscee
person(sunny). % sublicensee
asset(work). % add asset

% defines the starting conditions of the license
made_offer(lorna, lisa).
accepts_offer(lisa, lorna).
paid_license_fee(lisa, lorna, fee).
approves_comments(lorna, lisa).
% this defines whether there was a commission
commissions(lorna, lisa). % (optional) 
startdate(date(2021, 2, 25)).
enddate(date(2021, 3, 25)).

% defines a general licensor / licensee / license / relationship though it is not called atm
licensor(X) :-
    licenses(X, _, _, _).

licensee(Y) :-
    licenses(_, Y, _, _).

% would be necessary for making it more functional, but does it make sense to integrate without?
arbiter(A) :-
    assigned_as_arbiter(A, _). % assigned arbiter to license

% Art 1
% licensor, licensee, asset, time of license conclusion
licenses(X, Y, A, D) :- 
    asset(A),
    person(X),
    licensor(X),
    person(Y),
    licensee(Y),
    person(AR),
    arbiter(AR),
    % optional - sublicensee
    made_offer(X, Y),
    accepts_offer(Y, X),
    paid_license_fee(Y, X, _),
    startdate(_),
    enddate(_),
    current_date(D).

% This 'creates' a new license
licenses(lorna, lisa, asset, _).

% if there is a license for licensee, they may sublicense
may_sublicense(Y) :-
    licenses(_, Y, _, _).

% may publish if comments are approved
may_publish(Y) :-
    licenses(X, Y, _, _),
    approves_comments(X, Y).

% calculates the license term between startdate and enddate
license_term(S, E, R) :- % checks license term from date S to E, with duration R
    %startdate(S),
    from_date(S, SY, SM, SD),
    %enddate(E),
    from_date(E, EY, EM, ED),
    RY is EY - SY,
    RM is EM - SM,
    RD is ED - SD,
    % R license term in difference between the two dates
    R = date(RY, RM, RD).

% an example license term. (kept here because of warnings if same predicates are kept apart))
license_term(date(2021, 2, 25), date(2021, 3, 25), _).

% Art 2
% obligation to publish if there is a commission
must_publish(Y) :- % licensee must publish if ...
    licenses(X, Y, _, _), % ... there is a license between X and Y
    approves_comments(X,Y), % ... X approves of the comments Y made
    commissions(X,Y). % ... and X commissioned Y to comment.

% licensor must pay commission fee if required to publish
commission_fee(_, Y) :- % pay commission fee
    must_publish(Y).

% Art 3
%forbidden to publish if not approved
forbidden_publish(Y) :- 
    not(approves_comments(_, Y)).

% forbidden to publish if not licensed ( could be combined with above)
forbidden_publish(Y) :- 
    not(licenses(_, Y, _, _)).

% forbidden to publish if outside of license term
forbidden_publish(Y, S, E) :- 
    current_date(D), from_date(D, _, CM, _),
    %startdate(S),
    from_date(S, _, SM, _),
    %enddate(E),
    from_date(E, _, EM, _),
    % it is assumed only the month changes for simplification
    % the ';' (OR) should work but can also be problematic. the cut is used so that it doesn't try to satisfy the first condition again.
    !, SM > CM; CM > EM. 

% obligations to remove comments if removal was requested.
% (in the solidity version, this is checked based on whether certain conditions exist)
must_remove_comments(Y, T, D, H) :-
    requested_removal(_, Y, T, D, H).

% the general version of requested removal. Can also be set as a fact/predicate.
requested_removal(_, _, T, D, H) :- % check who requests? % requested at time T, with day D and hours H
    licensor(Y),
    current_time(T), from_datetime(T, _, _, D, H, _, _).

% there is a breach if there is an obligation to remove comments and 24 hours have passed since notification
% only rudimentary date checking, no saving of state.
breach(Y) :-
    current_time(CT),
    must_remove_comments(Y, _, DS, HS), % timeset, day set, hour set
    from_datetime(CT, _, _, CD, CH, _, _),
    !, CH > HS+24; CD > DS. % technically this is not entirely accurate, but for brevity and not depending on libraries it is kept this way for now.

% Art 4
% breach by L implies breach by SL, terminates in either case, requires obligations of breach fee.
breach(LI) :- % breach of L means breach of SL
    breach(licensee, _).
breach(SL) :-
    breach(licensee, _). 
breach(LI, LO) :-
    terminates(LO, LI).
terminates(_, Y) :- % this currently treats var names for L and SL differently but does not make sense and should be reduced
    breach(Y, _).
terminates(_, Y) :- 
    breach(Y, _). 
pay_breach_fee(L, _) :- % in case of breach, pay breach fee to licensor
    breach(L, _).

%% utility procedures
% This gets current date or time
current_date(D) :-
    get_time(X), stamp_date_time(X, Y, local), date_time_value('date', Y, D).
current_time(Y) :-
    get_time(X), stamp_date_time(X, Y, local).

% gets components of date and datetime respectively
from_date(Date, Year, Month, Day) :-
    arg(1, Date, Year),
    arg(2, Date, Month),
    arg(3, Date, Day).
from_datetime(DateTime, Year, Month, Day, Hours, Mins, Secs) :-
    arg(1, DateTime, Year),
    arg(2, DateTime, Month),
    arg(3, DateTime, Day),
    arg(4, DateTime, Hours),
    arg(5, DateTime, Mins),
    arg(6, DateTime, Secs).

