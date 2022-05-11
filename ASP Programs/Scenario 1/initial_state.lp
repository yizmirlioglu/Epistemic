
% Initial State


world(s).  world(u).  world(v).

actual(s).


valuation(s,normal).   valuation(s,sound).  

valuation(u,normal). 


access(a,s,u).    access(a,s,v). 

access(b,s,s). 





% Goal condition

goal(and(b(a,normal),neg(b(a,neg(normal))))).

goal(b(b,normal)).
