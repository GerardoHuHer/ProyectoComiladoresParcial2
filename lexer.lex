
%{
  //#include <stdio.h>
  //#include <stdlib.h>
  #include "parser.hpp"
%}

%option NOYYWRAP
%option outfile="lexer.cpp"



ID [a-zA-Z_]+[a-zA-Z_0-9]*
WS [ \t\n]+

%%


":="   { printf("OPERADOR: %s\n", yytext); }
"<"    { printf("OPERADOR: %s\n", yytext); }   
">"    { printf("OPERADOR: %s\n", yytext); }
"="    { printf("OPERADOR: %s\n", yytext); }
"<>"   { printf("OPERADOR: %s\n", yytext); }
"<="   { printf("OPERADOR: %s\n", yytext); }
">="   { printf("OPERADOR: %s\n", yytext); }
"+"    { printf("OPERADOR: %s\n", yytext); }
"-"    { printf("OPERADOR: %s\n", yytext); }
"*"    { printf("OPERADOR: %s\n", yytext); }
"/"    { printf("OPERADOR: %s\n", yytext); }


"if"      { printf("IF\n"); }
"then"    { printf("THEN\n"); }
"else"    { printf("ELSE\n"); }
"end"     { printf("END\n"); }

"repeat"  { printf("REPEAT\n"); }
"until"   { printf("UNTIL\n"); }

"read"    { printf("FUNCIÓN: %s\n", yytext); }
"write"   { printf("FUNCIÓN: %s\n", yytext); }

";" { printf("SEPARADOR:  %s\n", yytext); }

")" { printf("PARENTESIS CIERRA: %s\n", yytext); }
"(" { printf("PARENTESIS ABRE: %s\n", yytext); }

{ID}    { printf("IDENTIFICADOR: %s\n", yytext); }
[0-9]+  { printf("NÚMERO: %d\n", atoi(yytext)); }

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
