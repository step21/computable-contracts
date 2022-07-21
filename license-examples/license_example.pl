% Preamble
person(lorna). %licensor
person(lisa). %licenscee
person(sunny). % sublicensee
asset(work). % add asset
 
% defines the starting conditions of the license
licensor(lorna).
licensee(lisa).
uses(license).
made_offer(lorna, lisa).
accepts_offer(lisa, lorna).
paid_license_fee(lisa, lorna, fee).
approves_comments(lorna, lisa).
 
% uncomment to define that comments are submitted
% submitted_comments(LI).
commissions(lorna, lisa). % (optional) 
% sets the licensing date
startdate(date(2021, 2, 25)).
enddate(date(2021, 3, 25)).
 
published_comments(lisa).% lisa published comments
% uncomment to set comment date
% comment_date(date(2021, 12, 24))
% submitted_comments(LI)
% submission_date(date(2021, 12, 22))
 
% Article 1 (license fee set to paid in beginning)
call_licenses(LO, LI) :-
    licenses(LO, LI, _, _).  
licenses(X, Y, A, D) :- 
    asset(A),
    person(X),
    licensor(X),
    person(Y),
    licensee(Y),
    made_offer(X, Y),
    accepts_offer(Y, X),
    paid_license_fee(Y, X, _),
    startdate(_),
    enddate(_),
    current_date(D).
 
% if there is a license for licensee, they may sublicense
may_sublicense(Y) :-
    licenses(_, Y, _, _).
 
% may publish if comments are approved
may_publish(Y) :-
    licenses(X, Y, _, _),
    approves_comments(X, Y).
 
% calculates the license term between startdate and enddate
license_term(S, E, R) :- % checks license term from date S to E, with duration R
    startdate(S),
    from_date(S, SY, SM, SD),
    enddate(E),
    from_date(E, EY, EM, ED),
    RY is EY - SY,
    RM is EM - SM,
    RD is ED - SD,
    % R license term in difference between the two dates
    R = date(RY, RM, RD).
 
% an example license term. (kept here because of warnings if same predicates are kept apart))
license_term(date(2021, 2, 25), date(2021, 3, 25), _).
 
% Article 2
% obligation to publish if there is a commission
must_publish(Y) :- % licensee must publish if ...
    licenses(X, Y, _, _), % ... there is a license between X and Y
    approves_comments(X,Y), % ... X approves of the comments Y made
    commissions(X,Y). % ... and X commissioned Y to comment.
 
% licensor must pay commission fee if required to publish
commission_fee(_, Y) :- % pay commission fee
    must_publish(Y).
 
% Art 3
%forbidden to publish if not approved or not licensed
call_forbidden_publish(Y) :- 
    (not(approves_comments(_, Y))) ; (not(licenses(_, Y, _, _))).
call_forbidden_publish(Y) :- 
    startdate(S),
    enddate(E),
    forbidden_publish(Y, S, E).
% forbidden to publish if outside of license term
forbidden_publish(Y, S, E) :- 
    licenses(_, Y),
    current_date(D), from_date(D, CY, CM, _),
    write(CM), nl,
    write(D), nl,
    startdate(S),
    from_date(S, SY, SM, _),
    write(SM), nl,
    enddate(E),
    from_date(E, EY, EM, _),
    write(EM), nl,
	    % this only checks year and month for simplification
	    ((SY > CY; CY > EY) ; ((SY is CY; CY is EY), (SM > CM; CM > EM)) ). 
	 
	% obligations to remove comments if removal was requested.
	must_remove_comments(Y, T, D, H) :-
	    licensor(LO), requested_removal(LO, Y, T, D, H).
	 
	approved_comments(lorna).
	requested_removal(LO, LI, T, D, H) :- % check who requests? % requested at time T, with day D and hours H
	    licensor(LO),
	    licensee(LI),
	    published_comments(LI),
	   approved_comments(LO2),
	    nonvar(LO2),
	    current_time(T), from_datetime(T, _, _, D, H, _, _).
	 
	% Article 4.
	license_date(date(2021, 5, 10)).
	approval_overdue(LI, LO) :-
	    commissions(LO, LI),
	    current_date(D), from_date(D, _CY, _CM, CD),
	    license_date(D2), from_date(D2, _LY, _LM, LD),
	    CD >= LD + 5.
	    
	 
	pay_eval_fee(LO, _AM) :-
	    licenses(LO, LI, _A, D),
	    commissions(LO, LI),
	    published_comments(LI),
	    current_date(D), from_date(D, _CY, _CM, _),
	    comment_date(DP), from_date(DP, _PY, _PM, _),
	    write('Paid evaluation fee.'), nl.
	 
	% Article 5.
	breach(_) :-
	    uses(_),
	    current_date(CD), from_date(CD, CY, CM, _),
	    startdate(SD), from_date(SD, SY, SM, _),
	    enddate(ED), from_date(ED, EY, EM, _),
	    ((SY > CY; CY > EY) ; ((SY is CY; CY is EY), (SM > CM; CM > EM)) ). 
	% comments are not remvoed
	breach(Y) :-
	    current_time(CT),
	    must_remove_comments(Y, _, DS, HS), % timeset, day set, hour set
	    from_datetime(CT, _, _, CD, CH, _, _),
	    (CH > HS+24; CD > DS). % does not keep state so non-functional...
	% failure to publish
	breach(LI) :-
	    commissions(_, LI),
	    not(published_comments(LI)),
	    startdate(SD), from_date(SD, SY, SM, _),
	    enddate(ED), from_date(ED, EY, EM, _),
	    ((SY > _CY; _CY > EY) ; ((SY is _CY; _CY is EY), (SM > _CM; _CM > EM))). 
	% licensor does not approve comments within 5 days
	breach(LO) :-
	    call_licenses(LO, LI),
	    submitted_comments(LI),
	    submission_date(SUD), from_date(SUD, SUY, SUM, SUD),
	    current_date(D), from_date(D, CY, _CM, CD),
	    not(published_comments(LI)),
	    ((CD > SUD + 5) ; (CY > SUY) ; (CY > SUM)).
	        
	% 5 days after comments no eval fee
	breach(LO) :-
	    commissions(LO, LI),
	    not(pay_eval_fee(LO, _)),
	    published_comments(LI),
	    current_date(D), from_date(D, _CY, _CM, CD),
	    comment_date(D2), from_date(D2, _COY, _COM, COD),
	    CD >= COD + 5.
	 
	% Article 6.
	terminates(LO, LI) :-
	    call_licenses(LO, LI),
	    breach(_).
	terminates_sublicenses(_) :-
	    terminates(_, _).
	pay_breach_fee(LI, LO) :- % in case of breach, pay breach fee to licensor
	    (breach(LI) ; breach(LO)),
	    write('Breach fee paid.'), nl.
	 
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
