%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string>
    #include <vector>
    #include <algorithm>
    #include <iostream>
    #include "arbol.hpp"
    
    using namespace std;
    
    // Tamaño de la tabla con un número primo grande para mejor distribución
    const unsigned int TAM_TABLA = 211;
    
    // Estructura de símbolo
    struct Simbolo {
        string id;
        vector<unsigned int> lineas;
    };
    
    // Tabla de símbolos
    vector<Simbolo> tabla[TAM_TABLA];
    
    // Prototipos de funciones de tabla de símbolos
    unsigned int funcionHash(string id);
    void insertar(string id, unsigned int linea);
    bool existeID(string id);
    void mostrarTabla();
    
    // Declaraciones externas
    extern FILE* yyin;
    extern int yylineno;
    
    // Prototipos de funciones de parser
    int yylex(void);
    void yyerror(const char *s);
    
    // Raíz del AST
    NodoAST* raizAST = nullptr;
%}

%union {
    struct {
        char* id;
        unsigned int linea;
    } id_info;
    int num;
    NodoAST* nodo;
}

%token IF THEN ELSE END
%token REPEAT UNTIL
%token READ WRITE
%token <id_info> ID
%token <num> NUMBER 
%token PLUS MINUS TIMES DIVIDE 
%token ASSIGN LT GT EQUAL NEQ LEQ GEQ 
%token SEMIC RPAREN LPAREN 

%type <nodo> programa secuencia_instrucciones instruccion
%type <nodo> instruccion_if instruccion_repeat instruccion_asignacion
%type <nodo> instruccion_read instruccion_write
%type <nodo> expresion expresion_simple termino factor

%%
programa: secuencia_instrucciones { raizAST = $1; };

secuencia_instrucciones: 
    secuencia_instrucciones SEMIC instruccion { $$ = crearNodoSecuencia($1, $3); }
    | instruccion { $$ = $1; }
    ;

instruccion: 
    instruccion_if { $$ = $1; }
    | instruccion_repeat { $$ = $1; }
    | instruccion_asignacion { $$ = $1; }
    | instruccion_read { $$ = $1; }
    | instruccion_write { $$ = $1; }
    ;

instruccion_if: 
    IF expresion THEN secuencia_instrucciones END { 
        $$ = crearNodoSi($2, $4, nullptr); 
    }
    | IF expresion THEN secuencia_instrucciones ELSE secuencia_instrucciones END { 
        $$ = crearNodoSi($2, $4, $6); 
    }
    ;

instruccion_repeat:
      REPEAT secuencia_instrucciones UNTIL expresion { 
          $$ = crearNodoRepetir($2, $4); 
      }
    ;

instruccion_asignacion:
      ID ASSIGN expresion {
          insertar(string($1.id), $1.linea);
          $$ = crearNodoAsignacion(string($1.id), $3);
          free($1.id);
      }
    ;

instruccion_read:
      READ ID {
          insertar(string($2.id), $2.linea);
          $$ = crearNodoLeer(string($2.id));
          free($2.id);
      }
    ;

instruccion_write:
      WRITE expresion {
          $$ = crearNodoEscribir($2);
      }
    ;

expresion:
      expresion_simple LT expresion_simple { $$ = crearNodoOperador(OP_MENOR, $1, $3); }
    | expresion_simple GT expresion_simple { $$ = crearNodoOperador(OP_MAYOR, $1, $3); }
    | expresion_simple EQUAL expresion_simple { $$ = crearNodoOperador(OP_IGUAL, $1, $3); }
    | expresion_simple NEQ expresion_simple { $$ = crearNodoOperador(OP_DIFERENTE, $1, $3); }
    | expresion_simple LEQ expresion_simple { $$ = crearNodoOperador(OP_MENOR_IGUAL, $1, $3); }
    | expresion_simple GEQ expresion_simple { $$ = crearNodoOperador(OP_MAYOR_IGUAL, $1, $3); }
    | expresion_simple { $$ = $1; }
    ;

expresion_simple:
      expresion_simple PLUS termino { $$ = crearNodoOperador(OP_SUMA, $1, $3); }
    | expresion_simple MINUS termino { $$ = crearNodoOperador(OP_RESTA, $1, $3); }
    | termino { $$ = $1; }
    ;

termino:
      termino TIMES factor { $$ = crearNodoOperador(OP_MULTIPLICACION, $1, $3); }
    | termino DIVIDE factor { $$ = crearNodoOperador(OP_DIVISION, $1, $3); }
    | factor { $$ = $1; }
    ;

factor:
      LPAREN expresion RPAREN { $$ = $2; }
    | NUMBER { $$ = crearNodoConstante($1); }
    | ID {
          insertar(string($1.id), $1.linea);
          $$ = crearNodoIdentificador(string($1.id));
          free($1.id);
      }
    ;

%%

// Implementación de funciones de tabla de símbolos
unsigned int funcionHash(string id) {
    unsigned int suma = 0;
    for (char c : id)
        suma += c;
    return suma % TAM_TABLA;
}

void insertar(string id, unsigned int linea) {
    unsigned int indice = funcionHash(id);
    
    for (Simbolo& simbolo : tabla[indice]) {
        if (simbolo.id == id) {
            //if (find(simbolo.lineas.begin(), simbolo.lineas.end(), linea) == simbolo.lineas.end()) {
            //    simbolo.lineas.push_back(linea);
            //}

            simbolo.lineas.push_back(linea);
            return;
        }
    }
    
    Simbolo nuevo;
    nuevo.id = id;
    nuevo.lineas.push_back(linea);
    tabla[indice].push_back(nuevo);
}

bool existeID(string id) {
    unsigned int indice = funcionHash(id);
    for (const Simbolo& simbolo : tabla[indice]) {
        if (simbolo.id == id)
            return true;
    }
    return false;
}

void mostrarTabla() {
    cout << "\n========== TABLA DE SÍMBOLOS ==========\n";
    cout << "IDENTIFICADOR        LÍNEAS\n";
    cout << "========================================\n";
    
    vector<Simbolo> todosSimbolos;
    for (unsigned int i = 0; i < TAM_TABLA; i++) {
        for (const Simbolo& simbolo : tabla[i]) {
            todosSimbolos.push_back(simbolo);
        }
    }
    
    // Mostrar símbolos
    for (const Simbolo& simbolo : todosSimbolos) {
        cout << simbolo.id;
        
        for (unsigned int i = simbolo.id.length(); i < 20; i++)
            cout << " ";
        
        for (unsigned int i = 0; i < simbolo.lineas.size(); i++) {
            cout << simbolo.lineas[i];
            if (i < simbolo.lineas.size() - 1)
                cout << ", ";
        }
        cout << "\n";
    }
    
    cout << "========================================\n";
    cout << "Total de símbolos: " << todosSimbolos.size() << "\n\n";
}

void yyerror(const char *s) {
    fprintf(stderr, "Error sintáctico en línea %d: %s\n", yylineno - 1, s);
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
    
    if(yyparse() == 0){
        printf("\n Se acepta el archivo\n");
        mostrarTabla();
        
        // Imprimir el AST
        if (raizAST != nullptr) {
            cout << "\nArbol sintactico:" << endl;
            imprimirAST(raizAST);
            liberarAST(raizAST);
        }
    }     
    return 0;
}
