Args	=	commandArgs(TRUE);
inputF1	=	Args[1];#input the matrix; with header; each column is a feature and each row is a sample
inputF2	=	Args[2];#input features that used to perform clustering
inputF3	=	as.numeric(Args[3]);#input k as parameter
output1	=	Args[4];#output the matrix with clusterID;
output2	= 	Args[5];#output the heatmap file;
library("gplots")

#preprocessing matrix;
Matrix	=	read.table(inputF1,sep="\t",head=T);
FN	=	colnames(Matrix);
FI	=	as.vector(as.matrix(read.table(inputF2,head=F,sep="\t")));
ID	=	which(is.element(FN,FI));
Matrix1	=	as.matrix(Matrix[,ID]);
#kmeans clustering
km      =       kmeans(Matrix1,inputF3,iter.max=1000);
cluster =       (km$cluster);
#output matrix with cluster ID for each row;
Matrix2	=	cbind(cluster,Matrix);
write.table(Matrix2,file=output1,sep="\t",quote=F,col.name=T,row.name=F);

#draw heatmap with sampled 5000 samples;
mycolhc =       rainbow(length(unique(cluster)), start=0.1, end=0.9); 
mycolhc =       mycolhc[cluster];
ID3     =       order(cluster);
Matrix3 =       Matrix1[ID3,];
mycolhc3=       mycolhc[ID3];
if(nrow(Matrix3)>5000){
ID4	=	sort(sample(1:nrow(Matrix3),size=5000,replace=F));
Matrix4	=	Matrix3[ID4,];
mycolhc4=	mycolhc3[ID4];
}else{
Matrix4	=	Matrix3;
mycolhc4=	mycolhc3;
}
pdf(output2,width=4,height=5);
heatmap.2(Matrix4,Rowv = FALSE, Colv=FALSE,margins = c(8, 1),labRow=F,dendrogram="none",scale = "none",trace="none",RowSideColors=mycolhc4);
dev.off()



