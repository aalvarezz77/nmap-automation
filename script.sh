#!/bin/bash

# Este script realiza varias tareas de escaneo con Nmap y guarda los resultados en un archivo PDF único para cada escaneo

# Archivo que almacena el último ID usado
ID_FILE="scan_id.txt"

# Verificar si el archivo ID_FILE existe, si no, lo crea con el ID inicial en 1
if [ ! -f $ID_FILE ]; then
    echo 1 > $ID_FILE
fi

# Leer el último ID
scan_id=$(cat $ID_FILE)

# Incrementar el ID para el siguiente escaneo
next_id=$((scan_id + 1))

# Guardar el siguiente ID en el archivo
echo $next_id > $ID_FILE

# Solicitar la IP de destino
read -p "Introduce la IP o rango de IPs que deseas escanear: " ip

# Crear un nombre único para el archivo de salida basado en el ID de escaneo
output_file="nmap_scan_results_$scan_id.txt"
pdf_output_file="nmap_scan_results_$scan_id.pdf"

# Menú de opciones
echo "Selecciona el tipo de escaneo que deseas realizar:"
echo "1) Identificación de Hosts Activos"
echo "2) Escaneo de Puertos y Servicios"
echo "3) Detección de Sistemas Operativos"
echo "4) Análisis de Vulnerabilidades con NSE"
echo "5) Evasión de Detección IDS/IPS"
echo "6) Escaneo Completo"

read -p "Elige una opción (1-6): " opcion

# Dependiendo de la opción seleccionada, realizar el escaneo correspondiente y guardar los resultados
case $opcion in
  1)
    echo "Escaneando Hosts Activos..."
    nmap -sn $ip > $output_file
    ;;
  2)
    echo "Escaneando Puertos y Servicios..."
    nmap -sV $ip > $output_file
    ;;
  3)
    echo "Detectando Sistemas Operativos..."
    nmap -O $ip > $output_file
    ;;
  4)
    echo "Realizando Análisis de Vulnerabilidades con NSE..."
    nmap --script=vuln $ip > $output_file
    ;;
  5)
    echo "Realizando Escaneo de Evasión de IDS/IPS..."
    nmap -T0 -sS $ip > $output_file
    ;;
  6)
    echo "Realizando Escaneo Completo..."
    nmap -sS -sV -O --script=vuln $ip > $output_file
    ;;
  *)
    echo "Opción no válida. Saliendo."
    exit 1
    ;;
esac

# Crear un archivo PDF a partir del archivo de salida
enscript $output_file -o - | ps2pdf - $pdf_output_file

# Mostrar mensaje de éxito
echo "Los resultados han sido guardados en '$pdf_output_file'"
