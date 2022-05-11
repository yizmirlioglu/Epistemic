
% Initial State


world(s).  world(u).

actual(s).


valuation(s,normal).   valuation(s,sound).  

valuation(u,sound). 


access(a,s,u).    access(a,u,u). 

access(b,s,s).    access(b,u,u).





% Goal condition

goal(and(b(a,normal),neg(b(a,neg(normal))))).

goal(c(everyone,normal)).
