#!/bin/bash
#numero de documentos
nd=`ls Documents|wc -l`

#numero de terminos
num_term_doc(){
    nt=`wc -l $1`
}
#veces que se repite un termino en los documentos
terms_document(){
    cant_term=0
    for lista in `ls Documents/`
    do
        path="Documents/$lista"
        if [ -f $path ]
        then
            if grep -iq "$1" $path;then
                cant_term=$(( cant_term + 1 ))
            fi
        fi
    done
    echo $cant_term
}

weight_term(){
    weight=`echo "l($1/$2)/l($1)"|bc -l`
    echo $weigth
}


echo -n " Recolector\n"
echo -n "1) busqueda por profundidad\n"
echo -n "2) busqeuda \n"
echo -n "Introduce un valor:  "
read valor
case "$valor" in
    "1")
        echo "Introduce una URL"
        read url
        echo "Introduce el nivel de la profundidad (1,2,3,inf)"
        read profundidad
        # Initial spider
        estado=`wget --spider -l$profundidad -nv -r -b $url |head -n1|awk '{print $6}'|sed 's/\.//g'`
        `mv wget-log Logs/`
        links=$(echo "$url"|sed 's/http\:\/\///g'|tr "." " "|awk '{print $1}')
        while ps -p $estado
        do
            echo "Descargando"
            sleep 10
        done

        echo "################## Descargando URL's ##################"
        # Initial download of files and save on file
        `cat Logs/wget-log |sed -ne 's/.*\(http[^"]*\).*/\1/p'|awk '{print $1}'> Logs/$links`
        echo "esto tardara un momento"
        doc=0 
        for link in `cat Logs/$links`
        do
            ext=${link##*.}
            if [ $ext != "js" ] && [ $ext != "ico" ] && [ $ext != "jpg" ] && [ $ext != "png" ] && [ $ext != "txt" ] && [ $ext != "css" ]  && [ $ext != "pdf" ] && [ $ext != "gif" ] && [ $ext != "jpeg" ]

            then
                doc=$(( doc + 1 ))
                result=$links.$doc
                #`wget -nv -O - $link| html2text -utf8|tr ' ' '\n'|sed -f filtro |tr [:upper:] [:lower:]|sort|uniq -c >> Documents/$result`
                `wget -nv -O - $link| w3m -dump -T text/html|tr ' ' '\n'|sed -f filtro |tr [:upper:] [:lower:]|sort|uniq -c >> Documents/$result`
                num_pal=`wc -l Documents/$result |awk '{print $1}'`
                echo "INSERT INTO links_doc(path,link,num_pal) VALUES (\"Documents/$result\",\"$link\",$num_pal)" | mysql --user='root' --password='asdf999' --database='terminos'

                
            fi
        done
        # Initial indexer
        dir="Documents"
        num_doc=$(ls Documents|wc -l )
        for lista in `ls $dir`
        do
            path=$dir/$lista
            if [ -f $path ]
            then
#                if grep -iq "$2" $path;then
#                    cant_term=$(( cant_term + 1 ))
#                fi
                for value in `cat $path|awk '{print $1";"$2}'`
                do 
                    cant_term=0
                    tf=`echo $value|awk -F ";" '{print $1}'`
                    termino=`echo $value|awk -F ";" '{print $2}'`
                    if ! grep -iq "$termino" dic_neg.txt;then
                        df=$(terms_document $termino)
                        num_do=`ls Documents/|wc -l`
#                        div=$(( $num_do / $df ))
#                        weight=`echo "l($div)/l(10)"|bc -l`
#                        echo $div
#                        echo "$tf.$df.$num_do.$weight"
#                        echo $tf.$df.$num_do
                         echo $tf.$df.$num_do $termino
                         total=`python3.4 calc2.py $tf $df $num_do $termino`
#                        echo $total
                        echo "INSERT INTO terminos(terminos,cantidad,peso,path) VALUES (\"$termino\",$tf,\"$total\",\"$path\")" | mysql --user='root' --password='asdf999' --database='terminos'
                    fi
                done 
                echo "finish: "$path 
            fi
        done
        ;;
    "2")
        echo "Introducir la frase a buscar"
        read frase
        python3.4 search.py $frase
        ;;
      *)
        echo "elija una opcion"
        exit 1
esac
