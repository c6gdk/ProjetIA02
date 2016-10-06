element(N,[],X):-fail,!.
element(1,[T|_],T).
element(N,[T|Q],X):- element(Nres,Q,X), N is Nres + 1.



retirer_el_x(X,[],[]):-!.
retirer_el_x(X,[X|Q],Q):-!.
retirer_el_x(X,[T|Q],[T|Ql]):- retirer_el_x(X,Q,Ql).

reti([],L,L):-!.
reti([T|Q],L,NL1):- reti(Q,L,NL),retirer_el_x(T,NL,NL1)  .