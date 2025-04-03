:- use_module(library(between)).
:- use_module(library(dcgs)).

optional(_) --> "".
optional(X) --> X.


unicode_char_between(Char, MinDec, MaxDec) :-
    when(
            (   
                nonvar(Char)
            ),
            (      
                between(MinDec, MaxDec, X),
                char_code(Char, X)
            )
    ).
