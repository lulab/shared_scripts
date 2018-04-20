#!/usr/bin/python

print ''' Usage: get introns for coding genes or lncRNAs
	  use sorted exon.gtf)
	  python makeIntron.py coding_exon.gff coding_intron.gff	
'''
import sys
import re

trs1 = ''
f1 = open(sys.argv[1])  # exon.gff
f2 = open(sys.argv[2],'w')	# intron.gff
for i in f1:
	line = i.strip().split('\t')
	anno = line[8]
	trs2 = anno.strip().split(' ')[3]
	if trs2 != trs1:
		intron_start = str(int(line[4]) + 1)
		trs1 = trs2
	else:
		intron_end = str(int(line[3]) - 1)
		f2.write(line[0] + '\t' + line[1] + '\tintron\t' + intron_start + '\t' + intron_end + '\t.\t' + line[6] + '\t.\t' + line[8] + '\n')	
		intron_start = str(int(line[4]) + 1)
f2.close()			
f1.close()
