import sys
import re

dict = {}
f1 = open(sys.argv[1])
for i in f1:
	l = i.strip().split('\t')
	utrid0 = '\t'.join(l[0:5])
	dict[utrid0] = l[5]
f1.close()

f2 = open(sys.argv[2])
for j in f2:
	ll = j.strip().split('\t')
	trid = ll[8].strip().split('; ')[1].split(' ')[1].strip('\"')	
	utrid = ll[0]+'\t'+ll[3]+'\t'+ll[4]+'\t'+trid+'\t'+ll[6]
	if utrid in dict:
		print ll[0]+'\t'+ll[1]+'\t'+dict[utrid]+'\t'+ll[3]+'\t'+ll[4]+'\t.\t'+ll[6]+'\t.\t'+ll[8]

f2.close()
