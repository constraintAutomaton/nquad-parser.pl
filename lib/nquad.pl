:- set_prolog_flag(double_quotes, chars).
:- use_module(library(dcgs)).
:- use_module(library(debug)).
:- use_module(library(dif)).
:- use_module('./nquad_terminal.pl').
:- use_module('./util.pl').

nquad_doc --> optional(statement), zero_or_more((end_of_line, (statement | comment))), optional(end_of_line).

statement --> 
    subject,
    optional(space),
    predicate,
    optional(space),
    object,
    optional(space),
    optional(graph_label),
    optional(space),
    ".",
    optional(space),
    optional(comment).

subject --> iri_ref | blank_node_label .

predicate --> iri_ref .

object --> iri_ref | blank_node_label | literal .

graph_label --> iri_ref | blank_node_label .

literal --> string_literal_quote, optional((("^^", iri_ref)| langtag)) .

comment --> 
    "#", zero_or_more(comment_).
    

comment_ --> [X],
    {
        maplist(dif(X), ['\n', \r])
    }.