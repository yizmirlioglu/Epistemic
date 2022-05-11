
% Example 3 in the paper (Domain Description)


% Agents
agent(a).
agent(b).



% Agent Set
agent_set(everyone).
contains(everyone,a).
contains(everyone,b).



% Fluents
fluent(open).
fluent(near_a).
fluent(near_b).
fluent(haskey_a).
fluent(haskey_b).



% Action Description
action(open_door).

action_type(open_door,ontic).


executable(open_door,and(neg(opened),haskey_a)).
observes(a,open_door,near_a).
observes(b,open_door,near_b).
causes(open_door,open,neg(open)).


