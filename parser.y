%{
    #include <stdio.h>
    #include <stdlib.h>

    extern FILE* yyin;
    int yylex(void);
    void yyerror(const char *s);
%}

%token IF THEN ELSE END
%token REPEAT UNTIL
%token READ WRITE
%token ID NUMBER 
%token PLUS MINUS TIMES DIVIDE 
%token ASSIGN LT GT EQUAL NEQ LEQ GEQ 
%token SEMIC RPAREN LPAREN 

%%
programa: secuencia_instrucciones ;

secuencia_instrucciones: 
    secuencia_instrucciones SEMIC instruccion
    | instruccion
    ;

instruccion: 
    instruccion_if
    | instruccion_repeat
    | instruccion_asignacion
    | instruccion_read
    | instruccion_write
    ;

instruccion_if: 
    IF expresion THEN secuencia_instrucciones END
    | IF expresion THEN secuencia_instrucciones ELSE secuencia_instrucciones END
    ;

instruccion_repeat:
      REPEAT secuencia_instrucciones UNTIL expresion
    ;

instruccion_asignacion:
      ID ASSIGN expresion
    ;

instruccion_read:
      READ ID
    ;

instruccion_write:
      WRITE expresion
    ;


expresion:
      expresion_simple LT expresion_simple
    | expresion_simple GT expresion_simple
    | expresion_simple EQUAL expresion_simple
    | expresion_simple NEQ expresion_simple
    | expresion_simple LEQ expresion_simple
    | expresion_simple GEQ expresion_simple
    | expresion_simple
    ;

expresion_simple:
      expresion_simple PLUS termino
    | expresion_simple MINUS termino
    | termino
    ;

termino:
      termino TIMES factor
    | termino DIVIDE factor
    | factor
    ;

factor:
      LPAREN expresion RPAREN 
    | NUMBER
    | ID
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error sintáctico: %s\n", s);
}


int main(int argc, char **argv) {
    if(argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Could not open file");
            return 1;
        }
        yyin = file;
    } else{
      yyin = stdin;
    }
    if(yyparse() == 0){
      printf("Análisis completado exitosamente.\n");
    }
    return 0;
}
