% Loads the package loader
:- use_module(pkg).

% Loads a package. The argument should be an atom equal to the name of the
% dependency package specified in the `name/1` field of its manifest.
:- use_module(pkg(testing)).

:- use_module(library(pio)).

:- use_module('./prolog/nquad.pl').

% You can then use the predicates exported by the main file of the dependency
% in the rest of the program.

main :-
    % `run_tests/0` is exported by `pkg(testing)`
    run_tests,
    halt.

test("minimal_whitespace", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/minimal_whitespace.nq')))).
test("lantag_with_subtag", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/lantag_with_subtag.nq')))).
test("langtagged_string", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/langtagged_string.nq')))).
test("literal_with_numeric_escape8", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_numeric_escape8.nq')))).
test("literal_with_numeric_escape4", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_numeric_escape4.nq')))).
test("literal_with_REVERSE_SOLIDUS", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_REVERSE_SOLIDUS.nq')))).
test("literal_with_FORM_FEED", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_FORM_FEED.nq')))).
test("literal_with_CARRIAGE_RETURN", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_CARRIAGE_RETURN.nq')))).
test("literal_with_LINE_FEED", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_LINE_FEED.nq')))).
test("literal_with_BACKSPACE", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_BACKSPACE.nq')))).
test("literal_with_CHARACTER_TABULATION", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_CHARACTER_TABULATION.nq')))).
test("literal_with_REVERSE_SOLIDUS2", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_REVERSE_SOLIDUS2.nq')))).
test("literal_with_2_dquotes", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_2_dquotes.nq')))).
test("literal_with_dquote", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_dquote.nq')))).
test("literal", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal.nq')))).
test("literal_with_2_squotes", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_2_squotes.nq')))).
test("literal_with_squote", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_squote.nq')))).
test("literal_all_punctuation", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_all_punctuation.nq')))).
test("literal_all_controls", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_all_controls.nq')))).
test("literal_with_UTF8_boundaries", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_with_UTF8_boundaries.nq')))).
test("literal_ascii_boundaries", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/literal_ascii_boundaries.nq')))).
test("comment_following_triple", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/comment_following_triple.nq')))).
test("nt-syntax-subm-01", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-subm-01.nq')))).
test("nt-syntax-datatypes-02", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-datatypes-02.nq')))).
test("nt-syntax-datatypes-01", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-datatypes-01.nq')))).
test("nt-syntax-bnode-03", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bnode-03.nq')))).
test("nt-syntax-bnode-02", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bnode-02.nq')))).
test("nt-syntax-bnode-01", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bnode-01.nq')))).
test("nt-syntax-str-esc-03", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-str-esc-03.nq')))).
test("nt-syntax-str-esc-02", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-str-esc-02.nq')))).
test("nt-syntax-str-esc-01", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-str-esc-01.nq')))).
test("nt-syntax-string-03", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-string-03.nq')))).
test("nt-syntax-string-02", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-string-02.nq')))).
test("nt-syntax-string-01", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-string-01.nq')))).
test("nt-syntax-uri-04", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-uri-04.nq')))).
test("nt-syntax-uri-03", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-uri-03.nq')))).
test("nt-syntax-uri-02", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-uri-02.nq')))).
test("nt-syntax-uri-01", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-uri-01.nq')))).
test("nt-syntax-file-03", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-file-03.nq')))).
test("nt-syntax-file-02", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-file-02.nq')))).
test("nt-syntax-file-01", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-file-01.nq')))).
test("nq-syntax-bnode-06", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-bnode-06.nq')))).
test("nq-syntax-bnode-05", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-bnode-05.nq')))).
test("nq-syntax-bnode-04", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-bnode-04.nq')))).
test("nq-syntax-bnode-03", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-bnode-03.nq')))).
test("nq-syntax-bnode-02", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-bnode-02.nq')))).
test("nq-syntax-bnode-01", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-bnode-01.nq')))).
test("nq-syntax-uri-06", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-uri-06.nq')))).
test("nq-syntax-uri-05", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-uri-05.nq')))).
test("nq-syntax-uri-04", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-uri-04.nq')))).
test("nq-syntax-uri-03", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-uri-03.nq')))).
test("nq-syntax-uri-02", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-uri-02.nq')))).
test("nq-syntax-uri-01", ( once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-uri-01.nq')))).
test("nt-syntax-bad-num-03", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-num-03.nq')))).
test("nt-syntax-bad-num-02", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-num-02.nq')))).
test("nt-syntax-bad-num-01", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-num-01.nq')))).
test("nt-syntax-bad-string-07", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-string-07.nq')))).
test("nt-syntax-bad-string-06", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-string-06.nq')))).
test("nt-syntax-bad-string-05", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-string-05.nq')))).
test("nt-syntax-bad-string-04", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-string-04.nq')))).
test("nt-syntax-bad-string-03", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-string-03.nq')))).
test("nt-syntax-bad-string-02", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-string-02.nq')))).
test("nt-syntax-bad-string-01", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-string-01.nq')))).
test("nt-syntax-bad-esc-03", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-esc-03.nq')))).
test("nt-syntax-bad-esc-02", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-esc-02.nq')))).
test("nt-syntax-bad-esc-01", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-esc-01.nq')))).
test("nt-syntax-bad-lang-01", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-lang-01.nq')))).
test("nt-syntax-bad-struct-02", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-struct-02.nq')))).
test("nt-syntax-bad-struct-01", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-struct-01.nq')))).
test("nt-syntax-bad-base-01", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-base-01.nq')))).
test("nt-syntax-bad-prefix-01", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-prefix-01.nq')))).
test("nt-syntax-bad-uri-09", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-uri-09.nq')))).
test("nt-syntax-bad-uri-08", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-uri-08.nq')))).
test("nt-syntax-bad-uri-07", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-uri-07.nq')))).
test("nt-syntax-bad-uri-06", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-uri-06.nq')))).
test("nt-syntax-bad-uri-05", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-uri-05.nq')))).
test("nt-syntax-bad-uri-04", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-uri-04.nq')))).
test("nt-syntax-bad-uri-03", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-uri-03.nq')))).
test("nt-syntax-bad-uri-02", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-uri-02.nq')))).
test("nt-syntax-bad-uri-01", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nt-syntax-bad-uri-01.nq')))).
test("nq-syntax-bad-quint-01", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-bad-quint-01.nq')))).
test("nq-syntax-bad-uri-01", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-bad-uri-01.nq')))).
test("nq-syntax-bad-literal-03", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-bad-literal-03.nq')))).
test("nq-syntax-bad-literal-02", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-bad-literal-02.nq')))).
test("nq-syntax-bad-literal-01", (\+ once(phrase_from_file(nquad_doc, './w3c_test_suite/nq-syntax-bad-literal-01.nq')))).