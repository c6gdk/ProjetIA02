%%%% MEIER RAPHAEL%%%%%%%
%%%% MICHEL THOMAS %%%%%%%



:-dynamic(damier/1).
:-dynamic(khan/1).

khan(0).

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

affiche_console(_):- damier(X), affichage_dam(X).

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




%trouve l element dans une liste simple
element(X,[X|_]):-!.
element(X,[_|Q]):- element(X,Q).

%idem mais retourne la position

element(X,[X|_],1):-!.
element(X,[_|Q],N):- element(X,Q,Nres),N is Nres+1.


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




% predicat pour recup les info d une case, recup_case(Coordonnée X, Coordonnée Y, Recupération d l'arité, Recupération de la valeur du pion)

recup_ligne([T|_],1,T):-!.
recup_ligne([T|Q],Num_ligne,Ligne):- Res is Num_ligne-1, recup_ligne(Q,Res,Ligne). 


recup_case([T|_],1,T):-!.
recup_case([T|Q],Num_Case,Case):- Res is Num_Case-1, recup_case(Q,Res,Case).
recup_case(D,Num_Ligne,Ligne,Num_Case,Case):- recup_ligne(D,Num_Ligne,Ligne), recup_case(Ligne,Num_Case,Case). 


recup_case(X,Y,Ari,Pion):- damier(W),recup_case(W,X,Ligne,Y,[Ari,Pion]) . %Fonction de lancement

retire_last_elem([T|[]],[]):-!.
retire_last_elem([T|Q],[T|Qres]):-retire_last_elem(Q,Qres).

% l inverse: recupére les coordonnées de toutes les cases avec les info données, avec backtracking (utiliser un setof/ bagof après)


trouve_ligne([[Ari,Pion]|_],_,1,Ari,Pion).
trouve_ligne([T|Q],_,Y,Ari,Pion):- trouve_ligne(Q,X,Yres,Ari,Pion), Y is Yres +1.
trouve_case([],0,Y,Ari,Pion):-trouve_ligne(Q,X,Y,Ari,Pion),!.
trouve_case([T|_],X,Y,Ari,Pion):-trouve_ligne(T,Xres,Y,Ari,Pion),trouve_case(Q,Xres,Y,Ari,Pion),X is Xres+1.
trouve_case([T|Q],X,Y,Ari,Pion):- trouve_case(Q,Xres,Y,Ari,Pion), X is Xres+1.




%prédicat effacant le  en coordonnées X,Y. ON recupére le nouveau damier en fin de prédicat, ne pas oublier d'asserta


efface_pion(0,1,[[X1,Y1]|D],[[X1,[]]|D],Q,Q):-!.
efface_pion(1,1,[[X1,Y1]|D],[[X1,[]]|D],[[X1,Y1]|D],[[X1,[]]|D]):-!.
efface_pion(0,Y,[Te|Qe],[Te|New_Ligne],Q,Q):- Yres is Y-1, efface_pion(0,Yres,Qe,New_Ligne,Q,Q),!.
efface_pion(1,Y,Ligne,New_Ligne,[T|Q],[New_Ligne|Q]):- Ligne = T, efface_pion(0,Y,Ligne,New_Ligne,Q,Q),!.
efface_pion(X,Y,Ligne,New_Ligne,[T|Q],[T|ND]):- Xres is X-1, efface_pion(Xres,Y,Ligne,New_Ligne,Q,ND).


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


%positionne un pion au cordonnées U,V
positionner(J):- damier(X),  write('entrez les coordonees de la case du pion:'), nl, write('pour la ligne l= '), read(U), nl, write('pour la colonne C= '), read(V), nl, 
	verif_co(J,U,V,RU,RV), find_line(J,RU,RV,X,RD,C), verif_case_occup(C,J,X,RD,NRD), retract(damier(X)), asserta(damier(NRD)).

% idem mais pour l'IA
positionnerIA(J,U,V):- damier(X), verif_co(J,U,V,RU,RV), find_line(J,RU,RV,X,RD,C), verif_case_occup(C,J,X,RD,NRD), retract(damier(X)), asserta(damier(NRD)).






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


% positionne la kalista au coordonnée U,V
positionnerK(J):- damier(X),  write('entrez les coordonees de la case de la kalista:'), nl, write('pour la ligne L= '), read(U), nl, write('pour la colonne C= '), read(V), nl, 
	verif_co(J,U,V,RU,RV), find_lineK(J,RU,RV,X,RD,C), verif_case_occupK(C,J,X,RD,NRD), retract(damier(X)), asserta(damier(NRD)).



%idem pour IA
positionnerKIA(J,U,V):- damier(X), verif_co(J,U,V,RU,RV), find_lineK(J,RU,RV,X,RD,C), verif_case_occupK(C,J,X,RD,NRD), retract(damier(X)), asserta(damier(NRD)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SET DE L ENSEMBLE DES PION POUR UNE EQUIPE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%verifie que l'on a pas deja ajouter + de 5 pion

ajout_pion(_,0).			% pas besoin de cut, on est a 0, il pourra pas tenter autre chose (a moins qu il ne remonte avant ?)
ajout_pion(J,I):- NI is I-1, positionner(J), ajout_pion(J,NI).



% predicat global de pose de piece pour uj joueur

init_disposition(J):- ajout_pion(J,5), positionnerK(J),!.








%%%%%%%%%%%%%%%%%%%%%% CHOIX DU COTE DE DEPART POUR LE JOUEUR ROUGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% predicat de lecture
cote_init(_):- write('donnez votre cotez de depart: Nord N, Est E, Sud S Ouest O'),nl,read(X), choix_cote(X).

choix_cote(X):- X='N',!.
choix_cote(X):- X='E',damier(Y), damierE(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):- X='S',damier(Y), damierS(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):- X='O',damier(Y), damierO(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):-cote_init(_).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIALISATION DU DAMIER POUR LES 2 JOUEURS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

initBoardIA('R'):-positionnerIA('R',2,5),positionnerIA('R',2,1),positionnerIA('R',1,2),positionnerIA('R',2,3),positionnerIA('R',2,6),positionnerKIA('R',1,5).
initBoardIA('O'):-positionnerIA('O',5,5),positionnerIA('O',5,1),positionnerIA('O',6,2),positionnerIA('O',5,3),positionnerIA('O',5,6),positionnerKIA('O',6,5).

initBoard(Joueur):- Joueur='R', write('Init joueur R'),nl,affiche_console(_),nl,cote_init(_), init_disposition(Joueur),!.
initBoard(Joueur):- Joueur='O', write('Init joueur O'),nl,affiche_console(_),nl, init_disposition(Joueur).













%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEPLACEMENT D UN PION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% voila la forme de la liste PossibleMovesListe:
% [ 
%	[ [coPion1] [ [coMove1] [coMove2] [coMovei] ] ]
%	[ [coPion2] [ [coMove1] [coMove2] [coMovei] ] ]
%	[ [coPioni] [ [coMove1] [coMove2] [coMovei] ] ]
% ]

%cette liste est la forme sous laquelle on recupére les depacement possible

%prédicat du tire amis, si on termine sur un case ami ce prédicat s'efface
friendlyFire('O',D,X,Y):- recup_case(X,Y,A,'kO'),!.
friendlyFire('O',D,X,Y):- recup_case(X,Y,A,'pO'),!.
friendlyFire('R',D,X,Y):- recup_case(X,Y,A,'pR'),!.
friendlyFire('R',D,X,Y):- recup_case(X,Y,A,'kR'),!. 	



% affiche list affiche la liste de deplacement possible par pion
afficher_list([],N):-!.
afficher_list([T|Q],N):- write(N),write(' : '),write(T),nl,Nres is N+1, afficher_list(Q,Nres).
afficher_list_list([],N):-!.
afficher_list_list([[Coord,Move]|Q],N):- write('Pion '),write(N),write(' '),write(Coord), nl, afficher_list(Move,1), Nres is N+1, afficher_list_list(Q,Nres).

% ce predicat retire les positions impossible notament celle avec le friendly fire, a la base on retirai aussi la case de départ mais une amélioration du prédicate de mouvement a rendu cela inutile
retire_list(Coord,Couleur,D,[],[]):- !.
retire_list(Coord,Couleur,D,[Coord|Q],P):- retire_list(Coord,Couleur,D,Q,P),!.
retire_list(Coord,Couleur,D,[[X1,Y1]|Q],P):- friendlyFire(Couleur,D,X1,Y1), retire_list(Coord,Couleur,D,Q,P),!.
retire_list(Coord,Couleur,D,[[X1,Y1]|Q],[M|P]):-  M = [X1,Y1],/*\+friendlyFire(Couleur,D,X1,Y1),*/retire_list(Coord,Couleur,D,Q,P).

% move va écrire un pion au coordonnée NX,NY données, on garde les ancienne coordonnées afin de recuperer la valeur du pion à ecrire
ecrireP(Pion,[T,_],[T,Pion]):-!.
% arg1: colonne d entrée (donnée), arg2: ligne a modif (donnée), arg3: liste modifiée (retour)
ecrire_line(J,V,L,LR):-elem_n(L,V,E), ecrireP(J,E,RE), recreate_list(RE,L,V,LR),!.
ecrire_dam(J,U,V,D,RD):- elem_n(D,U,L), ecrire_line(J,V,L,RL),  recreate_list(RL,D,U,RD),!.
move(P,X1,Y1,NX,NY,D,ND):- find_case(D,X1,Y1,[_,Pion]), ecrire_dam(Pion,NX,NY,D,ND).

% Modifie le damier en 2 etapes insertion nouvelle position effacement ancienne
 % je recup le choix de la poss
modif_damier(X1,Y1,[NX,NY],P,D,ND):- find_case(D,NX,NY,[N|_]), khan(K), retract(khan(K)), asserta(khan(N)), move(P,X1,Y1,NX,NY,D,ND),!. % je recup le choix de la poss, 



%prédicat de déplacement on donne toutes les possibilité de déplacement puis on laisse le back tracking tout nous renvoyé
% tout simplement : ici on verifie que la case sur laquelle on arrive n est pas une case avec un pion allié dessus, sinon faux

depl(P,D,X,Y,[X,Y],0,_):-!.
depl(P,D,X,Y,List_Move,1,Dir):- NX is X-1, NX>0, Dir\='B', depl(P,D,NX,Y,List_Move,0,'H').
depl(P,D,X,Y,List_Move,1,Dir):- NX is X+1, NX<7, Dir\='H', depl(P,D,NX,Y,List_Move,0,'B').
depl(P,D,X,Y,List_Move,1,Dir):- NY is Y-1, NY>0, Dir\='D', depl(P,D,X,NY,List_Move,0,'G').
depl(P,D,X,Y,List_Move,1,Dir):- NY is Y+1, NY<7, Dir\='G', depl(P,D,X,NY,List_Move,0,'D').

depl(P,D,X,Y,List_Move,Res_Dep,Dir):- NX is X-1, NX>0, Res is Res_Dep-1 ,find_case(D,NX,Y,[A,[]]),Dir\='B', depl(P,D,NX,Y,List_Move,Res,'H').
depl(P,D,X,Y,List_Move,Res_Dep,Dir):- NX is X+1, NX<7, Res is Res_Dep-1 ,find_case(D,NX,Y,[A,[]]),Dir\='H', depl(P,D,NX,Y,List_Move,Res,'B').
depl(P,D,X,Y,List_Move,Res_Dep,Dir):- NY is Y-1, NY>0, Res is Res_Dep-1 ,find_case(D,X,NY,[A,[]]),Dir\='D', depl(P,D,X,NY,List_Move,Res,'G'). %% BUG ON peut revenir en arriere
depl(P,D,X,Y,List_Move,Res_Dep,Dir):- NY is Y+1, NY<7, Res is Res_Dep-1 ,find_case(D,X,NY,[A,[]]),Dir\='G', depl(P,D,X,NY,List_Move,Res,'D').

sim_depl(P,D,X1,Y1,List_Final,Res_Dep):- setof(Result,depl(P,D,X1,Y1,Result,Res_Dep,'N'),List_Final),!.



% Tout ces argument servent a recuperer tout les coup possible pour toutes les pièces

% arg1: Palyer (donnée), arg2: ligne du damier (donnée), arg3: cardinalité de la case (retour),

checkCase('R',[N,'pR'],N):-!.
checkCase('R',[N,'kR'],N):-!.
checkCase('O',[N,'pO'],N):-!.
checkCase('O',[N,'kO'],N):-!.


% arg1: Palyer (donnée), arg2: ligne du damier (donnée), arg3: num ligne (donnée), arg4: num colonne a 1 lors de l appel (donnée),
% arg5: liste des pieces de cette ligne, chaque pieces etant representé par une liste [L,C]  (retour) 
% si le khan est égale a 0 on recupére toutes les pieces et pas seulement les pieces sur la bonne arité
piecesInLine(_,[],_,_,[],_):-!.
piecesInLine(P,[T|Q],U,V,[[N,U,V]|RC],Khan):- Khan=0, checkCase(P,T,N), V2 is V+1, piecesInLine(P,Q,U,V2,RC,Khan),!.
piecesInLine(P,[T|Q],U,V,[[N,U,V]|RC],Khan):-  Khan\=0,checkCase(P,T,N), Khan=N, V2 is V+1, piecesInLine(P,Q,U,V2,RC,Khan),!.
piecesInLine(P,[T|Q],U,V,RC,Khan):- V2 is V+1, piecesInLine(P,Q,U,V2,RC,Khan),!.



% arg1: Palyer (donnée), arg2: damier (donnée), arg3: num ligne a 1 lors de l appel (donnée), arg4: num colonne a 1 lors de l appel (donnée),
% arg5: liste de tout les pieces, chaque pieces etant representé par une liste [L,C]  (retour) 

allPeices(_,[],_,_,[],Khan):-!.
allPeices(P,[T|Q],U,V,LP,Khan):- piecesInLine(P,T,U,V,PiL,Khan), U2 is U+1, allPeices(P,Q,U2,V,R,Khan), concat(PiL,R,LP),!.




% on met les coordonées du pion en question au debut de sa liste de moves possibles et donne l arite, 
% cela permettera lors de laffichage de comprendre a quel pion on a affaire

movePiece(P,D,[N,X,Y],[]):- \+sim_depl(P,D,X,Y,List_Temp,N),!.
movePiece(P,D,[N,X,Y],[[X,Y]|[List_Final]]):- sim_depl(P,D,X,Y,List_Temp,N), retire_list([X,Y],P,D,List_Temp,List_Final),!.


% arg1: Palyer (donnée), arg2: damier (donnée), arg3: liste de coordonnée de pieces (donnée), arg4: liste de touts les moves possibles, chaque move etant une liste (retour),

giveMovesAllPieces(_,_,[],[]):-!.
giveMovesAllPieces(P,B,[T|Q],R):- movePiece(P,B,T,[]), giveMovesAllPieces(P,B,Q,R),!.
giveMovesAllPieces(P,B,[T|Q],[Res|R]):- movePiece(P,B,T,Res), giveMovesAllPieces(P,B,Q,R).

possibleMoves(Board,Player,PossibleMoveList,Khan):-  allPeices(Player,Board,1,1,LP,Khan), giveMovesAllPieces(Player,Board,LP,PossibleMoveList),!.  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% affichage liste de possibilite de move et choix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


nomJoueur('O'):- write('Joueur Ocre'), nl.
nomJoueur('R'):- write('Joueur Rouge'), nl.

% affichage avec plusieurs prédicats, de notre listes de coup possibles
affichePossibi(_,[]):-!.
affichePossibi(N,[T|Q]):- write('Possibilite num: '), write(N), write(' : '), write(T), nl, NN is N+1, affichePossibi(NN,Q).


compte([],N,N):-!.
compte([_|Q],N,NbP):- Nb is N+1, compte(Q,Nb,NbP),!.

affichageParPion(0,_,_):- nl, write('fin de la liste des possibilites'),!.
affichageParPion(NbP,Np,PML):- elem_n(PML,NbP,[T,Q]), write('Pour la piece num:'), write(Np), write('. de coordonnées: '), write(T), 
								write('on a les possibilités: '), nl, affichePossibi(0,Q), NNbP is NbP-1, NNp is Np +1, affichePossibi(NNbP, NNp, PML).


% verif choix permet de verifier si le déplacement est bien effectuable, il permet surtout de recuperer les coordonnées de départ et d'arriver pour pouvoir utiliser nos prédicat d'insertion
verifChoix([],1,Ligne,X,Arrivee):-!. %erreur collone
verifChoix([A|_],0,1,X,A):-!.
verifChoix([_|Q],0,Ligne,X,Arrivee):-Lres is Ligne-1,verifChoix(Q,0,Lres,X,Arrivee),!.
verifChoix([[X,[T|_]]|_],1,1,X,T):-!. %marche
verifChoix([[X,Y]|_],1,Ligne,X,Arrivee):- verifChoix(Y,0,Ligne,X,Arrivee),!.
verifChoix([_|Q],Colonne,Ligne,Depart,Arrivee):- Cres is Colonne-1, verifChoix(Q,Cres,Ligne,Depart,Arrivee),!.
verif_Choix(P,PossibleMoveListe,NP,NC,Depart,Arrive):- verifChoix(PossibleMoveListe,NP,NC,Depart,Arrive),!. % predicat pour gerer les erreur
verif_Choix(P,PossibleMoveListe,NP,NC,Depart,Arrive):- \+verifChoix(PossibleMoveListe,NP,NC,Depart,Arrive), tourH(P),!. % predicat pour gerer les erreur

%affichage pour l'utilisateur de l'interface d'un tour, liste de pion et pour chaque pion la liste de coup, on recupere apres le numero du pion et le numero du deplacement
modeH_choix(P,B,PossibleMoveListe,Depart,Arrive):- 	write('voici le damier a ce stade:'), nl, affiche_console(_),
											/*allPeices(P,B,1,1,LP)*/ nomJoueur(P),
											write(' voici la liste des coups possibles par piece: '), nl,
											afficher_list_list(PossibleMoveListe,1), nl, nl,
											write('Quel est votre choix ?'), nl, write('numero pion: '), read(NP), nl, write('numero choix deplacement: '), read(NC),
											verif_Choix(P,PossibleMoveListe,NP,NC,Depart,Arrive),!.








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ICI gestion si impossible de déplacé un pion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ecri le pion en position choisi par le joueur 
trouve_poss_dans_liste_khan(_,[],D,P):- write('Choix erronnee'),nl,choose_place(D,P,LP),!.

trouve_poss_dans_liste_khan(1,[[X,Y]|_],D,'O'):-ecrire_dam('pO',X,Y,D,ND),retract(damier(D)), asserta(damier(ND)),!. %% repartir dans le tour

trouve_poss_dans_liste_khan(1,[[X,Y]|_],D,'R'):-ecrire_dam('pR',X,Y,D,ND),retract(damier(D)), asserta(damier(ND)),!. %% repartir dans le tour
trouve_poss_dans_liste_khan(C,[T|Q],D,P):- Cres is C-1, trouve_poss_dans_liste_khan(Cres,Q,D,P).

affiche_ligne_mod([],_,_,_):-!.
affiche_ligne_mod([T|Q],N,D,P):-write(N),write(' : '),write(T),nl,Nres is N+1,affiche_ligne_mod(Q,Nres,D,P). % N c'est juste un compteur d'affichage
trouve_toute_case(D,P,Liste_Poss,K):-bagof([X,Y],trouve_case(D,X,Y,K,[]),Temp), retire_last_elem(Temp,Liste_Poss),affiche_console(_),
	write('Choisis:'),nl, affiche_ligne_mod(Liste_Poss,1,D,P),read(C), trouve_poss_dans_liste_khan(C,Liste_Poss,D,P),!.

choose_place(D,P,Liste_Poss):-khan(0),write('Non positionne, un joueur lambda ne peut voir ça'),nl,trouve_toute_case(D,P,Liste_Poss,2),!. % servira pas In game, juste pour les test
choose_place(D,P,Liste_Poss):-khan(K),write(K),nl,trouve_toute_case(D,P,Liste_Poss,K).                 % setof de recup case arité khan, et []


action(D,P,2,Size):- Size<6,write('Posez votre pion sur la case d arité du khan:'),choose_place(D,P,Result),!.
% si il prefere deplacer on met le khan a 0 et le joueur retourne dans la boucle de jeu
action(D,P,1,Size):- write('Joue'), retract(khan(K)), asserta(khan(0)),tourH(P),!. 
action(D,P,_,_):- write('Erreur lors de la saisie'),nl,choixAction(D,P).


choixAction(D,P):- allPeices(P,D,1,1,LP,0), compte(LP,0,Size), Size>6, write('Vous etes bloque, que voulez vous faire?'),nl,
write('1: Jouer n importe quelle piece?'),nl,read(C), action(D,P,C,Size).

choixAction(D,P):- allPeices(P,D,1,1,LP,0), compte(LP,0,Size), Size<6, write('Vous etes bloque, que voulez vous faire?'),nl,
write('1: Jouer n importe quelle piece?'), nl, write('2 : Ajouter un pion? '),nl,read(C), action(D,P,C,Size).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TOUR HUMAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



tourH(P):- damier(D),khan(Ar), possibleMoves(D,P,[],Ar), choixAction(D,P),!. % Il peut y avoir que une simple liste je sais pas pourquoi, mieux vaut surcharger c est plus simple.

tourH(P):- damier(D),khan(Ar), possibleMoves(D,P,[[]],Ar), choixAction(D,P),!.

tourH(P):- damier(D),khan(Ar), possibleMoves(D,P,Result,Ar),modeH_choix(P,D,Result,[X1,Y1],Arrive), modif_damier(X1,Y1,Arrive,P,D,Temp2),
efface_pion(X1,Y1,Ligne,New_ligne,Temp2,ND),retract(damier(D)), asserta(damier(ND)),!.

kalista('R',Liste_Poss,D):- bagof([X,Y,A],trouve_case(D,X,Y,A,'kR'),Temp), retire_last_elem(Temp,Liste_Poss). %ici je suis obligé de recuperer l arité dans le bagof, car je n ai pas donné une arrité et le bagog ne fonctionnais pas
kalista('O',Liste_Poss,D):- bagof([X,Y,A],trouve_case(D,X,Y,A,'kO'),Temp), retire_last_elem(Temp,Liste_Poss).
big_tourH_vs_H('O'):- damier(D), kalista('O',[],D), write('le joueur Rouge gagne'),nl,!.
big_tourH_vs_H('R'):- damier(D), kalista('R',[],D), write('le joueur Ocre gagne'),nl,!.
big_tourH_vs_H('O'):- damier(D), tourH('O'), big_tourH_vs_H('R').
big_tourH_vs_H('R'):- damier(D), tourH('R'), big_tourH_vs_H('O').

jeuH_vs_H(P):- initBoard('R'),initBoard('O'),big_tourH_vs_H('R').





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THE AI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% le but de l IA est qu elle choisisse le meilleur coup possible, parmis la liste retournee par possible moves



% NOTRE STRAT POUR L IA

% 1. si la kalista ennemie est mangeable, -> le faire 
% 2. si notre Kal est menacée : manger le pion menacant ou, si pas possible, bouger la kal
% 3. si on a un pion sorti, le rajouter le plus pres possible de la kal ennemie.
% 4. Sinon rapprocher le pion le plus pres de la kal ennemie, de la kal ennemie.



%trouve le pion le plus proche de la kalista ennemie en distance, si 2 pion a meme distance on prend celui avec la plus grande arité
p_plus_proche([[[X,Y],Liste_coup]|[]],Distance,[X,Y],Liste_coup,[Xk,Yk]):- Distance is abs(Xk-X)+abs(Yk-Y),!.
p_plus_proche([[[NX,NY],NListe_coup]|Ql],RDistance,[X,Y],Liste_coup,[Xk,Yk]):- damier(D),p_plus_proche(Ql,Rdistance,[X,Y],Liste_coup,[Xk,Yk]),Distance is abs(Xk-NX)+abs(Yk-NY),Rdistance=Distance,find_case(D,X,Y,[Ar,_]),find_case(D,NX,NY,[Nar,_]),Nar<Ar,!. % ligne si jamais meme dstance mais arrité supérieur
p_plus_proche([[[NX,NY],NListe_coup]|Ql],Distance,[NX,NY],NListe_coup,[Xk,Yk]):- p_plus_proche(Ql,Rdistance,[X,Y],Liste_coup,[Xk,Yk]),Rdistance>=abs(Xk-NX)+abs(Yk-NY),Distance is abs(Xk-NX)+abs(Yk-NY),!.
p_plus_proche([[[X,Y],Liste_coup]|Ql],Distance,Pion,Liste_Poss,[Xk,Yk]):- p_plus_proche(Ql,Distance,Pion,Liste_Poss,[Xk,Yk]),!.


% trouve le coup le plus proche, en donnant le pion le plus proche en parametre 
coup_plus_proche([[X,Y]|[]],Distance,[X,Y],[Xk,Yk]):- Distance is abs(Xk-X)+abs(Yk-Y),!.

coup_plus_proche([[NX,NY]|Q],Distance,[NX,NY],[Xk,Yk]):- coup_plus_proche(Q,Rdistance,[X,Y],[Xk,Yk]), Rdistance>abs(Xk-NX)+abs(Yk-NY),Distance is abs(Xk-NX)+abs(Yk-NY),!.
coup_plus_proche([[X,Y]|Q],Distance,Coup,[Xk,Yk]):- coup_plus_proche(Q,Distance,Coup,[Xk,Yk]),!.



% verifie que la kalista n'est pas mangeable directement et surtout si le deplacement que l'on va faire ne va pas causer la mort de notre kalista
check_no_direct_eat('O',D,[[X,Y]|_],[X,Y]):- find_case(D,X,Y,[Ar,_]), possibleMoves(D,'R',ListDplEnnemi,Ar), \+piece_in([X,Y],ListDplEnnemi,_),!.
check_no_direct_eat('O',D,[T|Q],Dpl_kali):- check_no_risk('O',D,Q,Dpl_kali).


check_no_direct_eat('R',D,[[X,Y]|_],[X,Y]):- find_case(D,X,Y,[Ar,_]), possibleMoves(D,'O',ListDplEnnemi,Ar), \+piece_in([X,Y],ListDplEnnemi,_),!.
check_no_direct_eat('R',D,[T|Q],Dpl_kali):- check_no_risk('R',D,Q,Dpl_kali).


%verifie si la piece ou va arriver le pion n'est pas risqué (sert pour la kalista)
check_no_risk('O',D,[[X,Y]|_],[X,Y]):- find_case(D,X,Y,[Ar,_]), possibleMoves(D,'R',ListDplEnnemi,0), \+piece_in([X,Y],ListDplEnnemi,_),!.
check_no_risk('O',D,[T|Q],Dpl_kali):- check_no_risk('O',D,Q,Dpl_kali).


check_no_risk('R',D,[[X,Y]|_],[X,Y]):- find_case(D,X,Y,[Ar,_]), possibleMoves(D,'O',ListDplEnnemi,0), \+piece_in([X,Y],ListDplEnnemi,_),!.
check_no_risk('R',D,[T|Q],Dpl_kali):- check_no_risk('R',D,Q,Dpl_kali).


% arg1: coordonné piece a check si dans zone de damage ennemi, arg2: liste possible moves, arg3: le pion ennemi qui peut nous prendre la piece entrée en arg1.

piece_in(Piece, [], []):-fail,!.
piece_in(Piece,[[Pion,Liste_coup]|_],Pion):- element(Piece,Liste_coup),!.
piece_in(Piece,[[Pion,Liste_coup]|Ql],Poss_Pion):- piece_in(Piece,Ql,Poss_Pion).



% liste de generate move, toutes les stratégie différente en fonction de l'etat du jeu

%si kalista mangeable, Damier,Joueur,Liste de mouvement possible, Nouveau damier
generateMove(D,'R',Liste_de_dep,ND):- kalista('O',[[X,Y,A]|_],D), piece_in([X,Y],Liste_de_dep,[X1,Y1]), modif_damier(X1,Y1,[X,Y],'R',D,Temp2), efface_pion(X1,Y1,Ligne,New_ligne,Temp2,ND),!.
generateMove(D,'O',Liste_de_dep,ND):- kalista('R',[[X,Y,A]|_],D), piece_in([X,Y],Liste_de_dep,[X1,Y1]), modif_damier(X1,Y1,[X,Y],'O',D,Temp2), efface_pion(X1,Y1,Ligne,New_ligne,Temp2,ND),!.


%sinon on check si on peut se faire prendre sa kalista, et si c est le cas on la deplace ou on bouffe le pion qui peut nous la prendre (si possible)
% ici on suppose qu il n y a qu un seul pion ennemi pouvant prendre notre kalista. Sinon, n ayant qu un seul coup, on ne peut faire autrement que de perdre.


%stratégie si la kalista est en danger mais on peut manger la piece qui la met en danger
generateMove(D,'O',Liste_de_dep,ND):- khan(Ar), possibleMoves(D,'R',ListDplEnnemi,0), kalista('O',[[X,Y,A]|Q],D), piece_in([X,Y],ListDplEnnemi,[X1,Y1]),
										piece_in([X1,Y1],Liste_de_dep,[X2,Y2]), modif_damier(X2,Y2,[X1,Y1],'O',D,Temp2), efface_pion(X2,Y2,Ligne,New_ligne,Temp2,ND),!.
generateMove(D,'R',Liste_de_dep,ND):- khan(Ar), possibleMoves(D,'O',ListDplEnnemi,0), kalista('R',[[X,Y,A]|Q],D), piece_in([X,Y],ListDplEnnemi,[X1,Y1]),
										 piece_in([X1,Y1],Liste_de_dep,[X2,Y2]), modif_damier(X2,Y2,[X1,Y1],'R',D,Temp2), efface_pion(X2,Y2,Ligne,New_ligne,Temp2,ND),!.

%stratégie si kalista est en danger et on peut la bouger -> alors on la deplace vers une case non menacé 
generateMove(D,'O',Liste_de_dep,ND):- khan(Ar), possibleMoves(D,'R',ListDplEnnemi,0), kalista('O',[[X,Y,A]|Q],D),Ar=A, piece_in([X,Y],ListDplEnnemi,[X1,Y1]), sim_depl('O',D,X,Y,Liste_dpl_kali,Ar), efface_pion(X,Y,Ligne,New_ligne,D,Damier_temp)
		,check_no_risk('O',Damier_temp,Liste_dpl_kali,Dpl_kali), modif_damier(X,Y,Dpl_kali,'O',D,Temp2), efface_pion(X,Y,Ligne,New_ligne,Temp2,ND),!.
generateMove(D,'R',Liste_de_dep,ND):- khan(Ar), possibleMoves(D,'O',ListDplEnnemi,0), kalista('R',[[X,Y,A]|Q],D),Ar=A, piece_in([X,Y],ListDplEnnemi,[X1,Y1]), sim_depl('R',D,X,Y,Liste_dpl_kali,Ar), efface_pion(X,Y,Ligne,New_ligne,D,Damier_temp)
		,check_no_risk('R',Damier_temp,Liste_dpl_kali,Dpl_kali),Dpl_kali\=[], modif_damier(X,Y,Dpl_kali,'R',D,Temp2), efface_pion(X,Y,Ligne,New_ligne,Temp2,ND),!.
%stratégie si kalista est en danger et on peut la bouger et il n'y as pas de case non menacé -> alors on la deplace vers une case qui n'est pas directement prise avec le nouveau khan
generateMove(D,'O',Liste_de_dep,ND):- khan(Ar), possibleMoves(D,'R',ListDplEnnemi,0), kalista('O',[[X,Y,A]|Q],D),Ar=A, piece_in([X,Y],ListDplEnnemi,[X1,Y1]), sim_depl('O',D,X,Y,Liste_dpl_kali,Ar), efface_pion(X,Y,Ligne,New_ligne,D,Damier_temp)
		,check_no_direct_eat('O',Damier_temp,Liste_dpl_kali,Dpl_kali),Dpl_kali\=[],modif_damier(X,Y,Dpl_kali,'O',D,Temp2), efface_pion(X,Y,Ligne,New_ligne,Temp2,ND),!.
generateMove(D,'R',Liste_de_dep,ND):- khan(Ar), possibleMoves(D,'O',ListDplEnnemi,0), kalista('R',[[X,Y,A]|Q],D),Ar=A, piece_in([X,Y],ListDplEnnemi,[X1,Y1]), sim_depl('R',D,X,Y,Liste_dpl_kali,Ar), efface_pion(X,Y,Ligne,New_ligne,D,Damier_temp)
		,check_no_direct_eat('R',Damier_temp,Liste_dpl_kali,Dpl_kali),Dpl_kali\=[],modif_damier(X,Y,Dpl_kali,'R',D,Temp2), efface_pion(X,Y,Ligne,New_ligne,Temp2,ND),!.
%si aucune case n'est viable random moove
generateMove(D,'O',Liste_de_dep,ND):- khan(Ar), possibleMoves(D,'R',ListDplEnnemi,0), kalista('O',[[X,Y,A]|Q],D),Ar=A, piece_in([X,Y],ListDplEnnemi,[X1,Y1]), sim_depl('O',D,X,Y,Liste_dpl_kali,Ar), efface_pion(X,Y,Ligne,New_ligne,D,Damier_temp)
		,check_no_direct_eat('O',Damier_temp,Liste_dpl_kali,Dpl_kali),Dpl_kali\=[],modif_damier(X,Y,Dpl_kali,'O',D,Temp2), efface_pion(X,Y,Ligne,New_ligne,Temp2,ND),!.
generateMove(D,'R',Liste_de_dep,ND):- khan(Ar), possibleMoves(D,'O',ListDplEnnemi,0), kalista('R',[[X,Y,A]|Q],D),Ar=A, piece_in([X,Y],ListDplEnnemi,[X1,Y1]), sim_depl('R',D,X,Y,[Dpl_kali|_],Ar), efface_pion(X,Y,Ligne,New_ligne,D,Damier_temp)
		,modif_damier(X,Y,Dpl_kali,'R',D,Temp2), efface_pion(X,Y,Ligne,New_ligne,Temp2,ND),!.
		

%si jamais on peut manger direct la kali
generateMove(D,'R',[],ND):- possibleMoves(D,'R',Liste_all_dep,0), kalista('O',[[X,Y,A]|_],D), piece_in([X,Y],Liste_all_dep,[X1,Y1]), modif_damier(X1,Y1,[X,Y],'R',D,Temp2), efface_pion(X1,Y1,Ligne,New_ligne,Temp2,ND),!.
generateMove(D,'O',[],ND):- possibleMoves(D,'O',Liste_all_dep,0), kalista('R',[[X,Y,A]|_],D), piece_in([X,Y],Liste_all_dep,[X1,Y1]), modif_damier(X1,Y1,[X,Y],'O',D,Temp2), efface_pion(X1,Y1,Ligne,New_ligne,Temp2,ND),!.



% SI jamais le coup intelligent marche pas on pause au plus pret (parfois meme trop)
generateMove(D,'O',[],ND):-khan(Khan),allPeices('O',D,1,1,LP,0), compte(LP,0,Size), Size<6,  kalista('R',[[Xk,Yk,_]|_],D),bagof([X,Y],trouve_case(D,X,Y,Khan,[]),Temp), retire_last_elem(Temp,Liste_Poss)
			,coup_plus_proche(Liste_Poss,Distance,[Xc,Yc],[Xk,Yk]),ecrire_dam('pO',Xc,Yc,D,ND),!.
generateMove(D,'R',[],ND):-khan(Khan),allPeices('R',D,1,1,LP,0), compte(LP,0,Size), Size<6,  kalista('O',[[Xk,Yk,_]|_],D),bagof([X,Y],trouve_case(D,X,Y,Khan,[]),Temp), retire_last_elem(Temp,Liste_Poss)
			,coup_plus_proche(Liste_Poss,Distance,[Xc,Yc],[Xk,Yk]),ecrire_dam('pR',Xc,Yc,D,ND),!.
%si jamais on peut pas poser
generateMove(D,'O',[],ND):- possibleMoves(D,'O',Liste_all_dep,0), kalista('R',[[X,Y,_]|_],D),p_plus_proche(Liste_all_dep,Ndist,[Xp,Yp],Liste_coup,[X,Y]),coup_plus_proche(Liste_coup,Distance,Coup,[X,Y]),
			 modif_damier(Xp,Yp,Coup,'O',D,Temp2), efface_pion(Xp,Yp,Ligne,New_ligne,Temp2,ND),!.
generateMove(D,'R',[],ND):- possibleMoves(D,'R',Liste_all_dep,0), kalista('O',[[X,Y,_]|_],D),p_plus_proche(Liste_all_dep,Ndist,[Xp,Yp],Liste_coup,[X,Y]),coup_plus_proche(Liste_coup,Distance,Coup,[X,Y]),
			 modif_damier(Xp,Yp,Coup,'R',D,Temp2), efface_pion(Xp,Yp,Ligne,New_ligne,Temp2,ND),!.

% dernier cas, si les autres generateMove n ont pas ete realises, on rapprohe le pion le plus pres de la kalista ennemie, de la kalista ennemie.
%stratégie si pas de danger
generateMove(D,'O',Liste_de_dep,ND):- khan(Ar), kalista('R',[[X,Y,_]|_],D),p_plus_proche(Liste_de_dep,Ndist,[Xp,Yp],Liste_coup,[X,Y]),coup_plus_proche(Liste_coup,Distance,Coup,[X,Y]),
			 modif_damier(Xp,Yp,Coup,'O',D,Temp2), efface_pion(Xp,Yp,Ligne,New_ligne,Temp2,ND),!.
generateMove(D,'R',Liste_de_dep,ND):- khan(Ar), kalista('O',[[X,Y,_]|_],D),p_plus_proche(Liste_de_dep,Ndist,[Xp,Yp],Liste_coup,[X,Y]),coup_plus_proche(Liste_coup,Distance,Coup,[X,Y]),
			 modif_damier(Xp,Yp,Coup,'R',D,Temp2), efface_pion(Xp,Yp,Ligne,New_ligne,Temp2,ND),!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Tour d'IA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


tourIA(D,J):- khan(Ar),possibleMoves(D,J,Liste_de_dep,Ar), generateMove(D,J,Liste_de_dep,ND), retract(damier(D)), asserta(damier(ND)), affiche_console(_) ,!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% IA VS Humain %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


big_tourIA_vs_H('O'):- damier(D), kalista('O',[],D), write('le joueur Rouge gagne'),nl,!.
big_tourIA_vs_H('R'):- damier(D), kalista('R',[],D), write('le joueur Ocre gagne'),nl,!.
big_tourIA_vs_H('O'):- write('Tour O'),khan(K),nl,write('Position du khan:'),write(K),nl,damier(D), tourIA(D,'O'), big_tourIA_vs_H('R').
big_tourIA_vs_H('R'):- write('Tour R'),khan(K),nl,write('Position du khan:'),write(K),nl,damier(D), tourH('R'), big_tourIA_vs_H('O').


jeuIA_vs_H(P):- initBoard('R'),initBoardIA('O'),write('Damien avant 1er tour:'),nl,affiche_console(_),big_tourIA_vs_H('R').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% IA VS IA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

big_tourIA_vs_IA('O'):- damier(D), kalista('O',[],D), write('le joueur Rouge gagne'),nl,!.
big_tourIA_vs_IA('R'):- damier(D), kalista('R',[],D), write('le joueur Ocre gagne'),nl,!.
big_tourIA_vs_IA('O'):- write('Tour 0'),khan(K),nl,write('Position du khan:'),write(K),nl,damier(D), tourIA(D,'O'), big_tourIA_vs_IA('R').
big_tourIA_vs_IA('R'):- write('Tour R'),khan(K),nl,write('Position du khan:'),write(K),nl,damier(D), tourIA(D,'R'), big_tourIA_vs_IA('O').


jeuIA_vs_IA(P):- initBoardIA('R'),initBoardIA('O'),write('Damien avant 1er tour:'),nl,affiche_console(_),big_tourIA_vs_IA('R').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LANCEMENT DU JEU ET MENU %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

menu:- write('1. Player VS Player'),nl,
write('2. Player VS IA'),nl,
write('3. IA VS IA'),nl,
write('Entrez un choix'), nl, read(C), appel(C),!.

appel(1):-jeuH_vs_H(P),!.


appel(2):-jeuIA_vs_H(P),!.

appel(3):-jeuIA_vs_IA(P),!.
appel(_):- write('Erreur entrée incorrect'),nl,boucle_menu.



boucle_menu:- repeat, menu,!.

jeu_khan:- boucle_menu.

