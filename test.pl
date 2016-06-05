
menu:- write('1. Player VS Player'),nl,
write('2. Player VS IA'),nl,
write('3. IA VS IA'),nl,
write('Entrez un choix'), nl, read(C), appel(C).

appel(1):-!.
appel(2):-!.
appel(3):-!.
appel(_):- write('Erreur entrée incorrect'),nl,boucle_menu.



boucle_menu:- repeat, menu,!.

jeu_khan:- boucle_menu.