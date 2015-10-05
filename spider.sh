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
        wget --spider -b -nv -r $url
        a=`grep -i "ACABADO" wget-log |awk '{print $1}'`
        b="ACABADO"
        flag=true
        while [ $flag ]
        do
            echo "descargando ...\n"  
            if [ $a==$b ]
            then
                sleep 5 
                echo "################## Tarea realizada con exito ##################"
                flag=false
                break
            fi
        done
        echo "################## Descargando URL's ##################"
        `cat wget-log |sed -ne 's/.*\(http[^"]*\).*/\1/p'|awk '{print $1}'> links`
        echo "esto tardara un momento"
        `wget -nv -O - -i links | html2text |tr ' ' '\n'|sort -u > lista.txt `
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
