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
space --> space_ .
space --> space_, space.

langtag --> "@", one_or_more(alphabetic_char), optional(("-", one_or_more(alphanumeric_char))) .


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


uchar --> "\\u", hex, hex, hex, hex .
uchar --> "\\U", hex, hex, hex, hex, hex, hex, hex .

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