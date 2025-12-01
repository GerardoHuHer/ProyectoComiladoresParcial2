%{
  #include <string.h>
  #include <stdlib.h>
  #include "arbol.hpp"
  #include "bison.hpp"
  
%}
%option outfile="build/lexer.cpp"
%option noyywrap
%option yylineno
WS [ \t]+
NL \n
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
[a-zA-Z_]+[a-zA-Z_0-9]*  { 
    yylval.id_info.id = strdup(yytext);
    yylval.id_info.linea = yylineno;
    return ID; 
}
{number}    { 
    yylval.num = atoi(yytext);
    return NUMBER; 
}
{WS}        { /* IGNORE */ }
{NL}        { /* line_number se maneja automáticamente con yylineno */ }
.           { printf("Caracter desconocido en línea %d: %s\n", yylineno, yytext); }
%%