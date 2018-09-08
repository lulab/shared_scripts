####8.Manhattan plots
df4 <- read.table("manhattan_plots_gwasResults.txt",header=T,sep="\t")
library(qqman)

pdf("8.Customized_manhattanplot.pdf", height = 5, width = 10)
manhattan(df4, main = "GWAS results", ylim = c(0, 8),
          cex = 0.5, cex.axis=0.8, col=c("dodgerblue4","deepskyblue"),
          #suggestiveline = F, genomewideline = F, #remove the suggestive and genome-wide significance lines
          chrlabs = as.character(c(1:22)))
dev.off()