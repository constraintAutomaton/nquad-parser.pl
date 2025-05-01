:- set_prolog_flag(double_quotes, chars).
:- use_module(library(dcgs)).
:- use_module(library(charsio)).
:- use_module(library(lists)).
:- use_module(library(clpz)).
:- use_module(library(debug)).
:- use_module(library(dif)).
:- use_module('./util.pl').

end_of_line_ --> "\n"|"\r" .
end_of_line --> end_of_line_ .
end_of_line --> end_of_line_, end_of_line.

space_ --> [X], {char_type(X, whitespace)} .
space --> space_ .
space --> space_, space.

blank_node_label --> "_:", (pn_chars_base_u | numeric_char), optional((zero_or_more((pn_chars|".")) | pn_chars)) .

langtag --> "@", one_or_more(alphabetic_char), optional(("-", one_or_more(alphanumeric_char))) .

string_literal_quote --> ['"'], string_literal_quote_label, ['"'].

% might be the cause of duplicate results
string_literal_quote_label --> zero_or_more((string_literal_quote_label_ | uchar | echar )).

string_literal_quote_label_ --> 
    [X],
    {
        maplist(dif(X), [
            unicode_char(X, 0x22),
            unicode_char(X, 0x5C),
            unicode_char(X, 0xA),
            unicode_char(X, 0xD),
            '"',
            '\\'
        ])  
    } .

iri_ref --> 
    "<",
    iri_label,
    ">".
    
iri_label_ --> 
    [X],
    {
        maplist(dif(X),[
            unicode_char_between(X, 0x00, 0x20),
            /*the < character */
            unicode_char(X, 60),
            /*the > character */
            unicode_char(X, 62),
            /*the " character */
            unicode_char(X, 34),
            /*the { character */
            unicode_char(X, 123),
            /*the } character */
            unicode_char(X, 125),
            /*the | character */
            unicode_char(X, 124),
            /*the ^ character */
            unicode_char(X, 94),
            /*the ` character */
            unicode_char(X, 96),
            /*the \ character */
            unicode_char(X, 92)
        ])
    } .

iri_label --> zero_or_more((uchar|iri_label_)) .

alphabetic_char --> 
    [X], 
    {
        /*between a and z*/ 
        unicode_char_between(X, 65, 90);
        /*between A and Z*/
        unicode_char_between(X, 97, 122) 
    } .


alphanumeric_char --> 
    [X],
    { 
        /*between a and z*/
        unicode_char_between(X, 65, 90);
        /*between A and Z*/
        unicode_char_between(X, 97, 122);
        /*between 0 and 9*/
        unicode_char_between(X, 48, 57)
    } .

numeric_char --> 
    [X],
    {
        /*between 0 and 9*/
        unicode_char_between(X, 48, 57)
    }.
uchar --> "\\\\u", hex, hex, hex, hex .
uchar --> "\\\\U", hex, hex, hex, hex, hex, hex, hex .

hex --> 
    [X],
    {
        /*between 0 and 9*/
        unicode_char_between(X, 48, 57);
        /*between a and f*/
        unicode_char_between(X, 97, 102);
        /*between A and F*/
        unicode_char_between(X, 65, 90)
    } .

echar --> "\t" | "\b" | "\n" | "\r" | "\f" | "\\\"" | "\'" | ['\\'].

pn_chars --> pn_chars_base_u | "-" .
pn_chars --> numeric_char.
pn_chars --> [X],
    {
        unicode_char(X, 0x00B7);
        unicode_char_between(X, 0x0300, 0x036F);
        unicode_char_between(X, 0x203F, 0x2040)
    }.

pn_chars_base_u --> pn_chars_base | "_" | ":" .

pn_chars_base --> alphabetic_char .
pn_chars_base --> [X],
    {
        unicode_char_between(X, 0x00C0, 0x00D6);
        unicode_char_between(X, 0x00D8, 0x00F6);
        unicode_char_between(X, 0x00F8, 0x02FF);
        unicode_char_between(X, 0x0370, 0x037D);
        unicode_char_between(X, 0x037F, 0x1FFF);
        unicode_char_between(X, 0x200C, 0x200D);
        unicode_char_between(X, 0x2070, 0x218F);
        unicode_char_between(X, 0x2C00, 0x2FEF);
        unicode_char_between(X, 0x3001, 0xD7FF);
        unicode_char_between(X, 0xF900, 0xFDCF);
        unicode_char_between(X, 0xFDF0, 0xFFFD);
        unicode_char_between(X, 0x10000, 0xEFFFF)
    }.
