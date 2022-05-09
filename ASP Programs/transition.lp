

% ASP Program for State Transition for Multi-agent Epistemic Domains



% Find fluents, literals and belief formulae from the given domain description

literal(F) :- fluent(F).
literal(neg(F)) :- fluent(F).
formula(F) :- literal(F).

formula(F) :- executable(ACT, F).
formula(F) :- observes(AG, ACT, F).
formula(F) :- aware_of(AG, ACT, F).
formula(F1) :- causes(ACT, F1, F2).
formula(F2) :- causes(ACT, F1, F2).
formula(F) :- goal(F).

formula(FL) :- valuation(U,FL).
formula(FL) :- determines(ACT,FL).
formula(FL) :- announces(ACT,FL).

formula(F1) :- formula(and(F1,F2)).
formula(F2) :- formula(and(F1,F2)).

formula(F1) :- formula(or(F1,F2)).
formula(F2) :- formula(or(F1,F2)).

formula(F) :- formula(neg(F)).

formula(F) :- formula(b(A,F)).
formula(F) :- formula(c(G,F)).

formula(F) :- formula_full(AG,ACT,F).
formula(F) :- formula_partial(AG,ACT,F).

formula(top).
formula(bottom).





% Parse fluents and literals in precondition (\psi) and observability (\delta_{i,a} and \theta_{i,a})
% These literals will be used in belief correction

cond(ACT,F) :- causes(ACT,E,F).

executable_formula(ACT,F) :- executable(ACT,F).

executable_formula(ACT,F2) :- executable_formula(ACT,and(F1,F2)), literal(F1).

precond_literals(ACT,F) :- executable_formula(ACT,F), literal(F).

precond_literals(ACT,F1) :- executable_formula(ACT,and(F1,F2)), literal(F1).



full_observability_formula(AG,ACT,F) :- observes(AG,ACT,F).

full_observability_formula(AG,ACT,F2) :- full_observability_formula(AG,ACT,and(F1,F2)), literal(F1).

full_literals(AG,ACT,F) :- full_observability_formula(AG,ACT,F), literal(F).

full_literals(AG,ACT,F1) :- full_observability_formula(AG,ACT,and(F1,F2)), literal(F1).



partial_observability_formula(AG,ACT,F) :- aware_of(AG,ACT,F).

partial_observability_formula(AG,ACT,F2) :- partial_observability_formula(AG,ACT,and(F1,F2)), literal(F1).

partial_literals(AG,ACT,F) :- partial_observability_formula(AG,ACT,F), literal(F).

partial_literals(AG,ACT,F1) :- partial_observability_formula(AG,ACT,and(F1,F2)), literal(F1).







% Entailment of Belief Formulae at the initial state

entails(U,top) :- world(U).

not_entails(U,bottom) :- world(U).

entails(U,F) :- world(U), valuation(U,F), fluent(F).

entails(U,neg(F)) :- world(U), not valuation(U,F), fluent(F).

entails(U,and(F1,F2)) :- world(U), entails(U,F1), entails(U,F2), formula(and(F1,F2)).

entails(U,or(F1,F2)) :- world(U), entails(U,F1), formula(or(F1,F2)).

entails(U,or(F1,F2)) :- world(U), entails(U,F2), formula(or(F1,F2)).

entails(U,neg(F)) :- world(U), not entails(U,F), formula(neg(F)).

not_entails(U,b(AG,F)) :- world(U), access(AG,U,V), not entails(V,F), formula(b(AG,F)).

entails(U,b(AG,F)) :- not not_entails(U,b(AG,F)), world(U), formula(b(AG,F)).


reachable(G,U,V) :- access(AG,U,V), agent_set(G), contains(G,AG), formula(c(G,F)).

reachable(G,U,W) :- reachable(G,U,V), access(AG,V,W), agent_set(G), contains(G,AG), formula(c(G,F)).

not_entails(U,c(G,F)) :- world(U), not entails(U,F), formula(c(G,F)).

not_entails(U,c(G,F)) :- world(U), reachable(G,U,V), not entails(V,F), formula(c(G,F)).

entails(U,c(G,F)) :- world(U), not not_entails(U,c(G,F)), formula(c(G,F)).





% The formula (\psi \and \delta_{i,a}) for full observer and the formula (\psi \and \theta_{i,a}) for partial observer

formula_full(AG,ACT,and(F1,F2)) :- executable(ACT,F1), observes(AG,ACT,F2), agent(AG).

formula_partial(AG,ACT,and(F1,F2)) :- executable(ACT,F1), aware_of(AG,ACT,F2), agent(AG).





% Compute agents' observability at each world

full_observer(AG,ACT,U) :- observes(AG,ACT,F), entails(U,F), world(U), occ(ACT).
full_observer(AG,ACT,U) :- observes(AG,ACT,top), world(U), occ(ACT).

partial_observer(AG,ACT,U) :- aware_of(AG,ACT,F), entails(U,F), world(U), occ(ACT).
partial_observer(AG,ACT,U) :- aware_of(AG,ACT,top), world(U), occ(ACT).

oblivious(AG,ACT,U) :- not full_observer(AG,ACT,U), not partial_observer(AG,ACT,U), world(U), agent(AG), occ(ACT).





% Check precondition of action at the actual world

pre_hold(S) :- actual(S), entails(S,F), executable(ACT,F), occ(ACT).





% The actual world in the next state

actual_next(prime(S)) :- pre_hold(S), actual(S), occ(ACT).




% Reachable worlds in the next state

world_next(prime(S)) :- pre_hold(S), actual(S), occ(ACT).

world_next(U) :- actual_next(S), access_next(AG,S,U).

world_next(V) :- world_next(U), access_next(AG,U,V).






% Check whether formula B_i(\psi \wedge \delta_{i,a}) holds at a world U

not_ontic_cond(AG,U) :- access(AG,U,V), entails(V,F), formula_full(AG,ACT,F), occ(ACT), action_type(ACT,ontic).







% Accessibility relations in the next state (M',s')  for an ontic action

% Full observers

access_next(AG,U,V) :- world_next(U), access(AG,U,V), occ(ACT).

access_next(AG,prime(S),prime(U)) :- pre_hold(S), actual(S), access(AG,S,U), full_observer(AG,ACT,S), entails(U,F), formula_full(AG,ACT,F), occ(ACT), action_type(ACT,ontic).

access_next(AG,prime(S),sub(U,AG)) :- pre_hold(S), actual(S), access(AG,S,U), full_observer(AG,ACT,S), not not_ontic_cond(AG,S), occ(ACT), action_type(ACT,ontic).

access_next(AG,prime(U),prime(V)) :- world_next(prime(U)), access(AG,U,V), full_observer(AG,ACT,U), entails(V,F), formula_full(AG,ACT,F), occ(ACT), action_type(ACT,ontic).

access_next(AG,prime(U),sub(V,AG)) :- world_next(prime(U)), access(AG,U,V), full_observer(AG,ACT,U), not not_ontic_cond(AG,U), occ(ACT), action_type(ACT,ontic).

access_next(AG1,sub(U,AG2),prime(V)) :- AG1!=AG2, world_next(sub(U,AG2)), access(AG1,U,V), full_observer(AG1,ACT,U), entails(V,F), formula_full(AG1,ACT,F), occ(ACT), action_type(ACT,ontic).

access_next(AG1,sub(U,AG2),sub(V,AG1)) :- AG1!=AG2, world_next(sub(U,AG2)), access(AG1,U,V), full_observer(AG1,ACT,U), not not_ontic_cond(AG1,U), occ(ACT), action_type(ACT,ontic).

access_next(AG,sub(U,AG),prime(V)) :- world_next(sub(U,AG)), access(AG,U,V), entails(V,F), formula_full(AG,ACT,F), occ(ACT), action_type(ACT,ontic).

access_next(AG,sub(U,AG),sub(V,AG)) :- world_next(sub(U,AG)), access(AG,U,V), not not_ontic_cond(AG,U), occ(ACT), action_type(ACT,ontic).





% Accessibility relations of Oblivious agents  for an ontic action

access_next(AG,prime(U),V) :- world_next(prime(U)), access(AG,U,V), oblivious(AG,ACT,U), occ(ACT), action_type(ACT,ontic).

access_next(AG1,sub(U,AG2),V) :- AG1!=AG2, world_next(sub(U,AG2)), access(AG1,U,V), oblivious(AG1,ACT,U), occ(ACT), action_type(ACT,ontic).






% Valuation of fluents in in the next state (ontic action)
% Valuation of u and u' worlds:

one_cond_satisfied(U) :- world(U), entails(U,F), cond(ACT,F), occ(ACT), action_type(ACT,ontic).

valuation_next(U,F) :- world(U), world_next(U), valuation(U,F), occ(ACT), action_type(ACT,ontic).

valuation_next(prime(U),E) :- world_next(prime(U)), entails(U,F), causes(ACT,E,F), fluent(E), occ(ACT), action_type(ACT,ontic).

valuation_next(prime(U),H) :- world_next(prime(U)), valuation(U,H), entails(U,F), cond(ACT,F), not causes(ACT,neg(H),F), fluent(H), occ(ACT), action_type(ACT,ontic).

valuation_next(prime(U),H) :- world_next(prime(U)), valuation(U,H), not one_cond_satisfied(U), occ(ACT), action_type(ACT,ontic).






% Valuation of u_{i} worlds:
% Compute \Lambda_{i,u} : Correction of fluents belonging to precondition and observability

lambda(sub(U,AG),H) :- world_next(sub(U,AG)), precond_literals(ACT,H), fluent(H), occ(ACT), action_type(ACT,ontic).

lambda(sub(U,AG),H) :- world_next(sub(U,AG)), full_literals(AG,ACT,H), fluent(H), occ(ACT), action_type(ACT,ontic).

lambda(sub(U,AG),H) :- world_next(sub(U,AG)), valuation(U,H), not precond_literals(ACT,neg(H)), not full_literals(AG,ACT,neg(H)), fluent(H), occ(ACT), action_type(ACT,ontic).






% Compute whether \Lambda_{i,u} entails any \mu condition among conditional effects (mu,varphi) of the action
% First find literals and subformulas in each of the formula \mu

cond_formula(ACT,F) :- causes(ACT,E,F).

cond_formula(ACT,F1) :- cond_formula(ACT,and(F1,F2)).
cond_formula(ACT,F2) :- cond_formula(ACT,and(F1,F2)).

cond_formula(ACT,F1) :- cond_formula(ACT,or(F1,F2)).
cond_formula(ACT,F2) :- cond_formula(ACT,or(F1,F2)).

cond_formula(ACT,F) :- cond_formula(ACT,neg(F)).

%cond_formula(ACT,F) :- cond_formula(ACT,b(A,F)).
%cond_formula(ACT,F) :- cond_formula(ACT,c(G,F)).





% Compute whether \Lambda_{i,u} entails \mu conditions among conditional effects of the ontic action

entails_lambda(sub(U,AG),H) :- world_next(sub(U,AG)), lambda(sub(U,AG),H).

entails_lambda(sub(U,AG),neg(H)) :- world_next(sub(U,AG)), not lambda(sub(U,AG),H), fluent(H).

entails_lambda(sub(U,AG),and(F1,F2)) :- entails_lambda(sub(U,AG),F1), entails_lambda(sub(U,AG),F2), cond_formula(ACT,and(F1,F2)), occ(ACT), action_type(ACT,ontic).

entails_lambda(sub(U,AG),or(F1,F2)) :- entails_lambda(sub(U,AG),F1), cond_formula(ACT,or(F1,F2)), occ(ACT), action_type(ACT,ontic).

entails_lambda(sub(U,AG),or(F1,F2)) :- entails_lambda(sub(U,AG),F2), cond_formula(ACT,or(F1,F2)), occ(ACT), action_type(ACT,ontic).

entails_lambda(sub(U,AG),neg(F)) :- not entails_lambda(sub(U,AG),F), world_next(sub(U,AG)), cond_formula(ACT,neg(F)), occ(ACT), action_type(ACT,ontic).





% Compute valuation of u_i worlds:
% Conditional effect of the action on u_i worlds:

one_cond_lambda_satisfied(sub(U,AG)) :- entails_lambda(sub(U,AG),F), cond(ACT,F), occ(ACT), action_type(ACT,ontic).

valuation_next(sub(U,AG),E) :- entails_lambda(sub(U,AG),F), causes(ACT,E,F), fluent(E), occ(ACT), action_type(ACT,ontic).

valuation_next(sub(U,AG),H) :- lambda(sub(U,AG),H), entails_lambda(sub(U,AG),F), cond(ACT,F), not causes(ACT,neg(H),F), fluent(H), occ(ACT), action_type(ACT,ontic).

valuation_next(sub(U,AG),H) :- lambda(sub(U,AG),H), not one_cond_lambda_satisfied(sub(U,AG)), occ(ACT), action_type(ACT,ontic).






%  Sensing/announcement Variables

varphi(ACT,FLT) :- determines(ACT,FLT), occ(ACT).
varphi(ACT,FLT) :- announces(ACT,FLT), occ(ACT).

action_type(ACT,sa) :- action_type(ACT,sensing).
action_type(ACT,sa) :- action_type(ACT,announce).




% Check whether sensing/announcement variables are the same across two worlds

var_diff(U,V) :- access(AG,U,V), valuation(U,F), not valuation(V,F), varphi(ACT,F), occ(ACT).

var_diff(U,V) :- access(AG,U,V), not valuation(U,F), valuation(V,F), varphi(ACT,F), occ(ACT).

var_diff(W,V) :- world_next(subf(U,AG2,W)), access(AG1,U,V), valuation(W,F), not valuation(V,F), varphi(ACT,F), occ(ACT).

var_diff(W,V) :- world_next(subf(U,AG2,W)), access(AG1,U,V), not valuation(W,F), valuation(V,F), varphi(ACT,F), occ(ACT).






% Check whether condition holds for sensing/announcement actions

not_sa_f_cond(AG,U) :- access(AG,U,V), entails(V,F), formula_full(AG,ACT,F), not var_diff(U,V), occ(ACT), action_type(ACT,sa).

not_sa_f_cond(AG1,U,W) :- AG1!=AG2, world_next(subf(U,AG2,W)), access(AG1,U,V), entails(V,F), formula_full(AG1,ACT,F), not var_diff(W,V), occ(ACT), action_type(ACT,sa).

not_sa_p_cond(AG,U) :- access(AG,U,V), entails(V,F), formula_partial(AG,ACT,F), occ(ACT), action_type(ACT,sa).








% Accessibility relations in the next state (M',s')  for a sensing/announcement action

% Full Observers

access_next(AG,prime(S),prime(U)) :- pre_hold(S), actual(S), access(AG,S,U), full_observer(AG,ACT,S), entails(U,F), formula_full(AG,ACT,F), not var_diff(S,U), occ(ACT), action_type(ACT,sa).

access_next(AG,prime(S),subf(U,AG,S)) :- pre_hold(S), actual(S), access(AG,S,U), full_observer(AG,ACT,S), not not_sa_f_cond(AG,S), occ(ACT), action_type(ACT,sa).

access_next(AG,prime(U),prime(V)) :- world_next(prime(U)), access(AG,U,V), full_observer(AG,ACT,U), entails(V,F), formula_full(AG,ACT,F), not var_diff(U,V), occ(ACT), action_type(ACT,sa).

access_next(AG,prime(U),subf(V,AG,U)) :- world_next(prime(U)), access(AG,U,V), full_observer(AG,ACT,U), not not_sa_f_cond(AG,U), occ(ACT), action_type(ACT,sa).

access_next(AG1,subp(U,AG2),prime(V)) :- AG1!=AG2, world_next(subp(U,AG2)), access(AG1,U,V), full_observer(AG1,ACT,U), entails(V,F), formula_full(AG1,ACT,F), not var_diff(U,V), occ(ACT), action_type(ACT,sa).

access_next(AG1,subp(U,AG2),subf(V,AG1,U)) :- AG1!=AG2, world_next(subp(U,AG2)), access(AG1,U,V), full_observer(AG1,ACT,U), not not_sa_f_cond(AG1,U), occ(ACT), action_type(ACT,sa).

access_next(AG1,subf(U,AG2,W),prime(V)) :- AG1!=AG2, world_next(subf(U,AG2,W)), access(AG1,U,V), full_observer(AG1,ACT,U), entails(V,F), formula_full(AG1,ACT,F), not var_diff(W,V), occ(ACT), action_type(ACT,sa).

access_next(AG1,subf(U,AG2,W),subf(V,AG1,W)) :- AG1!=AG2, world_next(subf(U,AG2,W)), access(AG1,U,V), full_observer(AG1,ACT,U), not not_sa_f_cond(AG1,U,W), occ(ACT), action_type(ACT,sa).

access_next(AG,subf(U,AG,W),prime(V)) :- world_next(subf(U,AG,W)), access(AG,U,V), entails(V,F), formula_full(AG,ACT,F), not var_diff(W,V), occ(ACT), action_type(ACT,sa).

access_next(AG,subf(U,AG,W),subf(V,AG,W)) :- world_next(subf(U,AG,W)), access(AG,U,V), not not_sa_f_cond(AG,U,W), occ(ACT), action_type(ACT,sa).



% Partial Observers

access_next(AG,prime(S),prime(U)) :- pre_hold(S), actual(S), access(AG,S,U), partial_observer(AG,ACT,S), entails(U,F), formula_partial(AG,ACT,F), occ(ACT), action_type(ACT,sa).

access_next(AG,prime(S),subp(U,AG)) :- pre_hold(S), actual(S), access(AG,S,U), partial_observer(AG,ACT,S), not not_sa_p_cond(AG,S), occ(ACT), action_type(ACT,sa).

access_next(AG,prime(U),prime(V)) :- world_next(prime(U)), access(AG,U,V), partial_observer(AG,ACT,U), entails(V,F), formula_partial(AG,ACT,F), occ(ACT), action_type(ACT,sa).

access_next(AG,prime(U),subp(V,AG)) :- world_next(prime(U)), access(AG,U,V), partial_observer(AG,ACT,U), not not_sa_p_cond(AG,U), occ(ACT), action_type(ACT,sa).

access_next(AG1,subp(U,AG2),prime(V)) :- AG1!=AG2, world_next(subp(U,AG2)), access(AG1,U,V), partial_observer(AG1,ACT,U), entails(V,F), formula_partial(AG1,ACT,F), occ(ACT), action_type(ACT,sa).

access_next(AG1,subp(U,AG2),subp(V,AG1)) :- AG1!=AG2, world_next(subp(U,AG2)), access(AG1,U,V), partial_observer(AG1,ACT,U), not not_sa_p_cond(AG1,U), occ(ACT), action_type(ACT,sa).

access_next(AG1,subf(U,AG2,W),prime(V)) :- AG1!=AG2, world_next(subf(U,AG2,W)), access(AG1,U,V), partial_observer(AG1,ACT,U), entails(V,F), formula_partial(AG1,ACT,F), occ(ACT), action_type(ACT,sa).

access_next(AG1,subf(U,AG2,W),subp(V,AG1)) :- AG1!=AG2, world_next(subf(U,AG2,W)), access(AG1,U,V), partial_observer(AG1,ACT,U), not not_sa_p_cond(AG1,U), occ(ACT), action_type(ACT,sa).

access_next(AG,subp(U,AG),prime(V)) :- world_next(subp(U,AG)), access(AG,U,V), entails(V,F), formula_partial(AG,ACT,F), occ(ACT), action_type(ACT,sa).

access_next(AG,subp(U,AG),subp(V,AG)) :- world_next(subp(U,AG)), access(AG,U,V), not not_sa_p_cond(AG,U), occ(ACT), action_type(ACT,sa).




% Accessibility relations of Oblivious agents

access_next(AG,prime(U),V) :- world_next(prime(U)), access(AG,U,V), oblivious(AG,ACT,U), occ(ACT), action_type(ACT,sa).

access_next(AG1,subp(U,AG2),V) :- AG1!=AG2, world_next(subp(U,AG2)), access(AG1,U,V), oblivious(AG1,ACT,U), occ(ACT), action_type(ACT,sa).

access_next(AG1,subf(U,AG2,W),V) :- AG1!=AG2, world_next(subf(U,AG2,W)), access(AG1,U,V), oblivious(AG1,ACT,U), occ(ACT), action_type(ACT,sa).





% Valuation of fluents in in the next state (for sensing/announcement action)

valuation_next(U,F) :- world(U), world_next(U), valuation(U,F), occ(ACT), action_type(ACT,sa).

valuation_next(prime(U),F) :- world_next(prime(U)), valuation(U,F), occ(ACT), action_type(ACT,sa).

valuation_next(subp(U,AG),H) :- world_next(subp(U,AG)), precond_literals(ACT,H), fluent(H), occ(ACT), action_type(ACT,sa).

valuation_next(subp(U,AG),H) :- world_next(subp(U,AG)), partial_literals(AG,ACT,H), fluent(H), occ(ACT), action_type(ACT,sa).

valuation_next(subp(U,AG),H) :- world_next(subp(U,AG)), valuation(U,H), not precond_literals(ACT,neg(H)), not partial_literals(AG,ACT,neg(H)), fluent(H), occ(ACT), action_type(ACT,sa).

valuation_next(subf(U,AG,W),H) :- world_next(subf(U,AG,W)), precond_literals(ACT,H), fluent(H), occ(ACT), action_type(ACT,sa).

valuation_next(subf(U,AG,W),H) :- world_next(subf(U,AG,W)), full_literals(AG,ACT,H), fluent(H), occ(ACT), action_type(ACT,sa).

valuation_next(subf(U,AG,W),F) :- world_next(subf(U,AG,W)), varphi(ACT,F), valuation(W,F), occ(ACT), action_type(ACT,sa).

valuation_next(subf(U,AG,W),H) :- world_next(subf(U,AG,W)), valuation(U,H), not precond_literals(ACT,neg(H)), not full_literals(AG,ACT,neg(H)), not varphi(ACT,H), fluent(H), occ(ACT), action_type(ACT,sa).






% Entailment of Belief Formulae at the next state

entails_next(U,top) :- world_next(U).

not_entails_next(U,bottom) :- world_next(U).

entails_next(U,F) :- world_next(U), valuation_next(U,F), fluent(F).

entails_next(U,neg(F)) :- world_next(U), not valuation_next(U,F), fluent(F).

entails_next(U,and(F1,F2)) :- world_next(U), entails_next(U,F1), entails_next(U,F2), formula(and(F1,F2)).

entails_next(U,or(F1,F2)) :- world_next(U), entails_next(U,F1), formula(or(F1,F2)).

entails_next(U,or(F1,F2)) :- world_next(U), entails_next(U,F2), formula(or(F1,F2)).

entails_next(U,neg(F)) :- world_next(U), not entails_next(U,F), formula(neg(F)).

not_entails_next(U,b(AG,F)) :- world_next(U), access_next(AG,U,V), not entails_next(V,F), formula(b(AG,F)).

entails_next(U,b(AG,F)) :- not not_entails_next(U,b(AG,F)), world_next(U), formula(b(AG,F)).


reachable_next(G,U,V) :- access_next(AG,U,V), agent_set(G), contains(G,AG), formula(c(G,F)).

reachable_next(G,U,W) :- reachable_next(G,U,V), access_next(AG,V,W), agent_set(G), contains(G,AG), formula(c(G,F)).

not_entails_next(U,c(G,F)) :- world_next(U), not entails_next(U,F), formula(c(G,F)).

not_entails_next(U,c(G,F)) :- world_next(U), reachable_next(G,U,V), not entails_next(V,F), formula(c(G,F)).

entails_next(U,c(G,F)) :- world_next(U), not not_entails_next(U,c(G,F)), formula(c(G,F)).





% Check Goal Condition at the next state

achieved(F) :- actual_next(prime(S)), entails_next(prime(S),F), goal(F).

not_all_achieved :- not achieved(F), goal(F).

allachieved :- not not_all_achieved.






#show actual_next/1.
#show world_next/1.
#show access_next/3.
#show valuation_next/2.
#show allachieved/0.
#show pre_hold/1.

