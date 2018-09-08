####10.Ballon plots
df6 <- read.table("ballon_plots_GO.txt", header=T, sep="\t")
library(ggplot2)
#10.1.basic ballon plots
pdf("10.1.Basic_ballonplot.pdf", height=6, width=8)
ggplot(df6, aes(x=Fold.enrichment, y=Biological.process)) +
  geom_point(aes(size = X.log10.Pvalue.)) +
  scale_x_continuous(limits=c(0,7),breaks=0:7) +
  scale_size(breaks=c(1,5,10,15,20,25)) +
  theme_light() +
  theme(panel.border=element_rect(fill='transparent', color='black', size=1),
        plot.title = element_text(color="black", size=14, hjust=0.5, face="bold", lineheight=1),
        axis.title.x = element_text(color="black", size=12, face="bold"),
        axis.title.y = element_text(color="black", size=12, vjust=1.5, face="bold"),
        axis.text.x = element_text(size=12,color="black",face="bold"),
        axis.text.y = element_text(size=12,color="black",face="bold"),
        legend.text = element_text(color="black", size=10, hjust=-2),
        legend.position="bottom") +
  labs(x="Fold Enrichment",y="Biological Process",size="-log10(Pvalue)", title="GO Enrichment",face="bold")
dev.off()
#10.2.change the dot colors
pdf("10.2.Customized_ballonplot.pdf")
ggplot(df6, aes(x=col, y=Biological.process,color=X.log10.Pvalue.)) +
  geom_point(aes(size = Fold.enrichment)) +
  scale_x_discrete(limits=c("1")) +
  scale_size(breaks=c(1,2,4,6)) +
  scale_color_gradient(low="#fcbba1", high="#a50f15") +
  theme_classic() +
  theme(panel.border=element_rect(fill='transparent', color='black', size=1),
        plot.title = element_text(color="black", size=14, hjust=0.5, face="bold", lineheight=1),
        axis.title.x = element_blank(),
        axis.title.y = element_text(color="black", size=12, face="bold"),
        axis.text.x = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_text(size=12,color="black",face="bold"),
        legend.text = element_text(color="black", size=10)) +
  labs(y="Biological Process",size="Fold Enrichment", color="-Log10(Pvalue)",title="GO Enrichment",face="bold")
dev.off()
