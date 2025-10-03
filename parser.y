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
%token IDENTIFICADOR NUMERO 
%token MAS MENOS MUL DIV
%token MENOR MAYOR IGUAL DIFERENTE MENORIGUAL MAYORIGUAL ASIGNACION
%token PUNTOCOMA PARENIZQ PARENDER

%%

programa: 
    secuencia_instrucciones
    ;

secuencia_instrucciones: 
    secuencia_instrucciones PUNTOCOMA instruccion
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
      IDENTIFICADOR ASIGNACION expresion
    ;

instruccion_read:
      READ IDENTIFICADOR
    ;

instruccion_write:
      WRITE expresion
    ;


expresion:
      expresion_simple MENOR expresion_simple
    | expresion_simple MAYOR expresion_simple
    | expresion_simple IGUAL expresion_simple
    | expresion_simple DIFERENTE expresion_simple
    | expresion_simple MENORIGUAL expresion_simple
    | expresion_simple MAYORIGUAL expresion_simple
    | expresion_simple
    ;

expresion_simple:
      expresion_simple MAS termino
    | expresion_simple MENOS termino
    | termino
    ;

termino:
      termino POR factor
    | termino DIV factor
    | factor
    ;

factor:
      PARENIZQ expresion PARENDER
    | NUMERO
    | IDENTIFICADOR
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
    }
    yyparse();
    return 0;
}