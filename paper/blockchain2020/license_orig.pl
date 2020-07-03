person(arbiter).
person(licensor).
person(licensee).
person(sublicensee).
commissioned(Licensor).
publish(time, 24).

% Art 1 - Add sth about publishing to Art 1?
licenses(Licensor, Licensee) :-
    %grants_license(licensor, asset, licensee):
    exists(licensor).
	exists(licensee).
	paid_fee(Licensor, Licensee).
	made_offer(Licensor, Licensee).

allow_sublicense(Licensor, Sublicensee) :-
    licenses(Licensor, Licensee).
may_publish(Licensee) :-
    licenses(Licensor, Licensee).
	approves_comments(Licensor).
% Art 2 
is_commissioned(Licensee) :-
    commissioned(Licensor). 

must_publish(Licensee) :-
    is_commissioned(Licensee).

%Art 3
not(publish(Licensee)):-
    not(may_publish).
	not(approves_comments(Licensor)).

% rename
removed_comments(Licensee) :-
    Removal_time > 24.
    % not(may_publish(Licensee)).
    
%, not(licenses(Licensor, Licensee)).

removed_comments(Licensee) :-
   	Removal_time < 24, not(must_remove(Licensee, Published)).

% Art 4
% not(licenses(Licensee, Licensor)) :-
license_canceled(Licensee) :-
    breaches(Licensee).

pay_fee(Licensee, Licensor) :-
    breaches(Licensee).
