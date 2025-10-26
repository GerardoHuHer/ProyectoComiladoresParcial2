
%{
  #include <string.h>
  #include "bison.hpp"
  //
  //
%}


%option outfile="lexer.cpp"


WS [ \t\n]+
number [+-]?[0-9]+

%%


":="   { return ASSIGN; }
"<"    { return LT; }   
">"    { return GT; }
"="    { return EQUAL; }
"<>"   { return NEQ; }
"<="   { return LEQ; }
">="   { return GEQ; }
"+"    { return PLUS; }
"-"    { return MINUS; }
"*"    { return TIMES; }
"/"    { return DIVIDE; }

"if"      { return IF; }
"then"    { return THEN; }
"else"    { return ELSE; }
"end"     { return END; }

"repeat"  { return REPEAT; }
"until"   { return UNTIL; }

"read"    { return READ; }
"write"   { return WRITE; }

";" { return SEMIC; }

")" { return RPAREN; }
"(" { return LPAREN; }

[a-zA-Z_]+[a-zA-Z_0-9]*  { return ID; }
{number}    { return NUMBER; }

{WS}    { /* IGNORE */ }


.       { printf("Se encontró otro caracter: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}
