# Makefile para compilador con Flex y Bison

# Compilador y flags (máximo nivel de warnings)
CXX = g++
CXXFLAGS = -Wall -Wextra -Wpedantic -Wshadow -Wformat=2 -Wfloat-equal \
           -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond \
           -Wcast-qual -Wcast-align -Wno-unused-parameter -std=c++17 -g

# Directorios
SRC_DIR = .
BUILD_DIR = build
TARGET_DIR = target

# Nombres de archivos fuente
LEXER_SOURCE = $(SRC_DIR)/lexer.lex
PARSER_SOURCE = $(SRC_DIR)/parser.y

# Archivos generados en build/
LEXER_OUTPUT = $(BUILD_DIR)/lexer.cpp
PARSER_OUTPUT = $(BUILD_DIR)/bison.cpp
PARSER_HEADER = $(BUILD_DIR)/bison.hpp

# Ejecutable final en target/
EXECUTABLE = $(TARGET_DIR)/compilador

# Archivos objeto en build/
OBJECTS = $(BUILD_DIR)/lexer.o $(BUILD_DIR)/bison.o

# Regla principal
all: directories $(EXECUTABLE)
	@echo "════════════════════════════════════════"
	@echo "✓ Compilación exitosa"
	@echo "✓ Ejecutable: $(EXECUTABLE)"
	@echo "════════════════════════════════════════"

# Crear directorios necesarios
directories:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(TARGET_DIR)

# Compilar el ejecutable final
$(EXECUTABLE): $(OBJECTS)
	@echo "→ Enlazando ejecutable..."
	$(CXX) $(CXXFLAGS) -o $@ $^
	@echo "✓ Ejecutable generado"

# Generar el parser con Bison
$(PARSER_OUTPUT) $(PARSER_HEADER): $(PARSER_SOURCE) | directories
	@echo "→ Generando parser con Bison..."
	bison -Wcounterexamples -ld -o$(PARSER_OUTPUT) $<
	@echo "✓ Parser generado: $(PARSER_OUTPUT)"

# Generar el lexer con Flex
$(LEXER_OUTPUT): $(LEXER_SOURCE) $(PARSER_HEADER) | directories
	@echo "→ Generando lexer con Flex..."
	flex -L $<
	@if [ -f lexer.cpp ]; then mv lexer.cpp $(LEXER_OUTPUT); fi
	@if [ -f lex.yy.c ]; then mv lex.yy.c $(LEXER_OUTPUT); fi
	@echo "✓ Lexer generado: $(LEXER_OUTPUT)"

# Compilar archivo objeto del lexer
$(BUILD_DIR)/lexer.o: $(LEXER_OUTPUT)
	@echo "→ Compilando lexer..."
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Compilar archivo objeto del parser
$(BUILD_DIR)/bison.o: $(PARSER_OUTPUT)
	@echo "→ Compilando parser..."
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Limpiar archivos generados
clean:
	@echo "→ Limpiando archivos generados..."
	rm -rf $(BUILD_DIR) $(TARGET_DIR)
	rm -f lexer.cpp lex.yy.c  # Limpiar archivos de Flex en directorio actual
	@echo "✓ Limpieza completada"

# Limpiar todo incluyendo backups
cleanall: clean
	@echo "→ Limpieza completa..."
	rm -f *~ *.bak
	@echo "✓ Limpieza completa terminada"

# Reconstruir desde cero
rebuild: clean all

# Mostrar estructura de directorios
tree:
	@echo "Estructura del proyecto:"
	@echo "."
	@echo "├── lexer.lex          (fuente)"
	@echo "├── parser.y           (fuente)"
	@echo "├── build/             (archivos intermedios)"
	@echo "│   ├── lexer.cpp"
	@echo "│   ├── lexer.o"
	@echo "│   ├── bison.cpp"
	@echo "│   ├── bison.hpp"
	@echo "│   └── bison.o"
	@echo "└── target/            (ejecutable final)"
	@echo "    └── compilador"

# Ejecutar pruebas básicas
test: $(EXECUTABLE)
	@echo "════════════════════════════════════════"
	@echo "Ejecutando pruebas básicas"
	@echo "════════════════════════════════════════"
	@echo ""
	@echo "▶ Prueba 1: Asignación simple"
	@echo "x := 5" | $(EXECUTABLE) && echo "✓ PASS" || echo "✗ FAIL"
	@echo ""
	@echo "▶ Prueba 2: IF simple"
	@echo "if x > 5 then write x end" | $(EXECUTABLE) && echo "✓ PASS" || echo "✗ FAIL"
	@echo ""
	@echo "▶ Prueba 3: Secuencia de instrucciones"
	@echo "x := 10; y := 20; z := x + y" | $(EXECUTABLE) && echo "✓ PASS" || echo "✗ FAIL"
	@echo ""
	@echo "▶ Prueba 4: REPEAT-UNTIL"
	@echo "repeat x := x + 1 until x >= 10" | $(EXECUTABLE) && echo "✓ PASS" || echo "✗ FAIL"
	@echo ""

# Ejecutar con archivo de entrada
run: $(EXECUTABLE)
	@if [ -z "$(FILE)" ]; then \
		echo "════════════════════════════════════════"; \
		echo "Uso: make run FILE=archivo.txt"; \
		echo "════════════════════════════════════════"; \
	else \
		echo "════════════════════════════════════════"; \
		echo "Ejecutando: $(FILE)"; \
		echo "════════════════════════════════════════"; \
		$(EXECUTABLE) $(FILE); \
	fi

# Compilar con optimización para release
release: CXXFLAGS = -Wall -Wextra -O3 -DNDEBUG -std=c++17
release: clean all
	@echo "✓ Build de release completado con optimizaciones"

# Compilar con información de debug extra
debug: CXXFLAGS += -g3 -O0 -DDEBUG -fsanitize=address -fsanitize=undefined
debug: clean all
	@echo "✓ Build de debug completado con sanitizers"

# Verificar sintaxis sin compilar completamente
check: $(PARSER_OUTPUT) $(LEXER_OUTPUT)
	@echo "→ Verificando sintaxis..."
	$(CXX) $(CXXFLAGS) -fsyntax-only $(LEXER_OUTPUT) $(PARSER_OUTPUT)
	@echo "✓ Verificación completada"

# Mostrar información del compilador
info:
	@echo "════════════════════════════════════════"
	@echo "Información del compilador"
	@echo "════════════════════════════════════════"
	@echo "Compilador: $(CXX)"
	@$(CXX) --version | head -n 1
	@echo ""
	@echo "Flags activos:"
	@echo "$(CXXFLAGS)" | tr ' ' '\n' | sed 's/^/  /'
	@echo ""
	@echo "Bison:"
	@bison --version | head -n 1
	@echo ""
	@echo "Flex:"
	@flex --version
	@echo "════════════════════════════════════════"

# Mostrar ayuda
help:
	@echo "════════════════════════════════════════"
	@echo "Makefile para compilador Flex/Bison"
	@echo "════════════════════════════════════════"
	@echo ""
	@echo "Objetivos principales:"
	@echo "  make              - Compilar el proyecto"
	@echo "  make all          - Compilar el proyecto"
	@echo "  make clean        - Eliminar archivos generados"
	@echo "  make rebuild      - Recompilar desde cero"
	@echo ""
	@echo "Modos de compilación:"
	@echo "  make release      - Compilar optimizado para producción"
	@echo "  make debug        - Compilar con sanitizers y debug"
	@echo ""
	@echo "Ejecución:"
	@echo "  make test         - Ejecutar pruebas automáticas"
	@echo "  make run FILE=x   - Ejecutar con archivo específico"
	@echo "  make interactive  - Modo interactivo (stdin)"
	@echo ""
	@echo "Utilidades:"
	@echo "  make check        - Verificar sintaxis sin compilar"
	@echo "  make tree         - Mostrar estructura de directorios"
	@echo "  make info         - Información del compilador"
	@echo "  make help         - Mostrar esta ayuda"
	@echo ""
	@echo "Estructura de directorios:"
	@echo "  build/   - Archivos intermedios (.cpp, .o, .hpp)"
	@echo "  target/  - Ejecutable final"
	@echo "════════════════════════════════════════"

# Indicar que estos objetivos no son archivos
.PHONY: all directories clean cleanall rebuild test run  \
        release debug check info tree help
