#!/bin/bash


echo -n " Recolector"
echo -n "0) busqueda de un termino\n"
echo -n "1) busqueda por profundidad\n"
echo -n "2) busqeuda por amplitud\n"
echo -n "Introduce un valor:  "
read valor
case "$valor" in
    "1")
        echo "Introduce una URL"
        read url
        echo "Introduce el nivel de la profundidad (1,2,3,inf)"
        read profundidad
       # wget --spider -b -nv -r $url
        estado=`wget --spider -l1 -nv -r -b hiperborea.com.bo|head -n1|awk '{print $6}'|sed 's/\.//g'`
        while ps -p $estado
        do
            echo "Descargando"
            sleep 5
        done
        echo "################## Descargando URL's ##################"
        `cat wget-log |sed -ne 's/.*\(http[^"]*\).*/\1/p'|awk '{print $1}'> links`
        echo "esto tardara un momento"
        for link in `cat links`
        do
        ` wget -nv -O - $link| html2text -utf8|tr ' ' '\n'|sed -f filtro |tr [:upper:] [:lower:]|sort|uniq -c > terminos.log `
        echo "##################"
        done
        echo "#################### indexando URL's ####################"
        
        ;;
    "2")
        echo "Introduce una URL"
        read url2
        echo "Introduce el nivel de la amplitud (1,2,3,inf)"
        read amplitud
        ;;
      *)
        echo "elija una opcion"
        exit 1
esac
