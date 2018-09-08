####6.Scatter plots
data <-read.table("box_plots_mtcars.txt",header=T,sep="\t")
df <- data[, c("mpg", "cyl", "wt")]
df$cyl <- as.factor(df$cyl)
library(ggplot2)
#6.1 Basic scatter plots
pdf("6.1.Basic_scatterplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=wt, y=mpg)) + 
  geom_point(size=1.5)
dev.off()
#6.2 Add regression lines and change the point colors, shapes and sizes
pdf("6.2.Customized_scatterplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=wt, y=mpg, color=cyl, shape=cyl)) +
  geom_point(size=1.5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  theme_classic()
dev.off()
