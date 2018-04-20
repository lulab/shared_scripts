
#!/usr/bin/python

#print '''Usage: get ncRNA2 subtype exons from exon.gff
#	e.g. python getlncRNAexon.py lncRNA_gold_intergenic.gff lncRNA_gold_intergenic.exon.gff
#'''
import sys
import re

dict = {}
f1 = open(sys.argv[1])  ## ncRNA2 subtypes
for i in f1:
	l = i.strip().split('\t')
	trID = l[8].split('; ')[1].split(' ')[1]
	dict[trID] = 'ncRNAtr'
f1.close()

f2 = open('exon.gff')
f3 = open(sys.argv[2],'w')  ## ncRNA2 sbutype exon gff
for j in f2:
	if re.search('lincRNA',j):
		Parent = j.strip().split('\t')[8].split('; ')[1].split(' ')[1]
		if Parent in dict:
			f3.write(j)

f3.close()
f2.close()



