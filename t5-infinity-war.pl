:- dynamic(loc/2).

nextto(knowhere, asgard).
nextto(asgard, home).

loc(power,knowhere).
loc(doctor-strange,knowhere).
loc(thanos,knowhere).
loc(reality,asgard).

move(Item, Place) :-
	retract( loc(Item, _) ),
	assert( loc(Item,Place) ).

connect(X,Y) :-
        nextto(X,Y).
connect(X,Y) :-
        nextto(Y,X).

% finaliza jogo
done :-
	loc(thanos, home),
	loc(power, thanos),
	write("Thanks for getting the power."), nl.

% define pessoas que se pode chase
demons :-
	doctor-strange,
	fox.

doctor-strange :-
	loc(doctor-strange, knowhere),
	loc(thanos, knowhere),
	move(doctor-strange, asgard),
	write("The doctor-strange have run into the asgard."), nl.
doctor-strange.

fox :-
	loc(doctor-strange, asgard),
	loc(thanos, home),
	write("The fox has taken a duck."), nl.
fox.

% move pessoa pra outro lugar. 
goto(X) :-
	loc(thanos, L),
	connect(L, X),
	move(thanos, X),
	write("thanos are in the "), write(X), nl.
goto(_) :-
	write("thanos can't get there from here."), nl.

% comando novo. Attack demon
attack(doctor-strange) :-
	loc(doctor-strange, L),
	loc(thanos, L),
	write("thanos hit the doctor-strange."),
	take(reality).
attack(_):-
	write("No doctor-strange here."), nl.
	

% caça algum demon. Pode caçar se tiver no mesmo lugar.
chase(doctor-strange) :-
	loc(doctor-strange, L),
	loc(thanos, L),
	move(doctor-strange, knowhere),
	write("The doctor-strange are back in their knowhere."), nl.
chase(_):-
	write("No doctor-strange here."), nl.

% função que pega um item. Pode pegar se pessoa tiver no mesmo lugar q o item.
take(X) :-
	loc(thanos, L),
	loc(X, L),
	move(X, thanos),
	write("thanos now have the "), write(X),write(" stone."), nl.
take(X) :-
	write("There is no "), write(X), write(" here."), nl.

% mostra onde pessoa tá, o que tem e onde pode ir
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

% lista L com elementos que atendem a critério. Mostra todos combinações atuais do sistema.
report :-
        findall(X:Y, loc(X,Y), L),
        write(L), nl.

% é chamado pela função "go", executa comando solicitado.
do(goto(X)) :- !, goto(X).
do(attack(X)) :- !, attack(X).
do(chase(X)) :- !, chase(X).
do(take(X)) :- !, take(X).
do(look) :- !, look.
do(help) :- !, instructions.
do(quit) :- !.
do(listing) :- !, listing.
do(report) :- !, report.
do(X) :- write("unknown command"), write(X), nl, instructions.

% controla toda execução do programa
go :- done.
go :-
	write(">> "),
	read(X),
	X \= quit,
	do(X),
	demons,
	!, go.
go :- write(" Quitter "), nl.

instructions :-
	nl,
	write("Thanos start in his home, with the gauntlet. "), nl,
	write("Thanos have to get the others stones. "), nl,
	nl,
	write("Enter commands at the prompt as Prolog terms"), nl,
	write("ending in period:"), nl,
	write("  goto(X). - where X is a place to go to."), nl,
	write("  attack(X). - where X is a demon thanos can attack to try to take their stone."), nl,
	write("  take(X). - where X is a thing to take."), nl,
	write("  chase(X). - chasing doctor-strange sends them to the knowhere."), nl,
	write("  look. - the state of the game."), nl,
	write("  help. - this information."), nl,
	write("  quit. - exit the game."), nl,
	nl.

game :-
	write(" Welcome to Duck World "),nl,
	instructions,
	write(" Go get an power "),nl,
	go.
	
