person(arbiter).
person(licensor).
person(licensee).
person(sublicensee).
commissioned(Licensor).
publish(time, 24).
licenses(Licensor, Licensee) :-
    exists(licensor).
	exists(licensee).
	paid_fee(Licensor, Licensee).
	made_offer(Licensor, Licensee).
allow_sublicense(Licensor, Sublicensee) :-
    licenses(Licensor, Licensee).
may_publish(Licensee) :-
    licenses(Licensor, Licensee).
	approves_comments(Licensor).
is_commissioned(Licensee) :-
    commissioned(Licensor). 
must_publish(Licensee) :-
    is_commissioned(Licensee).
not(publish(Licensee)):-
    not(may_publish).
	not(approves_comments(Licensor)).
removed_comments(Licensee) :-
    Removal_time > 24.
removed_comments(Licensee) :-
   	Removal_time < 24, not(must_remove(Licensee, Published)).
license_canceled(Licensee) :-
    breaches(Licensee).
pay_fee(Licensee, Licensor) :-
    breaches(Licensee).
