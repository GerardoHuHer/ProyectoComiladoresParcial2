#ifndef ARBOL_HPP
#define ARBOL_HPP

#include <string>
#include <vector>

using namespace std;

// Tipos de nodos del AST
enum TipoNodo {
    // Instrucciones
    NODO_LEER,
    NODO_ESCRIBIR,
    NODO_ASIGNACION,
    NODO_SI, NODO_REPETIR,
    NODO_SECUENCIA,
    
    // Expresiones
    NODO_OPERADOR,
    NODO_IDENTIFICADOR,
    NODO_CONSTANTE
};

// Tipos de operadores
enum TipoOperador {
    OP_SUMA,
    OP_RESTA,
    OP_MULTIPLICACION,
    OP_DIVISION,
    OP_MENOR,
    OP_MAYOR,
    OP_IGUAL,
    OP_DIFERENTE,
    OP_MENOR_IGUAL,
    OP_MAYOR_IGUAL
};

// Estructura del nodo del AST
struct NodoAST {
    TipoNodo tipo;
    
    // Para identificadores y operadores
    string nombre;
    TipoOperador op;
    
    // Para constantes
    int valor;
    
    // Hijos del nodo
    vector<NodoAST*> hijos;
    
    // Constructor
    NodoAST(TipoNodo t) : tipo(t), valor(0), op(OP_SUMA) {}
};

// Prototipos de funciones para crear nodos
NodoAST* crearNodoLeer(string id);
NodoAST* crearNodoEscribir(NodoAST* expresion);
NodoAST* crearNodoAsignacion(string id, NodoAST* expresion);
NodoAST* crearNodoSi(NodoAST* condicion, NodoAST* secuenciaThen, NodoAST* secuenciaElse = nullptr);
NodoAST* crearNodoRepetir(NodoAST* secuencia, NodoAST* condicion);
NodoAST* crearNodoSecuencia(NodoAST* izq, NodoAST* der);
NodoAST* crearNodoOperador(TipoOperador op, NodoAST* izq, NodoAST* der);
NodoAST* crearNodoIdentificador(string nombre);
NodoAST* crearNodoConstante(int valor);

// Función para imprimir el árbol
void imprimirAST(NodoAST* nodo, unsigned int indentacion = 0);

// Función para liberar memoria del árbol
void liberarAST(NodoAST* nodo);

#endif
