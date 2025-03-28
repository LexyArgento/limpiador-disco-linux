#!/bin/bash

if [ $(whoami) != "root" ]; then
        echo "lo siento, este script solo funciona con privilegios de root!"
        echo "porfavor ingrese como root"
        sudo su
else
    :
fi
echo "este script elimina archivos temporales, registros
               y paquetes inesesaeios

      1- eliminar paquetes que ya no son necesarios
      2- limpiar archivos temporales
      3- limpiar registros
      4- full limpieza"

read -p "ingrese el numero correspondiente: " respuesta
function limpieza() {
        apt autoremove -y --purge && apt autoclean
        rm -rf /tmp/* && rm -rf /var/tmp/*
        journalctl --vacuum-size=100M
        sudo find -type f -exec md5sum {} \; | sort | uniq -d -w 32 | xargs -I {} rm {}
}
if [ $respuesta == 4 ]; then
        read -p "esta opcion hara una limpieza profunda, no se detendra hasta que termine. ¿estas seguro que quieres continuar? [Y/N] " respuesta2
        if [ $respuesta2 == Y ] || [ $respuesta2 == y ]; then
                limpieza
        else
            echo "saliendo, que tenga buen dia :3"
            exit
        fi
else
        case $respuesta in
                1) apt autoremove -y --purge && apt autoclean;;
		2) rm -rf /tmp/* && rm -rf /var/tmp/* | echo "limpiando sector";;
                3) journalctl --vacuum-size=100M | echo "sector limpiado";;
                *) echo "operacion invalida";;
        esac
fi

if [ $(whoami) == "root" ]; then
        exit
else
        echo "no se como lo hiciste pero felicidades, bugueaste mi script
              pero por razones de seguridad te debo pedie que porfavor salgas manualmente"
fi
