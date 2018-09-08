####2.Violin plots
data <-read.table("box_plots_mtcars.txt",header=T,sep="\t")
df <- data[, c("mpg", "cyl", "wt")]
df$cyl <- as.factor(df$cyl)
library(ggplot2)
#2.1 Basic violin plot
pdf("2.1.Basic_violinplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg)) + 
  geom_violin(trim=FALSE) +
  labs(title="Plot of mpg per cyl", x="Cyl", y = "Mpg")
dev.off()
#2.2 Add summary statistics on a violin plot
#2.2.1 Add median and quartile
pdf("2.2.1.Add_median&quartile1_violinplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg)) + 
  geom_violin(trim=FALSE) +
  labs(title="Plot of mpg per cyl", x="Cyl", y = "Mpg") +
  stat_summary(fun.y=mean, geom="point", shape=23, size=2, color="red")
dev.off()
#or
pdf("2.2.1.Add_median&quartile2_violinplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg)) + 
  geom_violin(trim=FALSE) +
  labs(title="Plot of mpg per cyl", x="Cyl", y = "Mpg") +
  geom_boxplot(width=0.1)
dev.off()
#2.2.2 Add mean and standard deviation
pdf("2.2.2.Add_mean&sd_violinplot1.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg)) + 
  geom_violin(trim=FALSE) +
  labs(title="Plot of mpg per cyl", x="Cyl", y = "Mpg") +
  stat_summary(fun.data="mean_sdl", fun.args = list(mult = 1), geom="crossbar", width=0.1 )
dev.off()
#or
pdf("2.2.2.Add_mean&sd_violinplot2.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg)) + 
  geom_violin(trim=FALSE) +
  labs(title="Plot of mpg per cyl", x="Cyl", y = "Mpg") +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult = 1), geom="pointrange", color="red")
dev.off()
#2.3 Change violin plot fill colors
pdf("2.3.Customized_violinplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg, fill=cyl)) + 
  geom_violin(trim=FALSE) +
  geom_boxplot(width=0.1, fill="white") +
  labs(title="Plot of mpg per cyl", x="Cyl", y = "Mpg") +
  scale_fill_brewer(palette="Blues") + 
  theme_classic()
dev.off()