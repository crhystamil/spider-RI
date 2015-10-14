import sys
from math import log, sqrt
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
for a in sys.argv[4]:
    entrada.append(a)
consulta1 = [ 'seguridad']
documentos = []

consulta = "select * from terminos, links_doc where terminos.path like links_doc.path and terminos LIKE '"+sys.argv[4]+"%';"
datos.execute(consulta)
for a in datos.fetchall():
    documentos.append(a)

list_doc = []
#print(documentos)

for doc in documentos:
    list_doc.append(doc[4])
list_doc = list(set(list_doc))
#print(list_doc)
sim = []
aux = 0

for m in documentos:
    for n in list_doc:
        if m[4] == n:
            aux = aux + (Decimal(m[2]) **2)
    sim.append((round(aux,4),m[7]))    
#print(aux)
sim = sorted(sim,reverse=True)


#for x in sim:
#    print("url: ",x[1])

tf = int(sys.argv[1])
df = int(sys.argv[2])
N = int(sys.argv[3])
if len(sim) <= 0:
    n = 1
else: 
    n= len(sim)

if N <= 0:
    N=1

div = (N/n)
vc = sqrt(aux)

ar = tf * log(div)
if ar <= 0:
    ar=1
if vc <= 0:
    vc = 1
total = ar/vc

print(total)






