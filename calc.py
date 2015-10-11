import sys
from math import log

tf = int(sys.argv[1])
df = int(sys.argv[2])
num_do = int(sys.argv[3])
div = num_do/df
res = log(div,10)
total = tf * res
print(total)
