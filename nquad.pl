:- set_prolog_flag(double_quotes, chars).
:- use_module(library(dcgs)).
:- use_module(library(charsio)).
:- use_module(library(lists)).
:- use_module(library(clpz)).

nquad_doc(Ls) --> statement


statement(Value_subject, Value_predicate, Value_object) --> subject(Value_subject), space, predicate(Value_predicate), space, object(Value_object), space_or_not, "." . 
statement(Value_subject, Value_predicate, Value_object, Value_graph) --> subject(Value_subject), space, predicate(Value_predicate), space, object(Value_object), space, graph_label(Value_graph), optional(space) , "." . 

space --> " " | "    ".

subject(Value) --> iri_ref(Value) | blank_node_label(Value) .
predicate(Iri) --> iri_ref(Iri) .
object(Value) -->  iri_ref(Value) | blank_node_label(Value) | literal(Value) .
graph_label(Value) --> iri_ref(Value) | blank_node_label(Value) .

iri_ref(Iri) --> "<", iri(Iri) , ">" .

iri([Iri0|Iri]) --> [Iri0],  { char_type(Iri0, alnum) }, iri(Iri).
iri([]) --> [] .

blank_node_label(Label) --> "_:", label(Label).


label([Label0|Label]) --> [Label0],  { char_type(Label0, alnum) }, label(Label).
label([]) --> [] .

literal([Value0|Value]) --> [Value0],  { char_type(Value0, alnum) }, literal(Value).
literal([]) --> [] .

optional(_) --> "".
optional(X) --> X.