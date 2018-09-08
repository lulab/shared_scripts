####3.Histogram plots
df2 <-read.table("histogram_plots.txt",header=T,sep="\t")
library(ggplot2)
library(plyr)
#3.1 Basic histogram plot
pdf("3.1.Basic_histogramplot.pdf", height = 3, width = 3)
ggplot(df2, aes(x=weight)) + geom_histogram(binwidth=1)
dev.off()
#3.2 Add mean line on a histogram plot
pdf("3.2.Add_meanline_histogramplot.pdf", height = 3, width = 3)
ggplot(df2, aes(x=weight)) + 
  geom_histogram(binwidth=1, color="black", fill="white") +
  geom_vline(aes(xintercept=mean(weight)),color="black", linetype="dashed", size=0.5)
dev.off()
#3.3 Change histogram plot fill colors
#Use the plyr package plyr to calculate the average weight of each group :
mu <- ddply(df2, "sex", summarise, grp.mean=mean(weight))
head(mu)
#draw the plot
pdf("3.3.Customized_histogramplot.pdf", height = 3, width = 3)
ggplot(df2, aes(x=weight, color=sex)) +
  geom_histogram(binwidth=1, fill="white", position="dodge")+
  geom_vline(data=mu, aes(xintercept=grp.mean, color=sex), linetype="dashed") +
  scale_color_brewer(palette="Paired") + 
  theme_classic()+
  theme(legend.position="top")
dev.off()
