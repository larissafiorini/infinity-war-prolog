:- dynamic(loc/2).

nextto(knowhere, asgard).
nextto(asgard, house).
nextto(house, knowhere).
nextto(knowhere, xandar).
nextto(xandar, vormir).

loc(starlord,knowhere).
loc(thanos,knowhere).
loc(thor,asgard).
loc(scarletwitch,wakanda).
loc(spiderman,wakanda).
loc(ironman,wakanda).
loc(reality,knowhere).
loc(space,asgard).

move(Item, Place) :-
	retract( loc(Item, _) ),
	assert( loc(Item,Place) ).


connect(X,Y) :-
        nextto(X,Y).
connect(X,Y) :-
        nextto(Y,X).

done :-
	loc(thanos, house),
	loc(reality, thanos),
	loc(space, thanos),
	loc(time, thanos),
	write("Thanks for getting all the stones. You win! "), nl.

heroes :-
	starlord,
	thor,
	scarletwitch,
	spiderman,
	ironman.

starlord :-
	loc(starlord, knowhere),
	loc(thanos, knowhere),
	move(starlord, wakanda),
	write("The starlord have run into Wakanda."), nl.
starlord.

thor :-
	loc(starlord, wakanda),
	loc(thanos, asgard),
	write("Thor is in his home. He is the god of Asgard. You have lost Thanos."), nl.
thor.

scarletwitch :-
	loc(scarletwitch,wakanda),
	loc(starlord,wakanda),
	loc(time,thanos),
	write("Scarlet witch, Thor, Spider man and Iron man are about to get you..."), nl,
	write("They are almost there..."), n1,
	write("Almost..."), n1,
	write("Star lord loses his mind and you are awake again."), n1,
	write("Congratulations. Doctor strange gives you the time stone."), n1.
scarletwitch.
 
spiderman :-
	loc(spiderman,wakanda),
	loc(thanos, wakanda),
	move(spiderman,xander),
	write("The spider man have run into Xander."), nl.
spiderman.

ironman :-
	loc(ironman,wakanda),
	loc(thanos, wakanda),
	move(ironman,xander),
	write("The iron man have run into Xander."), nl.
ironman. 

goto(X) :-
	loc(thanos, L),
	connect(L, X),
	move(thanos, X),
	write("thanos are in the "), write(X), nl.
goto(_) :-
	write("thanos can't get there from here."), nl.

chase(starlord) :-
	loc(starlord, L),
	loc(thanos, L),
	move(starlord, knowhere),
	write("The starlord are back in knowhere."), nl.
chase(_):-
	write("No starlord here."), nl.

take(X) :-
	loc(thanos, L),
	loc(X, L),
	move(X, thanos),
	write("thanos now have the "), write(X), nl.
take(X) :-
	write("There is no "), write(X), write(" here."), nl.

look :-
	write("thanos are in the "),
	loc(thanos, L), write(L), nl,
	look_connect(L),
	look_here(L),
	look_have(thanos).

look_connect(L) :-
	write("thanos can go to: "), nl,
	connect(L, CONNECT),
	write(" "), write(CONNECT), nl,
	fail.
look_connect(_).

look_have(X) :-
	write("thanos have: "), nl,
	loc(THING, X),
	write(" "), write(THING), nl,
	fail.
look_have(_).

look_here(L) :-
	write("thanos can see: "), nl,
	loc(THING, L),
	THING \= thanos,
	write(" "), write(THING), nl,
	fail.
look_here(_).

report :-
        findall(X:Y, loc(X,Y), L),
        write(L), nl.

do(goto(X)) :- !, goto(X).
do(chase(X)) :- !, chase(X).
do(take(X)) :- !, take(X).
do(look) :- !, look.
do(help) :- !, instructions.
do(quit) :- !.
do(listing) :- !, listing.
do(report) :- !, report.
do(X) :- write("unknown command"), write(X), nl, instructions.

go :- done.
go :-
	write(">> "),
	read(X),
	X \= quit,
	do(X),
	heroes,
	!, go.
go :- write(" Quitter "), nl.

instructions :-
	nl,
	write("Thanos start in Knowhere, with the gauntlet. "), nl,
	write("Thanos have to get the others stones"), nl,
	write("without losing anyone to a heroe."), nl,
	nl,
	write("Enter commands at the prompt as Prolog terms"), nl,
	write("ending in period:"), nl,
	write("  goto(X). - where X is a place to go to."), nl,
	write("  take(X). - where X is a stoone to take."), nl,
	write("  chase(X). - chasing starlord sends them to the knowhere."), nl,
	write("  look. - the state of the game."), nl,
	write("  help. - this information."), nl,
	write("  quit. - exit the game."), nl,
	nl.

game :-
	write(" Welcome to Infinity War "),nl,
	instructions,
	write(" Go get the infinity stones "),nl,
	go.