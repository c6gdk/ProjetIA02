:-dynamic(damier/1).


%%%%%%%%%%%%%%%% NORD
damier([	[[2,[]],[3,[]],[1,[]],[2,[]],[2,[]],[3,[]]],
			[[2,[]],[1,[]],[3,[]],[1,[]],[3,[]],[1,[]]],
			[[1,[]],[3,[]],[2,[]],[3,[]],[1,[]],[2,[]]],
			[[3,[]],[1,[]],[2,[]],[1,[]],[3,[]],[2,[]]],
			[[2,[]],[3,[]],[1,[]],[3,[]],[1,[]],[3,[]]],
			[[2,[]],[1,[]],[3,[]],[2,[]],[2,[]],[1,[]]]
		]).
		
%%%%%%%%%%%%%%%%% EST		
		
damierE([	[[2,[]],[2,[]],[3,[]],[1,[]],[2,[]],[2,[]]],
			[[1,[]],[3,[]],[1,[]],[3,[]],[1,[]],[3,[]]],
			[[3,[]],[1,[]],[2,[]],[2,[]],[3,[]],[1,[]]],
			[[2,[]],[3,[]],[1,[]],[3,[]],[1,[]],[2,[]]],
			[[2,[]],[1,[]],[3,[]],[1,[]],[3,[]],[2,[]]],
			[[1,[]],[3,[]],[2,[]],[2,[]],[1,[]],[3,[]]]
		]).
		
%%%%%%%%%%%%% SUD		
damierS([	[[1,[]],[2,[]],[2,[]],[3,[]],[1,[]],[2,[]]],
			[[3,[]],[1,[]],[3,[]],[1,[]],[3,[]],[2,[]]],
			[[2,[]],[3,[]],[1,[]],[2,[]],[1,[]],[3,[]]],
			[[2,[]],[1,[]],[3,[]],[2,[]],[3,[]],[1,[]]],
			[[1,[]],[3,[]],[1,[]],[3,[]],[1,[]],[2,[]]],
			[[3,[]],[2,[]],[2,[]],[1,[]],[3,[]],[2,[]]]
		]).
		
%%%%%%%%%%%%% OUEST		
damierO([	[[3,[]],[1,[]],[2,[]],[2,[]],[3,[]],[1,[]]],
			[[2,[]],[3,[]],[1,[]],[3,[]],[1,[]],[2,[]]],
			[[2,[]],[1,[]],[3,[]],[1,[]],[3,[]],[2,[]]],
			[[1,[]],[3,[]],[2,[]],[2,[]],[1,[]],[3,[]]],
			[[3,[]],[1,[]],[3,[]],[1,[]],[3,[]],[1,[]]],
			[[2,[]],[2,[]],[1,[]],[3,[]],[2,[]],[2,[]]]
		]).



joueurR('R').
joueurO('O').










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AFFICHAGE DU DAMIER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

affiche_console(_):- damier(X),affichage_dam(X).

affiche_case(Y):- write(Y), write('|').

affiche_ligne([]).
affiche_ligne([X|Y]):-affiche_case(X),affiche_ligne(Y).

affichage_dam([]).
affichage_dam([X|Y]):-affiche_ligne(X), nl,affichage_dam(Y).











%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREDICATS OUTILS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tete(T, [T|_]).
queue(Q, [_|Q]).
vide([]).
vide([[]]).


elem2(T, L):- queue(Q, L), tete(T,Q).



% arg1: liste a concat (donnée), arg2: liste a concat (donnée), arg3: liste concaténée (retour)

concat([],L,L).
concat([X|Q],L,[X|R]):-concat(Q,L,R).



% arg1: liste ds laquelle on recheche le nieme elem (donnée), arg2: N (donnée), arg3: elem trouvé (retour)

elem_n([T|_],1,T).										% on met un cut là ???? 
elem_n([_|Q],N,E):- NN is N-1, elem_n(Q,NN,E).



% arg1: la case deja modifiée (donnée), arg2: liste dans laquelle mettre la case (donnée), arg3: position de la case dans la liste (donnée), 
% arg3: liste recréé avec la case dedans (retour)

recreate_list(RE,[_|Q],1,[RE|Q]):-!.
recreate_list(RE,[T|Q],V,[T|R]):- NV is V-1, recreate_list(RE,Q,NV,R).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% POSITIONNEMENT D UN PION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% arg1: la case du damier, on verifie que sa queue est vide, et on prend la tete (donnée), arg2: on met la valeur 'P' pour le pion dans la queue et on remet la tete (case retour)

changeP([T|Q],[T|'P'], 0):- vide(Q),!.
changeP([T|Q],[T|'P'], -1):-!. 		% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place



% arg1: colonne d entrée (donnée), arg2: ligne a modif (donnée), arg3: liste modifiée (retour)

modif_line(V,L,LR,0):-elem_n(L,V,E), changeP(E,RE,C), C=0, recreate_list(RE,L,V,LR),!.
modif_line(V,L,LR,-1):-!. 				% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place.



% arg1: ligne d entrée (donnée) agr2: colonne d entrée (donnée), arg3: damier a modif (donnée), arg4: damier modifié (val de retour)

find_line(1,V,D,RD,0):- tete(L,D), modif_line(V,L,RL,C), C=0, recreate_list(RL,D,1,RD),!.
find_line(2,V,D,RD,0):- elem2(L,D) , modif_line(V,L,RL,C), C=0, recreate_list(RL,D,2,RD),!.
find_line(_,V,D,RD,-1):-!. 				% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place.



% arg1: coordonne ligne a verif (donnée), arg2: coordonne col a verif (donnée), arg3: val corrigée ligne (retour), arg4: val corrigée col (retour)

verif_co(U,V,U,V):- U>0, U<3, V>0, V<7,!.
verif_co(_,_,RX,RY):- write('vous avez entre des coordonees erronees, veuillez recommencer'), nl,
	write('pour la ligne l= '), read(X), nl, write('pour la colonne C= '), read(Y), verif_co(X,Y,RX,RY),!.



verif_case_occup(0,_,RD,RD):-!.
verif_case_occup(-1,X,_,NRD):- write('la case est deja occupee, veuillez recommencer'), nl, 
	write('pour la ligne l= '), read(U), nl, write('pour la colonne C= '), read(V), verif_co(U,V,RU,RV), find_line(RU,RV,X,RD,C), verif_case_occup(C,X,RD,NRD),!.



positionner(_):- damier(X),  write('entrez les coordonees de la case du pion:'), nl, write('pour la ligne l= '), read(U), nl, write('pour la colonne C= '), read(V), nl, 
	verif_co(U,V,RU,RV), find_line(RU,RV,X,RD,C), verif_case_occup(C,X,RD,NRD), retract(damier(X)), asserta(damier(NRD)).



%%%%%%%%%%%%%%%%%%%%%%%%%% POSITIONNEMENT DE LA KALISTA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% arg1: la case du damier, on verifie que sa queue est vide, et on prend la tete (donnée), arg2: on met la valeur 'K' pour kalista dans la queue et on remet la tete (case retour)

changeK([T|Q],[T|'K'], 0):- vide(Q).
changeK([T|Q],[T|'K'], -1):-!. 		% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place



% arg1: colonne d entrée (donnée), arg2: ligne a modif (donnée), arg3: liste modifiée (retour)

modif_lineK(V,L,LR,0):-elem_n(L,V,E), changeK(E,RE,C), C=0, recreate_list(RE,L,V,LR). 
modif_lineK(V,L,LR,-1).				% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place



% arg1: ligne d entrée (donnée) agr2: colonne d entrée (donnée), arg3: damier a modif (donnée), arg4: damier modifié (val de retour)

find_lineK(1,V,D,RD,0):- tete(L,D), modif_lineK(V,L,RL,C), C=0, recreate_list(RL,D,1,RD),!. 
find_lineK(2,V,D,RD,0):- elem2(L,D) , modif_lineK(V,L,RL,C), C=0, recreate_list(RL,D,2,RD),!.
find_lineK(_,V,D,RD,-1):-!.			% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place.


% arg1: valeur permettant de gerer l erreur, si -1 on la gere (donnée), arg2: on passe le damier pour pouvoir re-realiser le positionnement en cas d erreur (donnée)
% arg3: le damier precedement modifié dans le cas ou il y a pas eu d erreur, qu on retourne donc (donnée), arg4: le damier modifie en cas d erreur (retour)

verif_case_occupK(0,_,RD,RD):-!.
verif_case_occupK(-1,X,_,NRD):- write('la case est deja occupee, veuillez recommencer'), nl, 
	write('pour la ligne l= '), read(U), nl, write('pour la colonne C= '), read(V), verif_co(U,V,RU,RV), find_lineK(RU,RV,X,RD,C), verif_case_occupK(C,X,RD,NRD),!.



positionnerK(_):- damier(X),  write('entrez les coordonees de la case de la kalista:'), nl, write('pour la ligne L= '), read(U), nl, write('pour la colonne C= '), read(V), nl, 
	verif_co(U,V,RU,RV), find_lineK(RU,RV,X,RD,C), verif_case_occupK(C,X,RD,NRD), retract(damier(X)), asserta(damier(NRD)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SET DE L ENSEMBLE DES PION POUR UNE EQUIPE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





ajout_pion(0).			% pas besoin de cut, on est a 0, il pourra pas tenter autre chose (a moins qu il ne remonte avant ?)
ajout_pion(I):- NI is I-1, positionner(_), ajout_pion(NI).





% si un pion est repositionne au meme endroit ca crash, gerer ce petit pb. !!!!!!!!!!!!!!!

init_disposition(_):- ajout_pion(5), positionnerK(_),!.






%%%%%%%%%%%%%%%%%%%%%%% CHOIX DU COTE DE DEPART POUR LE JOUEUR ROUGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



cote_init(_):- write('donnez votre cotez de depart: Nord N, Est E, Sud S Ouest O'),nl,read(X), choix_cote(X).

choix_cote(X):- X='n',!.
choix_cote(X):- X='e',damier(Y), damierE(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):- X='s',damier(Y), damierS(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):- X='o',damier(Y), damierO(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):-cote_init(_).

% renverser renverse le tab dans le sens des aiguilles d une montre x fois
% on rempliera pour le joueur rouge toujours les deux lignes du haut du nouveau tab
% pour le joueur ocre, toujour les deux llignes du bas.












%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIALISATION DU DAMIER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


initBoard(Joueur):- Joueur='R', cote_init(_), init_disposition(Joueur),!.
initBoard(Joueur):- Joueur='O',  init_disposition(Joueur).
































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEPLACEMENT D UN PION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/*
recup_donne(...).


deplacement(D,X1, Y1, X2, Y2, ND):- calc_long(X1, Y1, X2, Y2, L), recup_donnee(X1, Y1, A, L), ,.


deplacer(_):- write('entrez la case de depart:'), nl, write('coordonne x1= '), read(X1),nl,X1>0,X1<7, write('coordonne y1= '), read(Y1),nl,Y1>0,Y1<7,
	write('entrez la case d arrivee:'), nl, write('coordonne x2= '), read(X2),nl,X2>0,X2<7, write('coordonne y2= '), read(Y2), nl,Y2>0,Y2<7,
	damier(D), deplacement(D,X1, Y1, X2, Y2, ND), retract(damier(D)), asserta(damier(ND)).

*/











/*

possibleMoves( Board , Player, PossibleMoveList )			 % uniquement pour l IA ? 

*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





















