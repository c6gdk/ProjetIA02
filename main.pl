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



%init_disposition().
%choix_mode().

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREDICAT UTILE EN TOUT GENRE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

% predicat pour recup les info d'une case

recup_ligne([T|_],1,T):-!.
recup_ligne([T|Q],Num_ligne,Ligne):- Res is Num_ligne-1, recup_ligne(Q,Res,Ligne). 

recup_case([T|_],1,T):-!.
recup_case([T|Q],Num_Case,Case):- Res is Num_Case-1, recup_case(Q,Res,Case).
recup_case(D,Num_Ligne,Ligne,Num_Case,Case):- recup_ligne(D,Num_Ligne,Ligne), recup_case(Ligne,Num_Case,Case). 
recup_case(X,Y,Ari,Pion):- damier(W),recup_case(W,X,Ligne,Y,[Ari|Pion]), write(Ari) .





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% POSITIONNEMENT D UN PION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% arg1: couleur joueur (donnée), arg2: la case du damier, on verifie que sa queue est vide, et on prend la tete (donnée), 
% arg3: on met la valeur 'k' pour kalista dans la queue et on remet la tete (case retour)

changeP('R',[T|Q],[T|'pR'], 0):- vide(Q),!.
changeP('O',[T|Q],[T|'pO'], 0):- vide(Q),!.
changeP(_,_,_, -1):-!. 		% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place



% arg1: colonne d entrée (donnée), arg2: ligne a modif (donnée), arg3: liste modifiée (retour)

modif_line(J,V,L,LR,0):-elem_n(L,V,E), changeP(J,E,RE,C), C=0, recreate_list(RE,L,V,LR),!.
modif_line(J,V,L,LR,-1):-!. 				% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place.



% arg1: couleur joueur (donnée), arg2: ligne d entrée (donnée) agr3: colonne d entrée (donnée), arg4: damier a modif (donnée), arg5: damier modifié (val de retour)

find_line(J,U,V,D,RD,0):- elem_n(D,U,L), modif_line(J,V,L,RL,C), C=0, recreate_list(RL,D,U,RD),!.
find_line(_,_,V,D,RD,-1):-!. 				% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place.



% arg1: coordonne ligne a verif (donnée), arg2: coordonne col a verif (donnée), arg3: val corrigée ligne (retour), arg4: val corrigée col (retour)

verif_co('R',U,V,U,V):- U>0, U<3, V>0, V<7,!.
verif_co('O',U,V,U,V):- U>4, U<7, V>0, V<7,!.
verif_co(J,_,_,RX,RY):- write('vous avez entre des coordonees erronees, veuillez recommencer'), nl,
	write('pour la ligne l= '), read(X), nl, write('pour la colonne C= '), read(Y), verif_co(J,X,Y,RX,RY),!.


% arg1: valeur permettant de gerer l erreur, si -1 on la gere (donnée), arg2: le joueur utile pour une erreur pour refaire le damier (donnée),
% darg3: on passe le damier pour pouvoir re-realiser le positionnement en cas d erreur (donnée), 
% arg4: le damier precedement modifié dans le cas ou il y a pas eu d erreur, qu on retourne donc (donnée), arg5: le damier modifie en cas d erreur (retour)

verif_case_occup(0,_,_,RD,RD):-!.
verif_case_occup(-1,J,X,_,NRD):- write('la case est deja occupee, veuillez recommencer'), nl, 
	write('pour la ligne l= '), read(U), nl, write('pour la colonne C= '), read(V), verif_co(J,U,V,RU,RV), find_line(J,RU,RV,X,RD,C), verif_case_occup(C,J,X,RD,NRD),!.



positionner(J):- damier(X),  write('entrez les coordonees de la case du pion:'), nl, write('pour la ligne l= '), read(U), nl, write('pour la colonne C= '), read(V), nl, 
	verif_co(J,U,V,RU,RV), find_line(J,RU,RV,X,RD,C), verif_case_occup(C,J,X,RD,NRD), retract(damier(X)), asserta(damier(NRD)).








%%%%%%%%%%%%%%%%%%%%%%%%%% POSITIONNEMENT DE LA KALISTA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% arg1: couleur joueur (donnée), arg2: la case du damier, on verifie que sa queue est vide, et on prend la tete (donnée), 
% arg3: on met la valeur 'k' pour kalista dans la queue et on remet la tete (case retour)

changeK('R',[T|Q],[T|'kR'], 0):- vide(Q),!.
changeK('O',[T|Q],[T|'kO'], 0):- vide(Q),!.
changeK(_,_,_,-1):-!. 		% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place



% arg1: couleur joueur (donnée), arg2: colonne d entrée (donnée), arg3: ligne a modif (donnée), arg4: liste modifiée (retour)

modif_lineK(J,V,L,LR,0):- elem_n(L,V,E), changeK(J,E,RE,C), C=0, recreate_list(RE,L,V,LR),!. 
modif_lineK(J,V,L,LR,-1):-!.				% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place



% arg1: couleur joueur (donnée), arg2: ligne d entrée (donnée) agr3: colonne d entrée (donnée), arg4: damier a modif (donnée), arg5: damier modifié (val de retour)


find_lineK(J,U,V,D,RD,0):- elem_n(D,U,L), modif_lineK(J,V,L,RL,C), C=0, recreate_list(RL,D,U,RD),!.
find_lineK(J,_,V,D,RD,-1):-!.			% on renvoie -1 en code d erreur pour dire que Q est pas vide et donc qu il y deja un pion a la place.



% arg1: valeur permettant de gerer l erreur, si -1 on la gere (donnée), arg2: le joueur utile pour une erreur pour refaire le damier (donnée),
% darg3: on passe le damier pour pouvoir re-realiser le positionnement en cas d erreur (donnée), 
% arg4: le damier precedement modifié dans le cas ou il y a pas eu d erreur, qu on retourne donc (donnée), arg5: le damier modifie en cas d erreur (retour)

verif_case_occupK(0,_,_,RD,RD):-!.
verif_case_occupK(-1,J,X,_,NRD):- write('la case est deja occupee, veuillez recommencer'), nl, 
	write('pour la ligne l= '), read(U), nl, write('pour la colonne C= '), read(V), verif_co(J,U,V,RU,RV), find_lineK(J,RU,RV,X,RD,C), verif_case_occupK(C,J,X,RD,NRD),!.



positionnerK(J):- damier(X),  write('entrez les coordonees de la case de la kalista:'), nl, write('pour la ligne L= '), read(U), nl, write('pour la colonne C= '), read(V), nl, 
	verif_co(J,U,V,RU,RV), find_lineK(J,RU,RV,X,RD,C), verif_case_occupK(C,J,X,RD,NRD), retract(damier(X)), asserta(damier(NRD)).








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SET DE L ENSEMBLE DES PION POUR UNE EQUIPE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




ajout_pion(_,0).			% pas besoin de cut, on est a 0, il pourra pas tenter autre chose (a moins qu il ne remonte avant ?)
ajout_pion(I):- NI is I-1, positionner(J), ajout_pion(J,NI).



%

init_disposition(J):- ajout_pion(J,5), positionnerK(J),!.








%%%%%%%%%%%%%%%%%%%%%% CHOIX DU COTE DE DEPART POUR LE JOUEUR ROUGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



cote_init(_):- write('donnez votre cotez de depart: Nord N, Est E, Sud S Ouest O'),nl,read(X), choix_cote(X).

choix_cote(X):- X='n',!.
choix_cote(X):- X='e',damier(Y), damierE(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):- X='s',damier(Y), damierS(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):- X='o',damier(Y), damierO(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):-cote_init(_).

% renverser renverse le tab dans le sens des aiguilles d une montre x fois
% on rempliera pour le joueur rouge toujours les deux lignes du haut du nouveau tab
% pour le joueur ocre, toujour les deux llignes du bas.









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIALISATION DU DAMIER POUR LES 2 JOUEURS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


initBoard(Joueur):- Joueur='R', cote_init(_), init_disposition(Joueur),!.
initBoard(Joueur):- Joueur='O',  init_disposition(Joueur).









/*
recup_donnee([T|Q],0,0,A):- .
recup_donnee([T|Q],0,Yres,A):-recup_donnee(Q.
recup_donnee([T|Q],Xres,Y,A):- recup_donnee(Q,X,Y,A), X is Xres-1.*/



/*deplacement(D,X1, Y1, X2, Y2, ND):- calc_long(X1, Y1, X2, Y2, L), recup_donnee(D,X1, Y1, A).






















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEPLACEMENT D UN PION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/*
recup_donne(...).


deplacement(D,X1, Y1, X2, Y2, ND):- calc_long(X1, Y1, X2, Y2, L), recup_donnee(X1, Y1, A, L), ,.
>>>>>>> 56bde863ca16080c3b6ad43840a6832decd3ad37


deplacer(_):- write('entrez la case de depart:'), nl, write('coordonne x1= '), read(X1),nl,X1>0,X1<7, write('coordonne y1= '), read(Y1),nl,Y1>0,Y1<7,
	write('entrez la case d arrivee:'), nl, write('coordonne x2= '), read(X2),nl,X2>0,X2<7, write('coordonne y2= '), read(Y2), nl,Y2>0,Y2<7,

	damier(D), deplacement(D,X1, Y1, X2, Y2, ND),retract(damier(D)), asserta(damier(ND)).*/
	








%khan().  

%pion_sorti().  






/*

possibleMoves( Board , Player, PossibleMoveList )			 % uniquement pour l IA ? 

*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





















