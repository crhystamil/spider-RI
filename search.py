import sys
import mysql.connector
from decimal import Decimal

def mayor(a):
    num=0
    url=""
    res=[]
    for b in a:
        if (b[0]>num):
            num=b[0]
            url=b[1]
    res.append(num)
    res.append(url)
    return res

conexion = mysql.connector.connect(user='root', password='asdf999', database='terminos')
datos = conexion.cursor()
entrada = []
for a in sys.argv[1:]:
    entrada.append(a)
consulta1 = ['auditoria', 'cambiar', 'gremios', 'seguridad']
documentos = []
for termino in entrada:
    consulta = "select * from terminos, links_doc where terminos.path like links_doc.path and terminos LIKE '"+termino+"%';"
    datos.execute(consulta)
    for a in datos.fetchall():
        documentos.append(a)
list_doc = []
for doc in documentos:
    list_doc.append(doc[4])
list_doc = list(set(list_doc))
sim = []
aux = 0
for m in documentos:
    for n in list_doc:
        if m[4] == n:
            aux = aux + (Decimal(m[3]) * Decimal(m[3]))
    sim.append((round(aux,4),m[7]))    
print(sim)
sim = sorted(sim,reverse=True)
for x in sim:
    print("url: ",x[1])

print(entrada)


