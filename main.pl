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
/*
%initBoard(Dam).

%controlleur().

%init_disposition().
%choix_mode().
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AFFICHAGE DU DAMIER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

affiche_console(_):- damier(X),affichage_dam(X).

affiche_case(Y):- write(Y), write('|').

affiche_ligne([]).
affiche_ligne([X|Y]):-affiche_case(X),affiche_ligne(Y).

affichage_dam([]).
affichage_dam([X|Y]):-affiche_ligne(X), nl,affichage_dam(Y).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% POSITIONNEMENT DE PION SUR LE DAMIER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tete(T, [T|_]).
queue(Q, [_|Q]).
vide([]).
vide([[]]).

elem2(T, L):- queue(Q, L), tete(T,Q).

concat([],L,L).
concat([X|Q],L,[X|R]):-concat(Q,L,R).

elemn(E,1,L):- tete(E,L).
elemn(E,N,L):- NN is N-1, queue(Q,L), elemn(E,NN,Q).

fin_list_n(L,1,QL):- queue(QL,L).									% on recup dans QL la fin(queue) de la liste L APRES le N-ieme element de la liste
fin_list_n(L,N,QL):- NN is N-1, queue(Q,L), fin_list_n(Q,NN,QL).

debut_list_n(L,1,[]).												% on recup dans le 3eme arg de debut de la liste L AVANT le N-ieme element
debut_list_n([T|Q],N,[T|R]):-  NN is N-1, debut_list_n(Q,NN,R).



recreate_list(RE,L,V,RL):- debut_list_n(L,V,DL), fin_list_n(L,V,FL),concat(DL,[RE|FL],RL).	% Prend le debut de la liste jusqu a un indice met le nouvel element a cet indice et met la 
																				% fin de la liste derière. CAD: insere RE en V dans la liste. 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



changeP(E,[T|'p']):- queue(RQ,E), vide(RQ),tete(T,E).

modif_line(V,L,LR):-elemn(E,V,L), changeP(E,RE), recreate_list(RE,L,V,LR). 

find_line(U,V,D,RD):- U=1, tete(L,D), modif_line(V,L,RL), recreate_list(RL,D,U,RD),!.
find_line(U,V,D,RD):- U=2, elem2(L,D) , modif_line(V,L,RL), recreate_list(RL,D,U,RD),!.

positionner(_):- damier(X), write('donnez la ligne et la case sur laquelle vous voulez mettre votre pion'), read(U), read(V), U =< 2, U > 0, V > 0, 
V =< 6, find_line(U,V,X,RD), retract(damier(X)), asserta(damier(RD)).



%%%%%%%%%%%%%%%%%%%%%%%%%% POSITIONNEMENT DE LA KALISTA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


changeK(E,[T|'K']):- queue(RQ,E), vide(RQ),tete(T,E).

modif_lineK(V,L,LR):-elemn(E,V,L), changeK(E,RE), recreate_list(RE,L,V,LR). 


find_lineK(U,V,D,RD):- U=1, tete(L,D), modif_lineK(V,L,RL), recreate_list(RL,D,U,RD),!.
find_lineK(U,V,D,RD):- U=2, elem2(L,D) , modif_lineK(V,L,RL), recreate_list(RL,D,U,RD),!.

positionnerK(_):- damier(X), write('donnez la ligne et la case sur laquelle vous voulez mettre votre pion'), read(U), read(V), U =< 2, U > 0, V > 0, V =< 6, find_lineK(U,V,X,RD), 
					retract(damier(X)), asserta(damier(RD)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SET DE L ENSEMBLE DES PION POUR UNE EQUIPE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


ajout_pion(0).
ajout_pion(I):- NI is i-1, positionner(_), ajout_pion(NI).

% si un pion est repositionne au meme endroit ca crash, gerer ce petit pb.
init_disposition(_):- I is 6, ajout_pion(I), positionnerK(_).

%%%%%%%%%%%%%%%%%%%%%%% CHOIX DU COTE DE DEPART %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



cote_init(_):- write('donnez votre cotez de depart: Nord N, Est E, Sud S Ouest O'),nl,read(X), choix_cote(X).

choix_cote(X):- X='n',!.
choix_cote(X):- X='e',damier(Y), damierE(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):- X='s',damier(Y), damierS(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):- X='o',damier(Y), damierO(Z), retract(damier(Y)), asserta(damier(Z)),!.
choix_cote(X):-cote_init(_).

% renverser renverse le tab dans le sens des aiguilles d une montre x fois
% on rempliera pour le joueur rouje toujours les deux lignes du haut du nouveau tab
% pour le joueur ocre, toujour les deux llignes du bas.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







recup_donne(...).


deplacement(D,X1, Y1, X2, Y2, ND):- calc_long(X1, Y1, X2, Y2, L), recup_donnee(X1, Y1, A, L), ,.


deplacer(_):- write('entrez la case de depart:'), nl, write('coordonne x1= '), read(X1),nl,X1>0,X1<7, write('coordonne y1= '), read(Y1),nl,Y1>0,Y1<7,
	write('entrez la case d arrivee:'), nl, write('coordonne x2= '), read(X2),nl,X2>0,X2<7, write('coordonne y2= '), read(Y2), nl,Y2>0,Y2<7,
	damier(D), deplacement(D,X1, Y1, X2, Y2, ND),retract(damier(D)), asserta(damier(ND)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/*
%affiche(A):- put_char('A').

%entrer_coup(). 
 

%khan().  dit ou est le khan

%pion_sorti().  dit combien de pions sont sorti pour un joueur



%position_case().
%valeur_case(X, ).



*/






















