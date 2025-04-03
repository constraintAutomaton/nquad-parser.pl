:- set_prolog_flag(double_quotes, chars).
:- use_module(library(dcgs)).
:- use_module(library(charsio)).
:- use_module(library(lists)).
:- use_module(library(clpz)).
:- use_module(library(debug)).
:- use_module(library(when)).
:- use_module('./util.pl').

end_of_line_ --> "\n"|"\r" .
end_of_line --> end_of_line_ .
end_of_line --> end_of_line_, end_of_line.

space_ --> " " | "    ".
speace_ --> "   ".
space --> space_ .
space --> space_, space.

langtag --> "@", alphabetic_chain, optional(("-", alphanumeric_chain)) .


alphabetic_chain_ --> [X], { from_char_to(X, 65, 90); from_char_to(X, 97, 122) } .
alphabetic_chain --> alphabetic_chain_ .
alphabetic_chain --> alphabetic_chain_ , alphabetic_chain.

alphanumeric_chain_ --> [X], { from_char_to(X, 65, 90); from_char_to(X, 97, 122); from_char_to(X, 48, 57)} .
alphanumeric_chain --> alphanumeric_chain_ .
alphanumeric_chain --> alphanumeric_chain_, alphanumeric_chain .

from_char_to(Char, MinDec, MaxDec) :-
    when(
            (   
                nonvar(Char)
            ),
            (      
                X0 #>= MinDec,                   
                X0 #=< MaxDec,
                char_code(Char, X0)
            )
    ).
