####7.Volcano plots
df3 <- read.table("volcano_plots.txt", header=TRUE)
library(ggplot2)

df3$threshold <- as.factor(ifelse(df3$padj < 0.05 & abs(df3$log2FoldChange) >=1,ifelse(df3$log2FoldChange > 1 ,'Up','Down'),'Not'))
pdf("7.Customized_volcanoplot.pdf", height = 5, width = 5)
ggplot(data=df3, aes(x=log2FoldChange, y =-log10(padj), color=threshold,fill=threshold)) +
  scale_color_manual(values=c("blue", "grey","red"))+
  geom_point(size=1) +
  xlim(c(-3, 3)) +
  theme_bw(base_size = 12, base_family = "Times") +
  geom_vline(xintercept=c(-1,1),lty=4,col="grey",lwd=0.6)+
  geom_hline(yintercept = -log10(0.05),lty=4,col="grey",lwd=0.6)+
  theme(legend.position="right",
        panel.grid=element_blank(),
        legend.title = element_blank(),
        legend.text= element_text(face="bold", color="black",family = "Times", size=8),
        plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(face="bold", color="black", size=12),
        axis.text.y = element_text(face="bold",  color="black", size=12),
        axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold",color="black", size=12))+
  labs(x="log2FoldChange",y="-log10 (adjusted p-value)",title="Volcano plot of DEG", face="bold")
dev.off()