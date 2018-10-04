####9.Heatmaps
df5 <-read.table("heatmaps.txt",header=T,sep="\t")
# Covert data into matrix format
# nrow(df5) and ncol(df5) return the number of rows and columns of matrix df5 respectively.
dm <- data.matrix(df5[1:nrow(df5),2:ncol(df5)])
# Get the row names
row.names(dm) <- df5[,1]

library(gplots)
library(pheatmap)
library(scales)
library(reshape2)
library(RColorBrewer)

#9.1.Draw the heatmap with the gplots package, heatmap.2 function
pdf("9.1.Customized_heatmap.pdf")
#to draw high expression value in red, we use colorRampPalette instead of redblue in heatmap.2
#colorRampPalette is a function in the RColorBrewer package
cr <- colorRampPalette(c("blue","white","red"))
heatmap.2(dm,
          scale="row", #scale the rows, scale each gene's expression value
          key=T, keysize=1.1, 
          cexCol=0.9,cexRow=0.8,
          col=cr(1000),
          ColSideColors=c(rep(c("blue","red"),5)),
          density.info="none",trace="none",
          #dendrogram='none', #if you want to remove dendrogram 
          Colv = T,Rowv = T #clusters by both row and col
)
dev.off()
#9.2.Draw the heatmap with the pheatmap pacakge, pheatmap function
#add column and row annotations
annotation_col = data.frame(CellType = factor(rep(c("Control", "Tumor"), 5)), Time = 1:5)
rownames(annotation_col) = colnames(dm)
annotation_row = data.frame(GeneClass = factor(rep(c("Path1", "Path2", "Path3"), c(10, 4, 6))))
rownames(annotation_row) = paste("Gene", 1:20, sep = "")
#set colors of each group
ann_colors = list(Time = c("white", "springgreen4"), 
                  CellType = c(Control = "#7FBC41", Tumor = "#DE77AE"),
                  GeneClass = c(Path1 = "#807DBA", Path2 = "#9E9AC8", Path3 = "#BCBDDC"))
pdf("9.2.Customized_heatmap.pdf")
pheatmap(dm, 
         cutree_col = 2, cutree_row = 3, #break up the heatmap by clusters you define
         cluster_rows=TRUE, show_rownames=TRUE, cluster_cols=TRUE, #by default, pheatmap clusters by both row and col
         annotation_col = annotation_col, annotation_row = annotation_row,annotation_colors = ann_colors)
dev.off()
#9.3.Draw the heatmap with the ggplot2 package
#9.3.1.cluster by row and col
#cluster and re-order rows
rowclust = hclust(dist(dm))
reordered = dm[rowclust$order,]
#cluster and re-order columns
colclust = hclust(dist(t(dm)))
#9.3.2.scale each row value in [0,1]
dm.reordered = reordered[, colclust$order]
dm.reordered=apply(dm.reordered,1,rescale) #rescale is a function in the scales package
dm.reordered=t(dm.reordered) #transposed matrix
#9.3.3.save col and row names before changing the matrix format
col_name=colnames(dm.reordered) 
row_name=rownames(dm.reordered) 
#9.3.4.change data format for geom_title 
colnames(dm.reordered)=1:ncol(dm.reordered)
rownames(dm.reordered)=1:nrow(dm.reordered)
dm.reordered=melt(dm.reordered) #melt is a function in the reshape2 package
head(dm.reordered)
#9.3.5.draw the heatmap
pdf("9.3.Customized_heatmap.pdf")
ggplot(dm.reordered, aes(Var2, Var1)) + 
  geom_tile(aes(fill = value), color = "white") + 
  scale_fill_gradient(low = "white", high = "steelblue") +
  theme_grey(base_size = 10) + 
  labs(x = "", y = "") + 
  scale_x_continuous(expand = c(0, 0),labels=col_name,breaks=1:length(col_name)) + 
  scale_y_continuous(expand = c(0, 0),labels=row_name,breaks=1:length(row_name))
dev.off()

