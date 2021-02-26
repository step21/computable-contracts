%:- use_module(library(julian)).
%:- use_module(library(clpfd)).
%:- use_module(library(date_time)).
person(arnold). %arbiter
person(lorna). %licensor
person(lisa). %licenscee
person(sunny). % sublicensee
asset(work). % add asset

% This gets current date D
current_date(D) :-
    get_time(X), stamp_date_time(X, Y, local), date_time_value('date', Y, D).
current_time(Y) :-
    get_time(X), stamp_date_time(X, Y, local).

made_offer(lorna, lisa).
accepts_offer(lisa, lorna).
paid_fee(lisa, lorna, fee).
approves_comments(lorna, lisa).
% (optional) this sets commission
commissions(lorna, lisa).
%comission_fee(lorna, lisa).
startdate(date(2021, 2, 25)).
enddate(date(2021, 3, 25)).

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
    startdate(SD),
    enddate(ED),
    current_date(D).

licenses(lorna, lisa, asset, 1).
%maybe this should set time...

may_sublicense(Y) :-
    licenses(_, Y, _, _).
    
may_publish(Y) :-
	licenses(X, Y, _, _),
	approves_comments(X, Y).

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
license_term(date(2021, 2, 25), date(2021, 3, 25), R).
% Art 2

must_publish(Y) :- % licensee must publish if ...
	licenses(X, Y, _, _), % ... there is a license between X and Y
	approves_comments(X,Y), % ... X approves of the comments Y made
	commissions(X,Y). % ... and X commissioned Y to comment.

pay_commission_fee(X, Y) :- % pay commission fee
    must_publish(_).

%Art 3 % deontic logic
forbidden_publish(Y) :- %forbidden to publish if not approved
	not(approves_comments(_, Y)).

forbidden_publish(Y) :- % forbidden to publish if not licensed ( could be combined with above)
    not(licenses(_, Y, _, _)).

forbidden_publish(Y, S, E) :- % forbidden to publish if not licensed ( could be combined with above)
    current_date(D), from_date(D, _, CM, _),
    %startdate(S),
    from_date(S, _, SM, _),
    %enddate(E),
    from_date(E, _, EM, _),
    %R is ((S < D) < E). % for not having to import a date comparison library, this simple version is used here
    % where it is assumed only the month changes
    !, SM > CM; CM > EM. % or put in seperate valid_license_term

must_remove_comments(Y, T) :- % could in theory also evaluate conditions?
    requested_removal(_, Y, T, D, H).

requested_removal(_, _, T, D, H) :- % check who requests? % requested at time T, with day D and hours H
    current_time(T), from_datetime(T, _, _, D, H, _, _).
	% in complexer version, add asserta here

breach(Y):- % this is not working yet because not sure how to do date arithmetic
    current_time(CT),
    must_remove_comments(Y, TS, DS, HS), % timeset, day set, hour set
    from_datetime(CT, _, _, CD, CH, _, _),
    !, CH > HS+24; CD > DS.	% technically this is not entirely accurate, but for brevity and not depending on libraries it is kept this way for now.

% Art 4
breach(SL) :- % breach of L means breach of SL
    breach(_, _). 
terminates(_, Y) :- % this currently treats var names for L and SL differently but does not make sense and should be reduced
    breach(Y, _).
terminates(_, Y) :- 
    breach(Y, _). 
pay_breach_fee(L, _) :- % in case of breach, pay breach fee to licensor
    breach(L, _).

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


