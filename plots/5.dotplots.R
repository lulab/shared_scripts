####5.Dot plots
data <-read.table("box_plots_mtcars.txt",header=T,sep="\t")
df <- data[, c("mpg", "cyl", "wt")]
df$cyl <- as.factor(df$cyl)
library(ggplot2)
#5.1 Basic dot plots
pdf("5.1.Basic_dotplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg)) + 
  geom_dotplot(binaxis='y', stackdir='center', binwidth=1)
dev.off()
#5.2 Add mean and standard deviation
pdf("5.2.Add_mean&sd1_dotplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg)) + 
  geom_dotplot(binaxis='y', stackdir='center', binwidth=1) + 
  stat_summary(fun.data="mean_sdl", fun.args = list(mult=1), geom="crossbar", width=0.5)
dev.off()
#or
pdf("5.2.Add_mean&sd2_dotplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg)) + 
  geom_dotplot(binaxis='y', stackdir='center', binwidth=1) + 
  stat_summary(fun.data="mean_sdl", fun.args = list(mult=1), geom="pointrange", color="red")
dev.off()
#5.3 Change dot colors
pdf("5.3.Customized_dotplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg, fill=cyl, shape=cyl)) + 
  geom_dotplot(binaxis='y', stackdir='center', binwidth=1, dotsize=0.8) + 
  labs(title="Plot of mpg per cyl",x="Cyl", y = "Mpg") +
  #stat_summary(fun.data="mean_sdl", fun.args = list(mult=1), geom="crossbar", width=0.5) +
  scale_fill_brewer(palette="Blues") +
  #scale_color_brewer(palette="Blues") +
  theme_classic()
dev.off()
#5.4 Change dot colors, shapes and align types
pdf("5.4.Customized_dotplot.pdf", height = 3, width = 3)
ggplot(df, aes(x=cyl, y=mpg, color=cyl, shape=cyl)) + 
  geom_jitter(position=position_jitter(0.1), cex=2)+
  labs(title="Plot of mpg per cyl",x="Cyl", y = "Mpg") + 
  scale_color_brewer(palette="Blues") + 
  theme_classic()
dev.off()
