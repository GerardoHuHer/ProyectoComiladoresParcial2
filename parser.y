%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string>
    #include <vector>
    #include <algorithm>
    #include <iostream>
    
    using namespace std;
    
    // Tamaño de la tabla con un número primo grande para mejor distribución
    const unsigned int TAM_TABLA = 211;
    
    // Estructura de símbolo
    struct Simbolo {
        string id;
        vector<unsigned int> lineas;
    };
    
    // Declaraciones externas
    extern vector<Simbolo> tabla[TAM_TABLA];
    extern unsigned int line_number;
    extern FILE* yyin;
    
    // Prototipos de funciones
    int yylex(void);
    void yyerror(const char *s);
    unsigned int funcionHash(string id);
    void insertar(string id, int linea);
    bool existeID(string id);
    void mostrarTabla();
    void mostrarTablaHash();
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
    fprintf(stderr, "Error sintáctico en línea %d: %s\n", line_number, s);
}

int main(int argc, char **argv) {
    if(argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("No se pudo abrir el archivo");
            return 1;
        }
        yyin = file;
    } else {
        yyin = stdin;
    }
    
    int result = yyparse();
    
    if(result == 0){
        printf("\n✓ Análisis completado exitosamente.\n");
        mostrarTabla();
    } else {
        printf("\n✗ Análisis fallido.\n");
    }
    
    return result;
}
