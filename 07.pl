:- set_prolog_flag(double_quotes, codes).  % This is for SWI 7+ to revert to the prior interpretation of quoted strings.
:- use_module(library(dcg/basics)).
:- use_module(library(lists)).

% Grammar.
equation(O, Is) --> integer(O), ": ", inputs(Is).
inputs([X]) --> integer(X).
inputs([X | [Y | Ys]]) --> integer(X), " ", inputs([Y|Ys]).
equations([[O, Is]]) --> equation(O, Is).
equations([[O, Is] | Es]) --> equation(O, Is), "\n", equations(Es).

% Values resulting from all possible combination of operators.
% Note: Inputs list is reversed
calculation([I], I).
calculation([I | Is], Result) :- calculation(Is, SubResult), Result is I + SubResult.
calculation([I | Is], Result) :- calculation(Is, SubResult), Result is I * SubResult.

equation_possibly_valid([O, Is]) :- reverse(Is, RIs), calculation(RIs, O).
valid_equations(Equations, ValidEquations) :- include(equation_possibly_valid, Equations, ValidEquations).
get_output([O, _], O).

partA(Equations, Sum) :-
    valid_equations(Equations, ValidEquations),
    maplist(get_output, ValidEquations, ValidOutputs),
    sumlist(ValidOutputs, Sum).

partAExample :-
    phrase(equations(Equations), "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"),
    partA(Equations, 3749).

:- phrase_from_file(equations(Equations), "07.txt"), partA(Equations, Answer), write(Answer).
