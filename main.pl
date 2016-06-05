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


element(X,[X|_]):-!.
element(X,[_|Q]):- element(X,Q).



% arg1: liste a concat (donnée), arg2: liste a concat (donnée), arg3: liste concaténée (retour)

concat([],L,L).
concat([X|Q],L,[X|R]):-concat(Q,L,R).



% arg1: liste ds laquelle on recheche le nieme elem (donnée), arg2: N (donnée), arg3: elem trouvé (retour)

elem_n([T|_],1,T).										% on met un cut là ???? 
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

recup_ligne([T|_],1,T).
recup_ligne([T|Q],Num_ligne,Ligne):- Res is Num_ligne-1, recup_ligne(Q,Res,Ligne). 

recup_case([T|_],1,T).
recup_case([T|Q],Num_Case,Case):- Res is Num_Case-1, recup_case(Q,Res,Case).
recup_case(D,Num_Ligne,Ligne,Num_Case,Case):- recup_ligne(D,Num_Ligne,Ligne), recup_case(Ligne,Num_Case,Case). 
recup_case(X,Y,Ari,Pion):- damier(W),recup_case(W,X,Ligne,Y,[Ari|Pion]) .



/* A garder pour reflechir a un genre de recuperation des cases possédant une arité, mais faut tout revoir du coup

recup_case():-.
recup_case(D,Num_Ligne,[T|_],TempL,Num_Case,T,1):-.
recup_case(D,Num_Ligne,[T|Q],TempL,Num_Case,Case,TempC):- Res is TempC-1, recup_case(Q,Res,Case).
recup_cases(D,Num_Ligne,Ligne,Num_Case,Case):- recup_ligne(D,Num_Ligne,Ligne), recup_case(D,Num_Ligne,Ligne,Num_Ligne,Num_Case,Case,Num_Case). 
recup_cases(X,Y,Ari,Pion):- damier(W),recup_cases(W,X,Ligne,Y,[Ari|Pion]), write(Ari) . */




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































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEPLACEMENT D UN PION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
calc_long(X1, Y1, X2, Y2, L):- L is abs((X2-X1)+(Y2-Y1)).
deplacement(D,X1, Y1, X2, Y2, ND, List_Move):- calc_long(X1, Y1, X2, Y2, L), recup_case(X1, Y1, Arite, Pion), L=A, write('Vous ne pouvez pas vous déplacer aussi loin').
*/


% checkObstacle(D,X,Y):- find_case(D,X,Y,[_|[]]). % regarde si la queue de la case est vide, si oui le predicat s efface

% INITIALISATION
% DEPLACEMENT!!

depl(D,X,Y,[X,Y],0):-!.


depl(D,X,Y,List_Move,Res_Dep):-NX is X-1, NX>0, Res is Res_Dep-1 ,recup_case(NX,Y,A,[[]]), depl(D,NX,Y,List_Move,Res).
depl(D,X,Y,List_Move,Res_Dep):-NX is X+1, NX<10, Res is Res_Dep-1 ,recup_case(NX,Y,A,[[]]), depl(D,NX,Y,List_Move,Res).
depl(D,X,Y,List_Move,Res_Dep):-NY is Y-1, NY>0, Res is Res_Dep-1 ,recup_case(X,NY,A,[[]]), depl(D,X,NY,List_Move,Res).
depl(D,X,Y,List_Move,Res_Dep):-NY is Y+1, NY<10, Res is Res_Dep-1 ,recup_case(X,NY,A,[[]]), depl(D,X,NY,List_Move,Res).


sim_depl(D,X1,Y1,List_Final,Res_Dep):- setof(Result,depl(D,X1,Y1,Result,Res_Dep),List_Final). % retourne sous forme de liste les déplacement possible ;D


deplacer(_):- write('entrez la case de depart:'), nl, write('coordonne x1= '), read(X1),nl,X1>0,X1<7, write('coordonne y1= '), read(Y1),nl,Y1>0,Y1<7,
		damier(D),recup_case(X1,Y1,A,P),sim_depl(D,X1,Y1,List_Final,A),write(List_Final),!. %retract(damier(D)), asserta(damier(ND)).

% IL PEUT REVENIR SUR SES PIED POUR L INSTANT MAIS J4AI UNE IDEE



friendlyFire('R',D,X,Y):- find_case(D,X,Y,[_,[]]),!. 	% si ca tombe pas sur un allié le predicat s efface
friendlyFire('R',D,X,Y):- find_case(D,X,Y,[_,'pO']),!.
friendlyFire('R',D,X,Y):- find_case(D,X,Y,[_,'kO']),!.	% attention là il gagne quand meme mais bon... osef ? nan en vrai avant chaque tour il suffira de regarder 
														% si la kalista du joueur qui va jouer son tour est encore la, sinon, il perd, l autre gagne... EZ

friendlyFire('O',D,X,Y):- find_case(D,X,Y,[_,[]]),!. 	% si ca tombe pas sur un allié le predicat s efface
friendlyFire('O',D,X,Y):- find_case(D,X,Y,[_,'pR']),!.
friendlyFire('O',D,X,Y):- find_case(D,X,Y,[_,'kR']),!.	% idem



/*
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



% arg1: element a retirer (donnée), arg2: liste dans laquelle retirer tous les X (donnée), arg3: liste purifiée (retour)

throwElements(_,[],[]).
throwElements(X,[X|Q],Res):- throwElements(X,Q,Res),!.
throwElements(X,[T|Q],[T|Res]):- throwElements(X,Q,Res).


% retire les doublons de la liste des cases d arrivé possibles

throwSameSquares([],[]).
throwSameSquares([T|Q],[T|R]):- throwElements(T,Q,Res), throwSameSquares(Res,R).



% arg1: Palyer (donnée), arg2: ligne du damier (donnée), arg3: cardinalité de la case (retour),

checkCase('R',[N|'pR'],N).
checkCase('R',[N|'kR'],N).
checkCase('O',[N|'pO'],N).
checkCase('O',[N|'kO'],N).



% arg1: Palyer (donnée), arg2: ligne du damier (donnée), arg3: num ligne (donnée), arg4: num colonne a 1 lors de l appel (donnée),
% arg5: liste des pieces de cette ligne, chaque pieces etant representé par une liste [L,C]  (retour) 

piecesInLine(_,[],_,_,[]):-!.
piecesInLine(P,[T|Q],U,V,[[N,U,V]|RC]):- checkCase(P,T,N), V2 is V+1, piecesInLine(P,Q,U,V2,RC),!.
piecesInLine(P,[T|Q],U,V,RC):- V2 is V+1, piecesInLine(P,Q,U,V2,RC),!.



% arg1: Palyer (donnée), arg2: damier (donnée), arg3: num ligne a 1 lors de l appel (donnée), arg4: num colonne a 1 lors de l appel (donnée),
% arg5: liste de tout les pieces, chaque pieces etant representé par une liste [L,C]  (retour) 

allPeices(_,[],_,_,[]):-!.
allPeices(P,[T|Q],U,V,LP):- piecesInLine(P,T,U,V,PiL), U2 is U+1, allPeices(P,Q,U2,V,R), concat(PiL,R,LP),!.




% on met les coordonées du pion en question au debut de sa liste de moves possibles et donne l arite

movePiece(P,B,[N,X,Y],[[X,Y]|Res]):- sim_depl(P,B,X,Y,List_Temp,List_Final,N), throwSameSquares(List_Final,Res),write(PossibleMoveList),!.



% arg1: Palyer (donnée), arg2: damier (donnée), arg3: liste de coordonnée de pieces (donnée), arg4: liste de touts les moves possibles, chaque move etant une liste (retour),

giveMovesAllPieces(_,_,[],[]):-!.
giveMovesAllPieces(P,B,[T|Q],[Res|R]):- movePiece(P,B,T,Res), giveMovesAllPieces(P,B,Q,R).



possibleMoves(Board,Player,PossibleMoveList):- allPeices(Palyer,Board,LP), giveMovesAllPieces(Palyer,Board,LP,PossibleMoveList),!.  

% just pour try.
appelP(_):- damier(X), possibleMoves(X,'R',L).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TRUCS ESSAIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








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















