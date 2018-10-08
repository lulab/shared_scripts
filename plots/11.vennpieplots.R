####11.Vennpie plots
library(plotrix)
#The vennpie plot is the combination of a venn diagram and a pie chart.
#11.1.data input (number of reads mapped to each category)
total=100
rRNA=5
mtRNA=7
intergenic=48 
introns=12
exons=30
upstream=3
downstream=6
not_near_genes=40

rest=total-rRNA-mtRNA
genic=rest-intergenic
introns_and_exons=introns+exons-genic
#11.2 draw the plot
install.packages("plotrix")
library(plotrix)
pdf("11.Customized_vennpieplot.pdf", height=8, width=6)
# parameter for pie chart
iniR=0.2 # initial radius
colors=list(NO='white',total='black',mtRNA='#e5f5e0',rRNA='#a1d99b',
            genic='#3182bd',intergenic='#fec44f',introns='#fc9272',
            exons='#9ecae1',upstream='#ffeda0',downstream='#fee0d2',
            not_near_genes='#d95f0e')

# from outer circle to inner circle
#0 circle: blank
pie(1, radius=iniR, init.angle=90, col=c('white'), border = NA, labels='')
#4 circle: show genic:exons and intergenic:downstream
floating.pie(0,0,
             c(exons, genic-exons+not_near_genes, downstream, mtRNA+rRNA+intergenic-not_near_genes-downstream),
             radius=5*iniR, 
             startpos=pi/2, 
             col=as.character(colors[c('exons','NO','downstream','NO')]),
             border=NA)
#3 circle: show genic:introns and intergenic:not_near_genes | upstream
floating.pie(0,0,
             c(genic-introns, introns, not_near_genes, intergenic-upstream-not_near_genes, upstream, mtRNA+rRNA),
             radius=4*iniR,
             startpos=pi/2, 
             col=as.character(colors[c('NO','introns','not_near_genes','NO','upstream','NO')]),
             border=NA)
#2 circle: divide the rest into genic and intergenic
floating.pie(0,0,
             c(genic, intergenic, mtRNA+rRNA),
             radius=3*iniR, 
             startpos=pi/2, 
             col=as.character(colors[c('genic','intergenic','NO')]),
             border=NA)
#1 circle: for rRNA+mtRNA+rest
floating.pie(0,0, 
             c(rest, rRNA,mtRNA), 
             radius=2*iniR, 
             startpos=pi/2, 
             col=as.character(colors[c('NO','rRNA','mtRNA')]), 
             border = NA)
legend(0, 6*iniR, gsub("_"," ",names(colors)[-1]), 
       col=as.character(colors[-1]), 
       pch=19, bty='n', ncol=2)
dev.off()
## or, in one column with reads count and %
#names=gsub("_"," ",names(colors)[-1])
#values = sapply(names(colors)[-1], get)
#percent=format(100*values/total, digits=2, trim=T)
#values = format(values, big.mark=",", scientific=FALSE, trim=T)
#cl=as.character(colors[-1])
#pchs=rep(19, length(cl)); pchs[1]=1;
#legend(0, 5*iniR, paste(names," (",values,", ", percent,"%)", sep=""), 
#       col=cl, pch=pchs,bty='n', ncol=1, cex=0.6)

