:- dynamic(loc/2).

nextto(pen, yard).
nextto(yard, house).

loc(egg,pen).
loc(ducks,pen).
loc(you,pen).
loc(reality,yard).

move(Item, Place) :-
	retract( loc(Item, _) ),
	assert( loc(Item,Place) ).

connect(X,Y) :-
        nextto(X,Y).
connect(X,Y) :-
        nextto(Y,X).

% finaliza jogo
done :-
	loc(you, house),
	loc(egg, you),
	write("Thanks for getting the egg."), nl.

% define pessoas que se pode chase
demons :-
	ducks,
	fox.

ducks :-
	loc(ducks, pen),
	loc(you, pen),
	move(ducks, yard),
	write("The ducks have run into the yard."), nl.
ducks.

fox :-
	loc(ducks, yard),
	loc(you, house),
	write("The fox has taken a duck."), nl.
fox.

% move pessoa pra outro lugar. 
goto(X) :-
	loc(you, L),
	connect(L, X),
	move(you, X),
	write("You are in the "), write(X), nl.
goto(_) :-
	write("You can't get there from here."), nl.

% comando novo. Attack demon
attack(ducks) :-
	loc(ducks, L),
	loc(you, L),
	write("You hit the ducks."),
	take(reality).
attack(_):-
	write("No ducks here."), nl.
	

% caça algum demon. Pode caçar se tiver no mesmo lugar.
chase(ducks) :-
	loc(ducks, L),
	loc(you, L),
	move(ducks, pen),
	write("The ducks are back in their pen."), nl.
chase(_):-
	write("No ducks here."), nl.

% função que pega um item. Pode pegar se pessoa tiver no mesmo lugar q o item.
take(X) :-
	loc(you, L),
	loc(X, L),
	move(X, you),
	write("You now have the "), write(X),write(" stone."), nl.
take(X) :-
	write("There is no "), write(X), write(" here."), nl.

% mostra onde pessoa tá, o que tem e onde pode ir
look :-
	write("You are in the "),
	loc(you, L), write(L), nl,
	look_connect(L),
	look_here(L),
	look_have(you).

look_connect(L) :-
	write("You can go to: "), nl,
	connect(L, CONNECT),
	write(" "), write(CONNECT), nl,
	fail.
look_connect(_).

look_have(X) :-
	write("You have: "), nl,
	loc(THING, X),
	write(" "), write(THING), nl,
	fail.
look_have(_).

look_here(L) :-
	write("You can see: "), nl,
	loc(THING, L),
	THING \= you,
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
	write("You start in the house, the ducks and an egg"), nl,
	write("are in the pen.  You have to get the egg"), nl,
	write("without losing any ducks."), nl,
	nl,
	write("Enter commands at the prompt as Prolog terms"), nl,
	write("ending in period:"), nl,
	write("  goto(X). - where X is a place to go to."), nl,
	write("  attack(X). - where X is a demon you can attack to try to take their stone."), nl,
	write("  take(X). - where X is a thing to take."), nl,
	write("  chase(X). - chasing ducks sends them to the pen."), nl,
	write("  look. - the state of the game."), nl,
	write("  help. - this information."), nl,
	write("  quit. - exit the game."), nl,
	nl.

game :-
	write(" Welcome to Duck World "),nl,
	instructions,
	write(" Go get an egg "),nl,
	go.
	
