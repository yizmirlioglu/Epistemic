
% Initial State


world(s).  world(u).

actual(s).


valuation(s,near_a).   valuation(s,near_b).   valuation(s,haskey_a).    

valuation(u,near_a).   valuation(u,haskey_a).    


access(a,s,s).

access(b,s,u).





% Goal condition

goal(b(open,open)).

goal(and(b(b,near_b),b(b,open))).

goal(c(everyone,open)).
