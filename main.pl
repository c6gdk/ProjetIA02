:-dynamic(damier/1).
:-dynamic(khan/1).

khan(0).

%%%%%%%%%%%%%%%% NORD
damier([	[[2,'pR'],[3,'pO'],[1,[]],[2,[]],[2,[]],[3,[]]],
			[[2,'pO'],[1,[]],[3,[]],[1,[]],[3,[]],[1,[]]],
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


element(X,[X|_]):-!.
element(X,[_|Q]):- element(X,Q).



% arg1: liste a concat (donnée), arg2: liste a concat (donnée), arg3: liste concaténée (retour)

concat([],L,L).
concat([X|Q],L,[X|R]):-concat(Q,L,R).



% arg1: liste ds laquelle on recheche le nieme elem (donnée), arg2: N (donnée), arg3: elem trouvé (retour)

elem_n([T|_],1,T):-!.										% on met un cut là ???? 
elem_n([_|Q],N,E):- NN is N-1, elem_n(Q,NN,E).


find_case(D,X,Y,Case):- elem_n(D,X,L), elem_n(L,Y,Case),!.


% arg1: la case deja modifiée (donnée), arg2: liste dans laquelle mettre la case (donnée), arg3: position de la case dans la liste (donnée), 
% arg3: liste recréé avec la case dedans (retour)

recreate_list(RE,[_|Q],1,[RE|Q]):-!.
recreate_list(RE,[T|Q],V,[T|R]):- NV is V-1, recreate_list(RE,Q,NV,R).



% prédicat pour verifier que N est pas dans liste -> on a:  \+ element(X,L) pour ca ...

no_liste(N,[]):-!.
no_liste(N,[N|_]):-fail,!.

no_liste(N,[T|Q]):-no_liste(N,Q). 




% predicat pour recup les info d une case

recup_ligne([T|_],1,T):-!.
recup_ligne([T|Q],Num_ligne,Ligne):- Res is Num_ligne-1, recup_ligne(Q,Res,Ligne). 


recup_case([T|_],1,T):-!.
recup_case([T|Q],Num_Case,Case):- Res is Num_Case-1, recup_case(Q,Res,Case).
recup_case(D,Num_Ligne,Ligne,Num_Case,Case):- recup_ligne(D,Num_Ligne,Ligne), recup_case(Ligne,Num_Case,Case). 


recup_case(X,Y,Ari,Pion):- damier(W),recup_case(W,X,Ligne,Y,[Ari,Pion]) . %Fonction de lancement





efface_pion(0,1,[[X1,Y1]|D],[[X1,[]]|D],Q,Q):-!.
efface_pion(1,1,[[X1,Y1]|D],[[X1,[]]|D],[[X1,Y1]|D],[[X1,[]]|D]):-!.
efface_pion(0,Y,[Te|Qe],[Te|New_Ligne],Q,Q):- Yres is Y-1, efface_pion(0,Yres,Qe,New_Ligne,Q,Q),!.
efface_pion(1,Y,Ligne,New_Ligne,[T|Q],[New_Ligne|Q]):- Ligne = T, efface_pion(0,Y,Ligne,New_Ligne,Q,Q),!.
efface_pion(X,Y,Ligne,New_Ligne,[T|Q],[T|ND]):- Xres is X-1, efface_pion(Xres,Y,Ligne,New_Ligne,Q,ND).

/* A garder pour reflechir a un genre de recuperation des cases possédant une arité, mais faut tout revoir du coup

recup_case():-.
recup_case(D,Num_Ligne,[T|_],TempL,Num_Case,T,1):-.
recup_case(D,Num_Ligne,[T|Q],TempL,Num_Case,Case,TempC):- Res is TempC-1, recup_case(Q,Res,Case).
recup_cases(D,Num_Ligne,Ligne,Num_Case,Case):- recup_ligne(D,Num_Ligne,Ligne), recup_case(D,Num_Ligne,Ligne,Num_Ligne,Num_Case,Case,Num_Case). 
recup_cases(X,Y,Ari,Pion):- damier(W),recup_cases(W,X,Ligne,Y,[Ari|Pion]), write(Ari) . */




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% POSITIONNEMENT D UN PION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% arg1: couleur joueur (donnée), arg2: la case du damier, on verifie que sa queue est vide, et on prend la tete (donnée), 
% arg3: on met la valeur 'k' pour kalista dans la queue et on remet la tete (case retour)

changeP('R',[T|Q],[T,'pR'], 0):- vide(Q),!.
changeP('O',[T|Q],[T,'pO'], 0):- vide(Q),!.
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

changeK('R',[T|Q],[T,'kR'], 0):- vide(Q),!.
changeK('O',[T|Q],[T,'kO'], 0):- vide(Q),!.
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































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEPLACEMENT D UN PION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
calc_long(X1, Y1, X2, Y2, L):- L is abs((X2-X1)+(Y2-Y1)).
deplacement(D,X1, Y1, X2, Y2, ND, List_Move):- calc_long(X1, Y1, X2, Y2, L), recup_case(X1, Y1, Arite, Pion), L=A, write('Vous ne pouvez pas vous déplacer aussi loin').
*/

% checkObstacle(D,X,Y):- find_case(D,X,Y,[_|[]]). % regarde si la queue de la case est vide, si oui le predicat s efface

/*

friendlyFire('R',D,X,Y):- recup_case(X,Y,A,'pR'),!.
friendlyFire('R',D,X,Y):- recup_case(X,Y,A,'kR'),!. 	

friendlyFire('O',D,X,Y):- recup_case(X,Y,A,'kO'),!.
friendlyFire('O',D,X,Y):- recup_case(X,Y,A,'pO'),!.
*/


/*
deplacer(_):- write('entrez la case de depart:'), nl, write('coordonne x1= '), read(X1),nl,X1>0,X1<7, write('coordonne y1= '), read(Y1),nl,Y1>0,Y1<7,
		damier(D),recup_case(X1,Y1,A,[[]]),write("Erreur il n'a pas de pion"),!. % a modifier si le pion est de la bonne couleur





A GARDER Si BUG DE CELLE DU DESSOUS
deplacer(P):- write('entrez la case de depart:'), nl, write('coordonne x1= '), read(X1),nl,X1>0,X1<7, write('coordonne y1= '), read(Y1),nl,Y1>0,Y1<7,
		damier(D),recup_case(X1,Y1,A,Pion), sim_depl(D,X1,Y1,Temp,A), retire_list([X1,Y1],P,D,Temp,List_Final) ,write('deplacement possible: '),nl,afficher_list(List_Final,1),nl,write('Numero du deplacement: '),
		read(C),nl, modif_damier(X1,Y1,List_Final,Pion,C,D,ND), retract(damier(D)), asserta(damier(ND)),!.



deplacement(P,D,X1,Y1,A,Pion):- \+bonne_couleur(Pion,P),write('erreur: pion inexistant ou mauvaise couleur'),nl,deplacer(P),!. % si jamais mauvaise couleur
deplacement(P,D,X1,Y1,A,Pion):- bonne_couleur(Pion,P),  sim_depl(D,X1,Y1,Temp,A), retire_list([X1,Y1],P,D,Temp,List_Final) ,write('deplacement possible: '),nl,
afficher_list(List_Final,1),nl,write('Numero du deplacement: '), read(C),nl, modif_damier(X1,Y1,List_Final, Pion,C,D,Temp2), 
efface_pion(X1,Y1,Ligne,New_ligne,Temp2,ND),retract(damier(D)), asserta(damier(ND)),!.%

deplacer(P):- write('entrez la case de depart:'), nl, write('coordonne x1= '), read(X1),nl,X1>0,X1<7, write('coordonne y1= '), read(Y1),nl,Y1>0,Y1<7,
		damier(D),recup_case(X1,Y1,A,Pion),deplacement(P,D,X1,Y1,A,Pion),!.



% recup_ligne(List_Final,C,Pos_final),!. % retract(damier(D)), asserta(damier(ND)). % il reste a lire la selection du joueur et modifier le damier

*/

/*

% tcheque de la couleur du pion cibler

bonne_couleur('kO','O').
bonne_couleur('pO','O').

bonne_couleur('kR','R').
bonne_couleur('pR','R').

*/

friendlyFire('R',D,X,Y):- recup_case(X,Y,A,'pR'),!.
friendlyFire('R',D,X,Y):- recup_case(X,Y,A,'kR'),!. 	

friendlyFire('O',D,X,Y):- recup_case(X,Y,A,'kO'),!.
friendlyFire('O',D,X,Y):- recup_case(X,Y,A,'pO'),!.


afficher_list([],N):-!.
afficher_list([T|Q],N):- write(N),write(' : '),write(T),nl,Nres is N+1, afficher_list(Q,Nres).



afficher_list_list([],N):-!.
afficher_list_list([[Coord,Move]|Q],N):- write('Pion '),write(N),write(' '),write(Coord), nl, afficher_list(Move,1), Nres is N+1, afficher_list_list(Q,Nres).

retire_list(Coord,Couleur,D,[],[]):- !.

retire_list(Coord,Couleur,D,[Coord|Q],P):- retire_list(Coord,Couleur,D,Q,P),!.

%retire_list(Coord,Couleur,D,[[X1,Y1]|Q],[M|P]):- \+ friendlyFire(Couleur,D,X1,Y1), retire_list(Coord,Couleur,D,Q,P).
retire_list(Coord,Couleur,D,[[X1,Y1]|Q],P):- friendlyFire(Couleur,D,X1,Y1), retire_list(Coord,Couleur,D,Q,P),!.
retire_list(Coord,Couleur,D,[[X1,Y1]|Q],[M|P]):-  M = [X1,Y1],\+friendlyFire(Couleur,D,X1,Y1),retire_list(Coord,Couleur,D,Q,P).




ecrireP(Pion,[T,_],[T,Pion]):-!.

% arg1: colonne d entrée (donnée), arg2: ligne a modif (donnée), arg3: liste modifiée (retour)

ecrire_line(J,V,L,LR):-elem_n(L,V,E), ecrireP(J,E,RE), recreate_list(RE,L,V,LR),!.

ecrire_dam(J,U,V,D,RD):- elem_n(D,U,L), ecrire_line(J,V,L,RL),  recreate_list(RL,D,U,RD),!.


move(P,X1,Y1,NX,NY,D,ND):- find_case(D,X1,Y1,[_,Pion]), ecrire_dam(Pion,NX,NY,D,ND).



% Modifie le damier en 2 etapes insertion nouvelle position effacement ancienne
 % je recup le choix de la poss

modif_damier(X1,Y1,[NX,NY],P,D,ND):- find_case(D,NX,NY,[N|_]), khan(K), retract(khan(K)), asserta(khan(N)), move(P,X1,Y1,NX,NY,D,ND),!. % je recup le choix de la poss, 






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEPLACEMENT D UN PION SUITE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
%friendlyFire('R',D,X,Y):- find_case(D,X,Y,[_,[]]),!.

/*
friendlyFire('R',D,X,Y):- find_case(D,X,Y,[_,[]]),!. 	% si ca tombe pas sur un allié le predicat s efface
friendlyFire('R',D,X,Y):- find_case(D,X,Y,[_,['pO']]),!.
friendlyFire('R',D,X,Y):- find_case(D,X,Y,[_,['kO']]),!.	% attention là il gagne quand meme mais bon... osef ? nan en vrai avant chaque tour il suffira de regarder 
														% si la kalista du joueur qui va jouer son tour est encore la, sinon, il perd, l autre gagne... EZ


friendlyFire('O',D,X,Y):- find_case(D,X,Y,[_,[]]),!. 	% si ca tombe pas sur un allié le predicat s efface
friendlyFire('O',D,X,Y):- find_case(D,X,Y,[_,'pR']),!.
friendlyFire('O',D,X,Y):- find_case(D,X,Y,[_,'kR']),!.	% idem 
*/


% tout simplement : ici on verifie que la case sur laquelle on arrive n est pas une case avec un pion allié dessus, sinon faux

depl(P,D,X,Y,[X,Y],0):-!.
depl(P,D,X,Y,List_Move,1):- NX is X-1, NX>0, depl(P,D,NX,Y,List_Move,0).
depl(P,D,X,Y,List_Move,1):- NX is X+1, NX<7, depl(P,D,NX,Y,List_Move,0).
depl(P,D,X,Y,List_Move,1):- NY is Y-1, NY>0, depl(P,D,X,NY,List_Move,0).
depl(P,D,X,Y,List_Move,1):- NY is Y+1, NY<7, depl(P,D,X,NY,List_Move,0).

depl(P,D,X,Y,List_Move,Res_Dep):- NX is X-1, NX>0, Res is Res_Dep-1 ,recup_case(NX,Y,A,[]), depl(P,D,NX,Y,List_Move,Res).
depl(P,D,X,Y,List_Move,Res_Dep):- NX is X+1, NX<7, Res is Res_Dep-1 ,recup_case(NX,Y,A,[]), depl(P,D,NX,Y,List_Move,Res).
depl(P,D,X,Y,List_Move,Res_Dep):- NY is Y-1, NY>0, Res is Res_Dep-1 ,recup_case(X,NY,A,[]), depl(P,D,X,NY,List_Move,Res). %% BUG ON peut revenir en arriere
depl(P,D,X,Y,List_Move,Res_Dep):- NY is Y+1, NY<7, Res is Res_Dep-1 ,recup_case(X,NY,A,[]), depl(P,D,X,NY,List_Move,Res).

sim_depl(P,D,X1,Y1,List_Final,Res_Dep):- setof(Result,depl(P,D,X1,Y1,Result,Res_Dep),List_Final),!.


% sim_depl(P,D,X1,Y1,[],Res_Dep):- \+ setof(Result,depl(P,D,X1,Y1,Result,Res_Dep),List_Final),!.







% arg1: Palyer (donnée), arg2: ligne du damier (donnée), arg3: cardinalité de la case (retour),

checkCase('R',[N,'pR'],N).
checkCase('R',[N,'kR'],N).
checkCase('O',[N,'pO'],N).
checkCase('O',[N,'kO'],N).


% arg1: Palyer (donnée), arg2: ligne du damier (donnée), arg3: num ligne (donnée), arg4: num colonne a 1 lors de l appel (donnée),
% arg5: liste des pieces de cette ligne, chaque pieces etant representé par une liste [L,C]  (retour) 

piecesInLine(_,[],_,_,[]):-!.
piecesInLine(P,[T|Q],U,V,[[N,U,V]|RC]):- khan(0), checkCase(P,T,N), V2 is V+1, piecesInLine(P,Q,U,V2,RC),!.
piecesInLine(P,[T|Q],U,V,[[N,U,V]|RC]):- khan(Ar), checkCase(P,T,N), Ar=N, V2 is V+1, piecesInLine(P,Q,U,V2,RC),!.
piecesInLine(P,[T|Q],U,V,RC):- V2 is V+1, piecesInLine(P,Q,U,V2,RC),!.



% arg1: Palyer (donnée), arg2: damier (donnée), arg3: num ligne a 1 lors de l appel (donnée), arg4: num colonne a 1 lors de l appel (donnée),
% arg5: liste de tout les pieces, chaque pieces etant representé par une liste [L,C]  (retour) 

allPeices(_,[],_,_,[]):-!.
allPeices(P,[T|Q],U,V,LP):- piecesInLine(P,T,U,V,PiL), U2 is U+1, allPeices(P,Q,U2,V,R), concat(PiL,R,LP),!.




% on met les coordonées du pion en question au debut de sa liste de moves possibles et donne l arite, 
% cela permettera lors de laffichage de comprendre a quel pion on a affaire

movePiece(P,D,[N,X,Y],[]):- \+sim_depl(P,D,X,Y,List_Temp,N),!.
movePiece(P,D,[N,X,Y],[[X,Y]|[List_Final]]):- sim_depl(P,D,X,Y,List_Temp,N), retire_list([X,Y],P,D,List_Temp,List_Final),!.


% arg1: Palyer (donnée), arg2: damier (donnée), arg3: liste de coordonnée de pieces (donnée), arg4: liste de touts les moves possibles, chaque move etant une liste (retour),

giveMovesAllPieces(_,_,[],[]):-!.
giveMovesAllPieces(P,B,[T|Q],R):- movePiece(P,B,T,[]), giveMovesAllPieces(P,B,Q,R),!.
giveMovesAllPieces(P,B,[T|Q],[Res|R]):- movePiece(P,B,T,Res), giveMovesAllPieces(P,B,Q,R).

possibleMoves(Board,Player,PossibleMoveList):- allPeices(Player,Board,1,1,LP), giveMovesAllPieces(Palyer,Board,LP,PossibleMoveList),!.  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% affichage liste de possibilite de move et choix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%damier(D),giveMovesAllPieces('R',D,[2,1,1],A).
%damier(D),giveMovesAllPieces('R',D,[[1,2,6]],A).

% damier(D),movePiece('R',D,[2,1,1],R).
% damier(D),sim_depl('R',D,1,1,List_Temp,2),retire_list([1,1],'R',D,List_Temp,[]).
nomJoueur('O'):- write('Joueur Ocre'), nl.
nomJoueur('R'):- write('Joueur Rouge'), nl.

% voila la forme de la liste PossibleMovesListe:
% [ 
%	[ [coPion1] [ [coMove1] [coMove2] [coMovei] ] ]
%	[ [coPion2] [ [coMove1] [coMove2] [coMovei] ] ]
%	[ [coPioni] [ [coMove1] [coMove2] [coMovei] ] ]
% ]


affichePossibi(_,[]):-!.
affichePossibi(N,[T|Q]):- write('Possibilite num: '), write(N), write(' : '), write(T), nl, NN is N+1, affichePossibi(NN,Q).


compte([],N,N):-!.
compte([_|Q],N,NbP):- Nb is N+1, compte(Q,Nb,NbP),!.

affichageParPion(0,_,_):- nl, write('fin de la liste des possibilites'),!.
affichageParPion(NbP,Np,PML):- elem_n(PML,NbP,[T,Q]), write('Pour la piece num:'), write(Np), write('. de coordonnées: '), write(T), 
								write('on a les possibilités: '), nl, affichePossibi(0,Q), NNbP is NbP-1, NNp is Np +1, affichePossibi(NNbP, NNp, PML).




verifChoix([],1,Ligne,X,Arrivee):-!. %erreur collone


verifChoix([A|_],0,1,X,A):-!.
verifChoix([_|Q],0,Ligne,X,Arrivee):-Lres is Ligne-1,verifChoix(Q,0,Lres,X,Arrivee),!.

verifChoix([[X,[T|_]]|_],1,1,X,T):-!. %marche
verifChoix([[X,Y]|_],1,Ligne,X,Arrivee):- verifChoix(Y,0,Ligne,X,Arrivee),!.

verifChoix([_|Q],Colonne,Ligne,Depart,Arrivee):- Cres is Colonne-1, verifChoix(Q,Cres,Ligne,Depart,Arrivee),!.

/*
verifChoix(PML,NbP,NP,NC,NP,NC):- NP>0, NP=<NbP, NC>0, elem_n(PML,NP,[T,Q]), compte(Q,0,VNC), NC=<VNC,!.
verifChoix(PML,NbP,_,_,_,_):- write('vous avez choisit un choix inexistant, veuillez recommencer '), nl, 
								write('numero pion: '), read(NP), nl, 
								write('numero choix deplacement: '), read(NC),
								verifChoix(PML,NbP,NP,NC,NNP,NNC),!. 
*/

verif_Choix(P,PossibleMoveListe,NP,NC,Depart,Arrive):- verifChoix(PossibleMoveListe,NP,NC,Depart,Arrive),!. % predicat pour gerer les erreur
verif_Choix(P,PossibleMoveListe,NP,NC,Depart,Arrive):- \+verifChoix(PossibleMoveListe,NP,NC,Depart,Arrive), tourH(P),!. % predicat pour gerer les erreur


modeH_choix(P,B,PossibleMoveListe,Depart,Arrive):- 	write('voici le damier a ce stade:'), nl, affiche_console(_),
											/*allPeices(P,B,1,1,LP)*/ nomJoueur(P),
											write(' voici la liste des coups possibles par piece: '), nl,
											afficher_list_list(PossibleMoveListe,1), nl, nl,
											write('Quel est votre choix ?'), nl, write('numero pion: '), read(NP), nl, write('numero choix deplacement: '), read(NC),
											verif_Choix(P,PossibleMoveListe,NP,NC,Depart,Arrive),!.




choixAction(D,P):- allPeices(P,D,1,1,LP), compte(LP,0,Size), write(Size), write(' vous etes bloque, que voulez vous faire').




tourH(P):- damier(D), possibleMoves(D,P,[]), choixAction(D,P),!. % Il peut y avoir que une simple liste je sais pas pourquoi, mieux vaut surcharger c'est plus simple.

tourH(P):- damier(D), possibleMoves(D,P,[[]]), choixAction(D,P),!.

tourH(P):- damier(D), possibleMoves(D,P,Result),modeH_choix(P,D,Result,[X1,Y1],Arrive), modif_damier(X1,Y1,Arrive,P,D,Temp2),
efface_pion(X1,Y1,Ligne,New_ligne,Temp2,ND),retract(damier(D)), asserta(damier(ND)), affiche_console(_),!.






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TRUCS ESSAIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*

deplacement(P,D,X1,Y1,A,Pion):- bonne_couleur(Pion,P),  sim_depl(D,X1,Y1,Temp,A), retire_list([X1,Y1],P,D,Temp,List_Final) ,write('deplacement possible: '),nl,
afficher_list(List_Final,1),nl,write('Numero du deplacement: '), read(C),nl, modif_damier(X1,Y1,List_Final, Pion,C,D,Temp2), 
efface_pion(X1,Y1,Ligne,New_ligne,Temp2,ND),retract(damier(D)), asserta(damier(ND)),!.%

deplacer(P):- write('entrez la case de depart:'), nl, write('coordonne x1= '), read(X1),nl,X1>0,X1<7, write('coordonne y1= '), read(Y1),nl,Y1>0,Y1<7,
		damier(D),recup_case(X1,Y1,A,Pion),deplacement(P,D,X1,Y1,A,Pion),!.


% arg1: element a retirer (donnée), arg2: liste dans laquelle retirer tous les X (donnée), arg3: liste purifiée (retour)

throwElements(_,[],[]).
throwElements(X,[X|Q],Res):- throwElements(X,Q,Res),!.
throwElements(X,[T|Q],[T|Res]):- throwElements(X,Q,Res).


% retire les doublons de la liste des cases d arrivé possibles

throwSameSquares([],[]).
throwSameSquares([T|Q],[T|R]):- throwElements(T,Q,Res), throwSameSquares(Res,R).

*/



/*

leMove(P,B,3,X,Y,Res).

alreadyFound([],Again,Again):-!. % si Move1P ressort rien du fait des contraintes (obstacles et sortie de board)
alreadyFound(Res,[],Res):-!.	% si rien dans la liste again pour l instant
alreadyFound(Res,Again,Res):- \+ element(Res,Again):-!.
alreadyFound(Res,Again,-1).


% arg1: Palyer (donnée), arg2: Board (donnée), arg3: liste arité-ligne-col (donnée), agr4: nb de resultats a obtenir, en fonction de l arite (donnée)
% arg5: liste de coordonée de moves acceptables (retour)

Move1P(P,B,[3,X,Y],16,[Res|Again]):- leMove(P,B,3,X,Y,Res), Move1P(P,B,[3,X,Y]),15,Again),!.
Move1P(P,B,[3,X,Y],Try,[GoodRes|Again]):- NTry is Try-1, leMove(P,B,3,X,Y,Res), alreadyFound(Res,Again,GoodRes), GoodRes=\=-1, Move1P(P,B,[3,X,Y]),NTry,Again),!.
Move1P(P,B,[3,X,Y],Try,Again):- leMove(P,B,3,X,Y,Res), alreadyFound(Res,Again,GoodRes), Move1P(P,B,[3,X,Y]),NTry,Again),!.

Move1P(P,B,[2,X,Y],9,[Res|Again]):- leMove(P,B,2,X,Y,Res), Move1P(P,B,[2,X,Y]),8,Again),!.
Move1P(P,B,[2,X,Y],Try,[GoodRes|Again]):- NTry is Try-1, leMove(P,B,2,X,Y,Res), alreadyFound(Res,Again,GoodRes), GoodRes=\=-1, Move1P(P,B,[2,X,Y]),NTry,Again),!.
Move1P(P,B,[2,X,Y],Try,Again):- leMove(P,B,2,X,Y,Res), alreadyFound(Res,Again,GoodRes), Move1P(P,B,[2,X,Y]),NTry,Again),!.

Move1P(P,B,[1,X,Y],4,[Res|Again]):- leMove(P,B,1,X,Y,Res), Move1P(P,B,[1,X,Y]),3,Again),!.
Move1P(P,B,[1,X,Y],Try,[GoodRes|Again]):- NTry is Try-1, leMove(P,B,1,X,Y,Res), alreadyFound(Res,Again,GoodRes), GoodRes=\=-1, Move1P(P,B,[1,X,Y]),NTry,Again),!.
Move1P(P,B,[1,X,Y],Try,Again):- leMove(P,B,1,X,Y,Res), alreadyFound(Res,Again,GoodRes), Move1P(P,B,[1,X,Y]),NTry,Again),!.
*/





/*
recup_donne(...).


deplacement(D,X1, Y1, X2, Y2, ND):- calc_long(X1, Y1, X2, Y2, L), recup_donnee(X1, Y1, A, L), ,.


deplacer(_):- write('entrez la case de depart:'), nl, write('coordonne x1= '), read(X1),nl,X1>0,X1<7, write('coordonne y1= '), read(Y1),nl,Y1>0,Y1<7,
	write('entrez la case d arrivee:'), nl, write('coordonne x2= '), read(X2),nl,X2>0,X2<7, write('coordonne y2= '), read(Y2), nl,Y2>0,Y2<7,
	damier(D), deplacement(D,X1, Y1, X2, Y2, ND),retract(damier(D)), asserta(damier(ND)).

*/
/*
poss_depla(D,X1, Y1, List_Move):-recup_case(X1, Y1, Arite, Pion), sim_depl(D,X1,Y1,List_Move, Arite).

deplacer(_):- write('entrez la case de depart:'), nl, write('coordonne x1= '), read(X1),nl,X1>0,X1<7, write('coordonne y1= '), read(Y1),nl,Y1>0,Y1<7, poss_depla(D,X1, Y1, List_Move)
	write('entrez la case d arrivee:'), nl, write('coordonne x2= '), read(X2),nl,X2>0,X2<7, write('coordonne y2= '), read(Y2), nl,Y2>0,Y2<7,

	damier(D), deplacement(D,X1, Y1, X2, Y2, ND, List_Move),retract(damier(D)), asserta(damier(ND)).*/

/*
a garder si jamais bug
deplacer(_):- write('entrez la case de depart:'), nl, write('coordonne x1= '), read(X1),nl,X1>0,X1<7, write('coordonne y1= '), read(Y1),nl,Y1>0,Y1<7,
	write('entrez la case d arrivee:'), nl, write('coordonne x2= '), read(X2),nl,X2>0,X2<7, write('coordonne y2= '), read(Y2), nl,Y2>0,Y2<7,
	*/

%khan().  

%pion_sorti().  




/*

% IL PEUT REVENIR SUR SES PIED POUR L INSTANT MAIS J4AI UNE IDEE

<<<<<<< HEAD


friendlyFire('R',D,X,Y):- find_case(D,X,Y,[_,[]]),!. 	% si ca tombe pas sur un allié le predicat s efface
friendlyFire('R',D,X,Y):- find_case(D,X,Y,[_,'pO']),!.
friendlyFire('R',D,X,Y):- find_case(D,X,Y,[_,'kO']),!.	% attention là il gagne quand meme mais bon... osef ? nan en vrai avant chaque tour il suffira de regarder 
														% si la kalista du joueur qui va jouer son tour est encore la, sinon, il perd, l autre gagne... EZ

friendlyFire('O',D,X,Y):- find_case(D,X,Y,[_,[]]),!. 	% si ca tombe pas sur un allié le predicat s efface
friendlyFire('O',D,X,Y):- find_case(D,X,Y,[_,'pR']),!.
friendlyFire('O',D,X,Y):- find_case(D,X,Y,[_,'kR']),!.	% idem

=======
% Sortie de plateau
depl_haut(D,X,Y,List_Temp,List_Move,1):- Xres is X-1, Xres=<0,!. % INITIALISATION
depl_haut(D,X,Y,List_Temp,List_Move,1):- Xres is X-1, Xres=<0.
depl_haut(D,X,Y,List_Temp,List_Move,Res_Dep):- NX is X-1, NX=<0.
%
depl_haut(D,X,Y,[],[[Xres,Y]],1):-Xres is X-1, Xres>0,!. % INITIALISATION
depl_haut(D,X,Y,List_Temp,List_Move,1):- Xres is X-1, Xres>0, concat([[Xres,Y]],List_Temp,List_Move).
depl_haut(D,X,Y,List_Temp,List_Move,Res_Dep):-NX is X-1, NX>0, Res is Res_Dep-1 , sim_depl(D,NX,Y,List_Temp,List_Move,Res).
=======

>>>>>>> f5d7fca4aaa62495c59646c22f7578401e2cdbd7



test(_):- damier(X), write('ok'). % friendlyFire('O',X, 1,1).

% Sortie de plateau
depl_haut(P,D,X,Y,[],List_Move,1):- Xres is X-1, Xres=<0,!. 					% INITIALISATION
depl_haut(P,D,X,Y,List_Temp,List_Move,1):- Xres is X-1, Xres=<0,!.
depl_haut(P,D,X,Y,List_Temp,List_Move,Res_Dep):- NX is X-1, NX=<0.
%


depl_haut(P,D,X,Y,[[Xres,Y]],[[Xres,Y]],1):-Xres is X-1, Xres>0,!. 			% INITIALISATION
depl_haut(P,D,X,Y,List_Temp,List_Move,1):- Xres is X-1, Xres>0, friendlyFire(P,D,Xres,Y), concat([[Xres,Y]],List_Temp,List_Move),!.
depl_haut(P,D,X,Y,List_Temp,List_Move,1),!. 	% si la case d arrivee est une case alliée, on kill pas l allié.

depl_haut(P,D,X,Y,List_Temp,List_Move,Res_Dep):-NX is X-1, NX>0, Res is Res_Dep-1, checkObstacle(D,X,Y), sim_depl(P,D,NX,Y,List_Temp,List_Move,Res),!.		% si pas d obstacle
depl_haut(P,D,X,Y,List_Temp,List_Move,Res_Dep).		% sinon



% Sortie de plateau
depl_bas(P,D,X,Y,[],List_Move,1):-Xres is X+1, Xres>6,!.						% INITIALISATION 
depl_bas(P,D,X,Y,List_Temp,List_Move,1):- Xres is X+1,Xres>6,!.
depl_bas(P,D,X,Y,List_Temp,List_Move,Res_Dep):-NX is X+1,NX>6.
%
depl_bas(P,D,X,Y,[[Xres,Y]],[[Xres,Y]],1):-Xres is X+1,Xres>0,! . 			% INITIALISATION
depl_bas(D,X,Y,List_Temp,List_Move,1):- Xres is X+1,Xres>0, friendlyFire(P,D,Xres,Y), concat([[Xres,Y]],List_Temp,List_Move),!.
depl_bas(D,X,Y,List_Temp,List_Move,1),!.

depl_bas(P,D,X,Y,List_Temp,List_Move,Res_Dep):-NX is X+1,NX>0, Res is Res_Dep-1, checkObstacle(D,X,Y), sim_depl(P,D,NX,Y,List_Temp,List_Move,Res),!.		% si pas d obstacle
depl_bas(P,D,X,Y,List_Temp,List_Move,Res_Dep).		% sinon



depl_droite(P,D,X,Y,[],List_Move,1):-Yres is Y+1,Yres>6,! . 					% INITIALISATION
depl_droite(P,D,X,Y,List_Temp,List_Move,1):-Yres is Y+1 ,Yres>6,!.
depl_droite(P,D,X,Y,List_Temp,List_Move,Res_Dep):-NY is Y+1,NY>6.


depl_droite(P,D,X,Y,[[X,Yres]],[[X,Yres]],1):-Yres is Y+1,Yres>0,!. 			% INITIALISATION
depl_droite(P,D,X,Y,List_Temp,List_Move,1):-Yres is Y+1 ,Yres>0, friendlyFire(P,D,X,Yres), concat([[X,Yres]],List_Temp,List_Move),!.
depl_droite(P,D,X,Y,List_Temp,List_Move,1),!.

depl_droite(P,D,X,Y,List_Temp,List_Move,Res_Dep):-NY is Y+1,NY>0, Res is Res_Dep-1, checkObstacle(D,X,Y), sim_depl(P,D,X,NY,List_Temp,List_Move,Res),!.		% si pas d obstacle
depl_droite(P,D,X,Y,List_Temp,List_Move,Res_Dep).		% sinon


depl_gauche(P,D,X,Y,[],List_Move,1):-Yres is Y-1,Yres=<0,!.					% INITIALISATION
depl_gauche(P,D,X,Y,List_Temp,List_Move,1):-Yres is Y-1 ,Yres=<0,!.
depl_gauche(P,D,X,Y,List_Temp,List_Move,Res_Dep):-NY is Y-1,NY=<0.

depl_gauche(P,D,X,Y,[[X,Yres]],[[X,Yres]],1):-Yres is Y-1,Yres>0,!.			% INITIALISATION 
depl_gauche(P,D,X,Y,List_Temp,List_Move,1):-Yres is Y-1 ,Yres>0, friendlyFire(P,D,X,Yres), concat([[X,Yres]],List_Temp,List_Move),!.
depl_gauche(P,D,X,Y,List_Temp,List_Move,1),!.



depl_gauche(P,D,X,Y,List_Temp,List_Move,Res_Dep):-NY is Y-1,NY>0, Res is Res_Dep-1, checkObstacle(D,X,Y), sim_depl(P,D,X,NY,List_Temp,List_Move,Res),!.		% si pas d obstacle
depl_gauche(P,D,X,Y,List_Temp,List_Move,Res_Dep).		% sinon




sim_depl(P,D,X1,Y1,List_Temp,List_Final,Res_Dep):- depl_haut(P,D,X1,Y1,List_Temp,List_Move,Res_Dep), depl_gauche(P,D,X1,Y1,List_Move,List_Result,Res_Dep),
	depl_bas(P,D,X1,Y1,List_Result,List_Result2,Res_Dep), depl_droite(P,D,X1,Y1,List_Result2,List_Final,Res_Dep),!.


*/








