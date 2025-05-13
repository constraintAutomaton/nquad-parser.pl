:- set_prolog_flag(double_quotes, chars).
:- use_module(library(dcgs)).
:- use_module(library(debug)).
:- use_module(library(dif)).
:- use_module('./nquad_terminal.pl').
:- use_module('./util.pl').
:- use_module(library(reif)).

quad(_, _, _, _).
triple(S, P, O) :- quad(S, P, O, default_graph).

nquad_doc --> optional(statement(T)), optional(comment), zero_or_more((end_of_line, (statement | comment))), optional(end_of_line).

statement(T) --> 
    subject(S),
    optional(space),
    predicate(P),
    optional(space),
    object(O),
    optional(space),
    optional(graph_label(G)),
    optional(space),
    ".",
    optional(space),
    optional(comment),
    {
        if_(var(G), T=triple(S, P, O), T=quad(S, P, O, G))
    }.

subject(X) --> iri_ref(X) | blank_node_label(X) .

predicate(X) --> iri_ref(X) .

object(X) --> iri_ref(X) | blank_node_label(X) | literal(X) .

graph_label(X) --> iri_ref(X) | blank_node_label(X) .

literal(X) --> string_literal_quote(X).

comment(X) --> "#", [X].
    
iri_ref(X) --> 
    "<",
    [X],
    ">".

blank_node_label(X) --> "_:", [X] .

string_literal_quote(X) --> ['"'], [X], ['"'].
