:- dynamic(loc/2).

nextto(knowhere, asgard).
nextto(asgard, home).
nextto(home, wakanda).
nextto(wakanda, vormir).

loc(doctor-strange,knowhere).
loc(thanos,knowhere).
loc(spider-man,wakanda).
loc(black-widow,vormir).

loc(power,knowhere).
loc(time,asgard).
loc(space,wakanda).

move(Item, Place) :-
	retract( loc(Item, _) ),
	assert( loc(Item,Place) ).

connect(X,Y) :-
        nextto(X,Y).
connect(X,Y) :- 
        nextto(Y,X).

% finaliza jogo quando thanos tiver todas joias e tiver em home
done :-
	loc(thanos, home),
	loc(power, thanos),
	loc(space, thanos),
	loc(time, thanos),
	write("Thanos have all the stones!"), nl.

% define pessoas que se pode chase
heroes :-
	doctor-strange,
	spider-man,
	black-widow.

doctor-strange :-
	loc(doctor-strange, knowhere),
	loc(thanos, knowhere),
	move(doctor-strange, asgard),
	write("The doctor-strange have run into the asgard."), nl.
doctor-strange.

spider-man :-
	loc(spider-man, asgard),
	loc(thanos, home),
	move(spider-man,vormir),
	write("The spider-man have run into vormir."), nl.
spider-man.

black-widow :-
	loc(black-widow, vormir),
	loc(thanos, vormir),
	write("The black widow seems to be calling to S.H.I.E.L.D. Be carefull."), nl.
black-widow.

% move pessoa pra outro lugar. 
goto(X) :-
	loc(thanos, L),
	connect(L, X),
	move(thanos, X),
	write("thanos are in the "), write(X), nl.
goto(_) :-
	write("thanos can't get there from here."), nl.

% comando novo. Attack heroe
attack(black-widow) :-
	loc(black-widow, L),
	loc(thanos, L),
	write("Thanos hit black-widow.... Congratulations! You now have the power stone."), nl,
	move(power,thanos).
attack(doctor-strange) :-
	loc(doctor-strange, L),
	loc(thanos, L),
	write("Thanos hit doctor-strange.... Congratulations! You now have the time stone."), nl,
	move(time,thanos).
attack(spider-man) :-
	loc(spider-man, L),
	loc(thanos, L),
	write("Thanos hit spider-man.... Congratulations! You now have the space stone."), nl,
	move(space,thanos).
attack(X):-
	loc(X, L),
	loc(thanos, L),
	write("Thanos hit "), write(X), nl.
attack(_):-
	write("The heroe is not here."), nl.
	

% caça algum heroe. Pode caçar se tiver no mesmo lugar.
chase(spider-man) :-
	loc(spider-man, L),
	loc(thanos, L),
	move(spider-man, knowhere),
	move(space, knowhere),
	write("The spider-man are back in knowhere."), nl.
chase(_):-
	write("The heroe is not here."), nl.

% função que pega um item. Pode pegar se pessoa tiver no mesmo lugar q o item.
take(power) :-
	move(power,vormir),
	write("Black widow passes behind you and take the power stone with her...You will need to attack her to get stone."), nl.
take(time) :-
	write("Doctor strange has the time stone and it won't give you without some fight..."), nl.
take(space) :-
	write("Spider-man has the space stone and it won't give you without some fight..."), nl.
take(X) :-
	%X= time -> write("time") ; 
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
	heroes,
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
	write("  attack(X). - where X is a heroe Thanos can attack to try to take their stone."), nl,
	write("  take(X). - where X is a thing to take."), nl,
	write("  chase(X). - chasing doctor-strange sends them to the knowhere."), nl,
	write("  look. - the state of the game."), nl,
	write("  help. - this information."), nl,
	write("  quit. - exit the game."), nl,
	nl.

game :-
	write(" Welcome to Infinity War "),nl,
	instructions,
	write(" Go get the infinity stones... "),nl,
	go.
	
