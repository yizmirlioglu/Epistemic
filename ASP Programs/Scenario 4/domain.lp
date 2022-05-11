
% Example Domain Description (Coin in the box domain)


% Agents
agent(a).
agent(b).
agent(c).

agent_set(everyone).
contains(everyone,a).
contains(everyone,b).
contains(everyone,c).

agent_set(ab).
contains(ab,a).
contains(ab,b).


% Fluents

fluent(opened).
fluent(tail).
fluent(looking_a).
fluent(looking_b).
fluent(looking_c).
fluent(near_a).
fluent(near_b).
fluent(near_c).



% Action Description

action(open_box).
action(distract_c).
action(signal_b).
action(peek).
action(ann_coin).


action_type(open_box,ontic).
action_type(distract_c,ontic).
action_type(signal_b,ontic).
action_type(peek,sensing).
action_type(ann_coin,announce).


executable(open_box, neg(opened)).
observes(a,open_box,looking_a).
observes(b,open_box,looking_b).
observes(c,open_box,looking_c).
causes(open_box,opened,neg(opened)).


executable(distract_c, looking_c).
observes(a,distract_c,looking_a).
observes(b,distract_c,looking_b).
observes(c,distract_c,top).
causes(distract_c,neg(looking_c),looking_c).


executable(signal_b, neg(looking_b)).
observes(a,signal_b,looking_a).
observes(b,signal_b,top).
observes(c,signal_b,looking_c).
causes(signal_b,looking_b,neg(looking_b)).
causes(signal_b,near_b,neg(near_b)).


executable(peek,opened).
observes(a,peek,and(looking_a,near_a)).
observes(b,peek,and(looking_b,near_b)).
observes(c,peek,and(looking_c,near_c)).
aware_of(a,peek,and(looking_a,neg(near_a))).
aware_of(b,peek,and(looking_b,neg(near_b))).
aware_of(c,peek,and(looking_c,neg(near_c))).
determines(peek,tail).


executable(ann_coin,and(opened,or(b(a,tail),b(a,neg(tail))))).
observes(a,ann_coin,looking_a).
observes(b,ann_coin,looking_b).
observes(c,ann_coin,looking_c).   % and(looking_c,near_c)
aware_of(a,ann_coin,bottom).
aware_of(b,ann_coin,bottom).
aware_of(c,ann_coin,bottom).    % and(looking_c,neg(near_c))
announces(ann_coin,tail).



% Goal condition

goal(or(b(a,tail),b(a,neg(tail)))).

