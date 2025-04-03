:- set_prolog_flag(double_quotes, chars).
:- use_module(library(dcgs)).
:- use_module(library(charsio)).
:- use_module(library(lists)).
:- use_module(library(clpz)).
:- use_module(library(debug)).
:- use_module('./nquad_terminal.pl').
:- use_module('./util.pl').

nquad_doc --> 
    optional(statement),
    chain_statement,
    optional(end_of_line) . 
nquad_doc --> "".

chain_statement --> 
    end_of_line,
    statement,
    chain_statement.
chain_statement --> "".

statement --> 
    statement(_Value_subject, _Value_predicate, _Value_object) | 
    statement(_Value_subject, _Value_predicate, _Value_object, _Value_graph) .

statement(Value_subject, Value_predicate, Value_object) --> 
    subject(Value_subject), 
    space, predicate(Value_predicate), 
    space, object(Value_object),
    optional(space), "." . 

statement(Value_subject, Value_predicate, Value_object, Value_graph) --> 
    subject(Value_subject),
    space,
    predicate(Value_predicate),
    space,
    object(Value_object),
    space,
    graph_label(Value_graph),
    optional(space) ,
    "." . 



subject(Value) --> 
    iri_ref(Value) | 
    blank_node_label(Value) .
predicate(Iri) --> iri_ref(Iri) .
object(Value) -->  
    iri_ref(Value) |
    blank_node_label(Value) |
    literal(Value) .
graph_label(Value) --> 
    iri_ref(Value) |
    blank_node_label(Value) .

iri_ref(Iri) --> 
    "<",
    iri(Iri),
    ">" .

iri([Iri0|Iri]) --> 
    [Iri0],
    { char_type(Iri0, alnum) },
    iri(Iri).
iri([]) --> [] .

blank_node_label(Label) --> 
    "_:",
    label(Label).


label([Label0|Label]) --> 
    [Label0],
    { char_type(Label0, alnum) },
    label(Label).
label([]) --> [] .

literal(Value, Datatype) --> 
    string_literal_quote(Value),
    optional("^^", iri(Datatype)).
literal(Value, Langtag) --> 
    string_literal_quote(Value),
    optional("^^", langtag(Langtag)).

string_literal_quote([Value0|Value]) --> 
    [Value0],
    { char_type(Value0, alnum) },
    string_literal_quote(Value).
string_literal_quote([]) --> [] .
