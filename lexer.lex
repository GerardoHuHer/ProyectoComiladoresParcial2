
%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  //#include "parser.hpp"
%}

%option NOYYWRAP
%option outfile="lexer.cpp"


ID [a-zA-Z_]+[a-zA-Z_0-9]*
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

"repeat"  { return REPEAT }
"until"   { return UNTIL }

"read"    { return READ; }
"write"   { return WRITE; }

";" { return SEMIC; }

")" { return RPAREN; }
"(" { return LPAREN; }

{ID}    { printf("IDENTIFICADOR: %s\n", yytext);
          strcpy(yylval.id, yytext);
          return ID;
 }
{number}    {
            yylval.num = atoi(yytext);
            return NUMBER;
}

{WS}    { /* IGNORE */ }


.       { printf("Se encontró otro caracter: %s\n", yytext); }

%%

int main(int argc, char** argv) {
  if ( argc > 1 )
    yyin = fopen( argv[1], "r" );
  else
    yyin = stdin;

  yylex();

  return 0;
}
