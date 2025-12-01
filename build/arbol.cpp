#include "arbol.hpp"
#include <iostream>

using namespace std;

// Crear nodo LEER
NodoAST* crearNodoLeer(string id) {
    NodoAST* nodo = new NodoAST(NODO_LEER);
    nodo->nombre = id;
    return nodo;
}

// Crear nodo ESCRIBIR
NodoAST* crearNodoEscribir(NodoAST* expresion) {
    NodoAST* nodo = new NodoAST(NODO_ESCRIBIR);
    nodo->hijos.push_back(expresion);
    return nodo;
}

// Crear nodo ASIGNACION
NodoAST* crearNodoAsignacion(string id, NodoAST* expresion) {
    NodoAST* nodo = new NodoAST(NODO_ASIGNACION);
    nodo->nombre = id;
    nodo->hijos.push_back(expresion);
    return nodo;
}

// Crear nodo SI
NodoAST* crearNodoSi(NodoAST* condicion, NodoAST* secuenciaThen, NodoAST* secuenciaElse) {
    NodoAST* nodo = new NodoAST(NODO_SI);
    nodo->hijos.push_back(condicion);
    nodo->hijos.push_back(secuenciaThen);
    if (secuenciaElse != nullptr) {
        nodo->hijos.push_back(secuenciaElse);
    }
    return nodo;
}

// Crear nodo REPETIR
NodoAST* crearNodoRepetir(NodoAST* secuencia, NodoAST* condicion) {
    NodoAST* nodo = new NodoAST(NODO_REPETIR);
    nodo->hijos.push_back(secuencia);
    nodo->hijos.push_back(condicion);
    return nodo;
}

// Crear nodo SECUENCIA
NodoAST* crearNodoSecuencia(NodoAST* izq, NodoAST* der) {
    NodoAST* nodo = new NodoAST(NODO_SECUENCIA);
    nodo->hijos.push_back(izq);
    nodo->hijos.push_back(der);
    return nodo;
}

// Crear nodo OPERADOR
NodoAST* crearNodoOperador(TipoOperador op, NodoAST* izq, NodoAST* der) {
    NodoAST* nodo = new NodoAST(NODO_OPERADOR);
    nodo->op = op;
    nodo->hijos.push_back(izq);
    nodo->hijos.push_back(der);
    return nodo;
}

// Crear nodo IDENTIFICADOR
NodoAST* crearNodoIdentificador(string nombre) {
    NodoAST* nodo = new NodoAST(NODO_IDENTIFICADOR);
    nodo->nombre = nombre;
    return nodo;
}

// Crear nodo CONSTANTE
NodoAST* crearNodoConstante(int valor) {
    NodoAST* nodo = new NodoAST(NODO_CONSTANTE);
    nodo->valor = valor;
    return nodo;
}

// Función auxiliar para obtener el nombre del operador
string obtenerNombreOperador(TipoOperador op) {
    switch(op) {
        case OP_SUMA: return "+";
        case OP_RESTA: return "-";
        case OP_MULTIPLICACION: return "*";
        case OP_DIVISION: return "/";
        case OP_MENOR: return "<";
        case OP_MAYOR: return ">";
        case OP_IGUAL: return "=";
        case OP_DIFERENTE: return "<>";
        case OP_MENOR_IGUAL: return "<=";
        case OP_MAYOR_IGUAL: return ">=";
        default: return "?";
    }
}

// Función para imprimir espacios de indentación
void imprimirIndentacion(int nivel) {
    for (int i = 0; i < nivel; i++) {
        cout << "  ";
    }
}

// Función para imprimir el AST
void imprimirAST(NodoAST* nodo, int indentacion) {
    if (nodo == nullptr) return;
    
    imprimirIndentacion(indentacion);
    
    switch(nodo->tipo) {
        case NODO_LEER:
            cout << "READ: " << nodo->nombre << endl;
            break;
            
        case NODO_ESCRIBIR:
            cout << "WRITE:" << endl;
            for (NodoAST* hijo : nodo->hijos) {
                imprimirAST(hijo, indentacion + 1);
            }
            break;
            
        case NODO_ASIGNACION:
            cout << "ASSIGN: " << nodo->nombre << endl;
            for (NodoAST* hijo : nodo->hijos) {
                imprimirAST(hijo, indentacion + 1);
            }
            break;
            
        case NODO_SI:
            cout << "IF:" << endl;
            for (NodoAST* hijo : nodo->hijos) {
                imprimirAST(hijo, indentacion + 1);
            }
            break;
            
        case NODO_REPETIR:
            cout << "REPEAT:" << endl;
            for (NodoAST* hijo : nodo->hijos) {
                imprimirAST(hijo, indentacion + 1);
            }
            break;
            
        case NODO_SECUENCIA:
            // No imprimimos nada para secuencia, solo procesamos hijos
            for (NodoAST* hijo : nodo->hijos) {
                imprimirAST(hijo, indentacion);
            }
            break;
            
        case NODO_OPERADOR:
            cout << "OPERATOR: " << obtenerNombreOperador(nodo->op) << endl;
            for (NodoAST* hijo : nodo->hijos) {
                imprimirAST(hijo, indentacion + 1);
            }
            break;
            
        case NODO_IDENTIFICADOR:
            cout << "IDENTIFIER: " << nodo->nombre << endl;
            break;
            
        case NODO_CONSTANTE:
            cout << "CONSTANT: " << nodo->valor << endl;
            break;
    }
}

// Función para liberar memoria del árbol
void liberarAST(NodoAST* nodo) {
    if (nodo == nullptr) return;
    
    for (NodoAST* hijo : nodo->hijos) {
        liberarAST(hijo);
    }
    
    delete nodo;
}
