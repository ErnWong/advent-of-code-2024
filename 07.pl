:- set_prolog_flag(double_quotes, codes).  % This is for SWI 7+ to revert to the prior interpretation of quoted strings.
:- use_module(library(dcg/basics)).
:- use_module(library(lists)).

% Grammar to parse the input.
equations([[O, Is]]) --> equation(O, Is).
equations([[O, Is] | Es]) --> equation(O, Is), "\n", equations(Es).
equation(O, Is) --> integer(O), ": ", inputs(Is).
inputs([X]) --> integer(X).
inputs([X | [Y | Ys]]) --> integer(X), " ", inputs([Y | Ys]).

% Values resulting from all possible combination of operators.
% Note: Inputs list is reversed
calculation(_, [I], I).
calculation(Part, [I | Is], Result) :- calculation(Part, Is, SubResult), Result is SubResult + I.
calculation(Part, [I | Is], Result) :- calculation(Part, Is, SubResult), Result is SubResult * I.
calculation(partB, [I | Is], Result) :- calculation(partB, Is, SubResult), Result is SubResult * 10 ** floor(log10(I) + 1) + I.

valid_equation(Part, [O, Is]) :- reverse(Is, RIs), calculation(Part, RIs, O).
valid_equations(Part, Equations, ValidEquations) :- include(valid_equation(Part), Equations, ValidEquations).
get_output([O, _], O).

solution(Part, Equations, Sum) :-
    valid_equations(Part, Equations, ValidEquations),
    maplist(get_output, ValidEquations, ValidOutputs),
    sumlist(ValidOutputs, Sum).

example(
"190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20").

partAExample :-
    example(Input),
    phrase(equations(Equations), Input),
    solution(partA, Equations, 3749).

partBExample :-
    example(Input),
    phrase(equations(Equations), Input),
    solution(partB, Equations, 11387).

:- phrase_from_file(equations(Equations), "07.txt"), solution(partA, Equations, Answer), write(Answer), write('\n').
:- phrase_from_file(equations(Equations), "07.txt"), solution(partB, Equations, Answer), write(Answer).
