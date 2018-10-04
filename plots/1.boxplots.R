####1.Box plots
library(ggplot2)
# Read the input files
# “header=T” means that the data has a title, and sep="\t" is used as the separator
data <-read.table("box_plots_mtcars.txt",header=T,sep="\t")
# The function c(,,) means create the vector type data 
df <- data[, c("mpg", "cyl", "wt")]
df$cyl <- as.factor(df$cyl)
df7 <- read.table("box_plots_David_GO.txt",header=T,sep="\t")
df7 <- df7[1:10,]
df7$Term <- sapply(strsplit(as.vector(df7$Term),'~'),'[',2)
#1.1 Basic box plot
pdf("1.1.Basic_boxplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg)) + 
  geom_boxplot(fill="gray")+
  labs(title="Plot of mpg per cyl",x="Cyl", y = "Mpg")+
  theme_classic()
dev.off()
#1.2 Change continuous color by groups
pdf("1.2.Customized_boxplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg, fill=cyl)) + 
  geom_boxplot()+
  labs(title="Plot of mpg per cyl",x="Cyl", y = "Mpg") +
  scale_fill_brewer(palette="Blues") + 
  theme_bw()
dev.off()
#1.3 Box plot for GO results
pdf("1.3.Customized_boxplot2.pdf", height = 5, width = 10)
ggplot(df7) + geom_bar(stat="identity", width=0.6, aes(Term,Fold.Enrichment, fill=-1*log10(PValue)),colour="#1d2a33") + 
  coord_flip() +
  scale_fill_gradient(low="#e8f3f7",high="#236eba")+
  labs(fill=expression(-log10_Pvalue), x="GO Terms",y="foldEnrichment", title="GO Biological Process") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))  +
  theme(axis.title.x =element_text(size=16), 
        axis.title.y=element_text(size=14)) +
  theme(axis.text.y = element_text(size = 10,face="bold"),
        axis.text.x = element_text(size = 12,face="bold"))
dev.off()