####4.Density plots
df2 <-read.table("histogram_plots.txt",header=T,sep="\t")
library(ggplot2)
library(plyr)
#4.1 Basic density
pdf("4.1.Basic_densityplot.pdf", height = 3, width = 3)
ggplot(df2, aes(x=weight)) + 
  geom_density()
dev.off()
#4.2 Add mean line on a density plot
pdf("4.2.Add_meanline_densityplot.pdf", height = 3, width = 3)
ggplot(df2, aes(x=weight)) +
  geom_density() +
  geom_vline(aes(xintercept=mean(weight)), color="black", linetype="dashed", size=0.5)
dev.off()
#4.3 Change density plot fill colors
#Use the plyr package plyr to calculate the average weight of each group :
mu <- ddply(df2, "sex", summarise, grp.mean=mean(weight))
head(mu)
#draw the plot
#4.3.1 Change fill colors
pdf("4.3.1.Customized_histogramplot1.pdf", height = 3, width = 3)
ggplot(df2, aes(x=weight, fill=sex)) +
  geom_density(alpha=0.7)+
  geom_vline(data=mu, aes(xintercept=grp.mean, color=sex), linetype="dashed")+
  labs(title="Weight density curve",x="Weight(kg)", y = "Density") + 
  scale_color_brewer(palette="Paired") +
  scale_fill_brewer(palette="Blues") +
  theme_classic()
dev.off()
#4.3.2 Change line colors
pdf("4.3.2.Customized_histogramplot2.pdf", height = 3, width = 3)
ggplot(df2, aes(x=weight, color=sex)) +
  geom_density()+
  geom_vline(data=mu, aes(xintercept=grp.mean, color=sex), linetype="dashed")+
  labs(title="Weight density curve",x="Weight(kg)", y = "Density") + 
  scale_color_brewer(palette="Paired") +
  theme_classic()
dev.off()
#4.3.3 Combine histogram and density plots
pdf("4.3.3.Customized_histogramplot3.pdf", height = 3, width = 3)
ggplot(df2, aes(x=weight, color=sex, fill=sex)) + 
  geom_histogram(binwidth=1, aes(y=..density..), alpha=0.5, position="identity") +
  geom_density(alpha=.2) +
  labs(title="Weight density curve",x="Weight(kg)", y = "Density") + 
  scale_color_brewer(palette="Paired") +
  scale_fill_brewer(palette="Blues") +
  theme_classic()
dev.off()
