```make
# Nombre del ejecutable final
TARGET = parser.out

# Archivos fuente
FLEX_FILE   = lexer.lex
BISON_FILE  = parser.y

# Archivos generados
LEXER_CPP   = lexer.cpp
BISON_CPP   = parser.cpp
BISON_HPP   = parser.hpp

# Compilador y flags
CXX = g++
CXXFLAGS = -Wall -std=c++17

# Regla principal
all: $(TARGET)

# Ejecutable
$(TARGET): $(BISON_CPP) $(LEXER_CPP)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(BISON_CPP) $(LEXER_CPP)

# Generar el parser con bison
$(BISON_CPP) $(BISON_HPP): $(BISON_FILE)
	bison -d -o $(BISON_CPP) $(BISON_FILE)

# Generar el lexer con flex
$(LEXER_CPP): $(FLEX_FILE)
	flex -o $(LEXER_CPP) $(FLEX_FILE)

# Limpiar archivos generados
clean:
	rm -f $(TARGET) $(LEXER_CPP) $(BISON_CPP) $(BISON_HPP)
```
