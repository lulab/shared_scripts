####1.Box plots
library(ggplot2)
data <-read.table("box_plots_mtcars.txt",header=T,sep="\t")
df <- data[, c("mpg", "cyl", "wt")]
df$cyl <- as.factor(df$cyl)
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
