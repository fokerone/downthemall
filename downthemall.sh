#!/bin/bash

OUTPUT="/tmp/input.txt"
>OUTPUT
trap "rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM
clear

dialog  --backtitle "DownThemAll! =)" \
--title "Antes de comenzar..." \
--msgbox 'En google buscar con el patrón: index.of:intitle "loQueSea", una vez ubicada una pagina válida copiar la url' 10 50

dialog  --backtitle "DownThemAll! =)" \
--title "URL" \
--inputbox 'Ingresar un URL válida' 10 70 2>$OUTPUT

respuesta=$?
url=$(<$OUTPUT)

dialog  --backtitle "DownThemAll! =)" \
--title "Generando Listado" \
--infobox 'Espere......'  3 70 

curl -s  $url  | sed -n "/href/ s/.*href=['\"]\([^'\"]*\)['\"].*/\1/gp" > l1.txt 
sed "s|^|$url|" l1.txt  > l2.txt
sleep 1
sed '1,2d' l2.txt > listado.txt
sleep 1
temas=$( wc -l listado.txt | awk '{print $1}')

if [[ "$temas" -eq 0 ]]; then
	dialog --begin 10 30 --backtitle "DownThemAll! =)" \
	--title "Error" \
	--msgbox 'No se encontraron links para descargar' 10 70;
	clear
	exit;
fi

dialog  --backtitle "DownThemAll! =)" \
--title "Listado generado" \
--yesno "Se enconraron $(wc -l listado.txt | awk '{print $1}') links, ¿Deseas descargarlos?"  0 0 

case $? in
	1)
	clear
	exit;;
	255)
	clear
	exit;;
esac

clear

echo '#####################################################################################'
echo '####                          Descargando  enlaces....                           ####'
echo '#####################################################################################'

wget  -i  listado.txt
sleep 1
rm -f listado.txt l1.txt l2.txt

#clear
echo '#####################################################################################'
echo '####                          Trabajo completo                                   ####'
echo '#####################################################################################'

