#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import platform
import subprocess
import shutil

# Colores ANSI
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'  # No Color
    
    @staticmethod
    def disable():
        """Desactivar colores en Windows si no están soportados"""
        Colors.RED = ''
        Colors.GREEN = ''
        Colors.YELLOW = ''
        Colors.BLUE = ''
        Colors.NC = ''

def detectar_os():
    """Detecta el sistema operativo"""
    sistema = platform.system()
    print(f"{Colors.BLUE}→ Sistema operativo detectado: {sistema}{Colors.NC}")
    return sistema

def verificar_comando(comando):
    """Verifica si un comando está disponible"""
    return shutil.which(comando) is not None

def ejecutar_comando(comando, shell=False):
    """Ejecuta un comando y devuelve el código de salida"""
    try:
        resultado = subprocess.run(comando, shell=shell, check=False)
        return resultado.returncode
    except Exception as e:
        print(f"{Colors.RED}✗ Error al ejecutar comando: {e}{Colors.NC}")
        return 1

def compilar_unix():
    """Compila el proyecto en Unix/Linux/Mac"""
    print(f"{Colors.BLUE}→ Compilando en sistema Unix/Linux/Mac{Colors.NC}")
    
    # Verificar que make está instalado
    if not verificar_comando('make'):
        print(f"{Colors.RED}✗ Error: 'make' no está instalado{Colors.NC}")
        sys.exit(1)
    
    # Limpiar
    print(f"{Colors.YELLOW}→ Limpiando archivos anteriores...{Colors.NC}")
    ejecutar_comando(['make', 'clean'])
    
    # Compilar
    print(f"{Colors.YELLOW}→ Compilando proyecto...{Colors.NC}")
    resultado = ejecutar_comando(['make'])
    
    if resultado == 0:
        print(f"{Colors.GREEN}✓ Compilación exitosa{Colors.NC}")
        ejecutar_programa_unix()
    else:
        print(f"{Colors.RED}✗ Error en la compilación{Colors.NC}")
        sys.exit(1)

def compilar_windows():
    """Compila el proyecto en Windows"""
    print(f"{Colors.BLUE}→ Compilando en sistema Windows{Colors.NC}")
    
    # Verificar que make está instalado
    make_cmd = None
    if verificar_comando('mingw32-make'):
        make_cmd = 'mingw32-make'
    elif verificar_comando('make'):
        make_cmd = 'make'
    else:
        print(f"{Colors.RED}✗ Error: 'make' o 'mingw32-make' no está instalado{Colors.NC}")
        print("Instala MinGW o usa WSL")
        sys.exit(1)
    
    # Limpiar
    print(f"{Colors.YELLOW}→ Limpiando archivos anteriores...{Colors.NC}")
    ejecutar_comando([make_cmd, 'clean'], shell=True)
    
    # Compilar
    print(f"{Colors.YELLOW}→ Compilando proyecto...{Colors.NC}")
    resultado = ejecutar_comando([make_cmd], shell=True)
    
    if resultado == 0:
        print(f"{Colors.GREEN}✓ Compilación exitosa{Colors.NC}")
        ejecutar_programa_windows()
    else:
        print(f"{Colors.RED}✗ Error en la compilación{Colors.NC}")
        sys.exit(1)

def ejecutar_programa_unix():
    """Ejecuta el programa compilado en Unix/Linux/Mac"""
    if os.path.exists('file.cod'):
        respuesta = input("¿Desea ejecutar el compilador con file.cod? (s/n): ")
        if respuesta.lower() in ['s', 'si', 'y', 'yes']:
            print(f"{Colors.BLUE}→ Ejecutando compilador...{Colors.NC}")
            ejecutar_comando(['./target/compilador', 'file.cod'])

def ejecutar_programa_windows():
    """Ejecuta el programa compilado en Windows"""
    if os.path.exists('file.cod'):
        respuesta = input("¿Desea ejecutar el compilador con file.cod? (s/n): ")
        if respuesta.lower() in ['s', 'si', 'y', 'yes']:
            print(f"{Colors.BLUE}→ Ejecutando compilador...{Colors.NC}")
            # Intentar con .exe primero, luego sin extensión
            if os.path.exists('target/compilador.exe'):
                ejecutar_comando(['target\\compilador.exe', 'file.cod'], shell=True)
            elif os.path.exists('target/compilador'):
                ejecutar_comando(['target/compilador', 'file.cod'], shell=True)

def limpiar():
    """Limpia archivos compilados"""
    print(f"{Colors.YELLOW}→ Limpiando archivos generados...{Colors.NC}")
    
    sistema = platform.system()
    if sistema == 'Windows':
        make_cmd = 'mingw32-make' if verificar_comando('mingw32-make') else 'make'
        ejecutar_comando([make_cmd, 'clean'], shell=True)
    else:
        ejecutar_comando(['make', 'clean'])
    
    print(f"{Colors.GREEN}✓ Limpieza completa{Colors.NC}")

def mostrar_ayuda():
    """Muestra la ayuda del script"""
    print(f"""
{Colors.GREEN}========================================
  Script de compilación multiplataforma
========================================{Colors.NC}

Uso: python build.py [opción]

Opciones:
  build     - Compilar el proyecto (default)
  clean     - Limpiar archivos generados
  run       - Compilar y ejecutar automáticamente
  help      - Mostrar esta ayuda

Ejemplos:
  python build.py
  python build.py clean
  python build.py run
""")

def main():
    """Función principal"""
    # En Windows, desactivar colores si no están soportados
    if platform.system() == 'Windows':
        try:
            # Intentar habilitar colores en Windows 10+
            os.system('color')
        except:
            Colors.disable()
    
    # Parsear argumentos
    if len(sys.argv) > 1:
        opcion = sys.argv[1].lower()
        if opcion == 'help' or opcion == '-h' or opcion == '--help':
            mostrar_ayuda()
            return
        elif opcion == 'clean':
            limpiar()
            return
        elif opcion == 'run':
            pass  # Continuar con la compilación normal
        elif opcion == 'build':
            pass  # Continuar con la compilación normal
        else:
            print(f"{Colors.RED}Opción no reconocida: {opcion}{Colors.NC}")
            mostrar_ayuda()
            return
    
    # Banner
    print(f"{Colors.GREEN}========================================")
    print("  Script de compilación multiplataforma")
    print(f"========================================={Colors.NC}")
    
    # Detectar sistema operativo
    sistema = detectar_os()
    
    # Compilar según el sistema
    if sistema in ['Linux', 'Darwin']:  # Darwin es macOS
        compilar_unix()
    elif sistema == 'Windows':
        compilar_windows()
    else:
        print(f"{Colors.RED}✗ Sistema operativo no soportado: {sistema}{Colors.NC}")
        sys.exit(1)
    
    # Banner final
    print(f"{Colors.GREEN}========================================")
    print("  Proceso completado")
    print(f"========================================={Colors.NC}")

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}→ Proceso interrumpido por el usuario{Colors.NC}")
        sys.exit(0)