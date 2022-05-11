
% Example 2 in the paper (Domain Description)


% Agents
agent(a).
agent(b).



% Agent Set
agent_set(everyone).
contains(everyone,a).
contains(everyone,b).



% Fluents
fluent(normal).
fluent(sound).



% Action Description
action(check_voltage).

action_type(check_voltage,sensing).



executable(check_voltage,sound).
observes(a,check_voltage,top).
observes(b,check_voltage,top).
aware_of(a,check_voltage,bottom).
aware_of(b,check_voltage,bottom).
determines(check_voltage,normal).



