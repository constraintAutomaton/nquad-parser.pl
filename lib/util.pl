:- use_module(library(between)).
:- use_module(library(dcgs)).
:- use_module(library(freeze)).

optional(X) --> X | [].

one_or_more(X) --> X | (X, one_or_more(X)).

zero_or_more(X) --> [] |(X, zero_or_more(X)).

unicode_char_between(Char, MinDec, MaxDec) :-
    freeze(Char, (between(MinDec, MaxDec, X), char_code(Char, X))).

unicode_char(Char, Dec) :- freeze(Char, char_code(Char, Dec)).