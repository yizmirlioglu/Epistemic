# Epistemic
State Transition Function for Multi-Agent Epistemic Domains using ASP

This repository includes an Appendix which includes ASP rules for our state transition function and proof of theorems. The folder ASP_programs include ASP formulation of our state transition function for multi-agent epistemic domains, and some example scenarios. Each scenario involves a domain description, an initial state and the executed action.

To test a scenario, go to the directory and execute the command

clingo transition.lp domain.lp initial_state.lp action.lp


Requirements: ASP solver clingo 4.X or clingo 5.X must be installed
