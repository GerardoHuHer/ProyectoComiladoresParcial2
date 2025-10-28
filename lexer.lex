%{
  #include <string>
  #include <vector>
  #include <algorithm>
  #include <iostream>
  #include "bison.hpp"
  
  using namespace std;
  
  
  // Tamaño de la tabla
  const unsigned int TAM_TABLA = 211;
  
  struct Simbolo {
      string id;
      vector<unsigned int> lineas;
  };
  
  vector<Simbolo> tabla[TAM_TABLA];
  unsigned int line_number = 1;
  
  unsigned int funcionHash(string id);
  void insertar(string id, unsigned int linea);
  bool existeID(string id);
  void mostrarTabla();
  void mostrarTablaHash();
  
%}

%option outfile="lexer.cpp"
%option noyywrap

WS [ \t]+
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
    insertar(string(yytext), line_number);
    return ID; 
}

{number}    { return NUMBER; }
{WS}        { /* IGNORE */ }
\n          { line_number++; }
.           { printf("Caracter desconocido en línea %d: %s\n", line_number, yytext); }

%%
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
              if (find(simbolo.lineas.begin(), simbolo.lineas.end(), linea) == simbolo.lineas.end()) {
                  simbolo.lineas.push_back(linea);
              }
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
      
      // Recolectar todos los símbolos
      vector<Simbolo> todosSimbolos;
      for (unsigned int i = 0; i < TAM_TABLA; i++) {
          for (const Simbolo& simbolo : tabla[i]) {
              todosSimbolos.push_back(simbolo);
          }
      }
      
      // Ordenar alfabéticamente
      sort(todosSimbolos.begin(), todosSimbolos.end(), 
           [](const Simbolo& a, const Simbolo& b) {
               return a.id < b.id;
           });
      
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
  
  void mostrarTablaHash() {
      cout << "\n=== Contenido de la tabla hash (índices) ===\n";
      for (unsigned int i = 0; i < TAM_TABLA; i++) {
          if (!tabla[i].empty()) {
              cout << i << ": ";
              for (const Simbolo& simbolo : tabla[i]) {
                  cout << simbolo.id << " ";
              }
              cout << "\n";
          }
      }
      cout << "\n";
  }

