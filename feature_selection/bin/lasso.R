########	lasso algorithm
Args	=	commandArgs(TRUE);
inputF1	=	Args[1];#with header; bin, anno, features
inputF2 =	Args[2];#input the initial feature names, with no header;
outputF	=	Args[3];#output features coeffiecents

mx	=	read.table(inputF1,sep="\t",header=T);#the matrix in the fixed format
mx	=	mx[,-1];
dataall	=	as.matrix(mx[,-1]);
classesall	=	as.matrix(mx[,1]);
FI	=	as.vector(as.matrix(read.table(inputF2,head=F,sep="\t")));
FN	=	colnames(dataall);
ID	=	which(is.element(FN,FI));

dataall	=	dataall[,ID];

library("glmnet")
cvob1	=	cv.glmnet(dataall,as.factor(classesall),family="multinomial");
coefs	<-	coef(cvob1,s="lambda.1se");
classesID	=	unique(classesall)[,1];

for(i in 1:length(classesID)){
	coefs_i	=	as.matrix(coefs[[i]]);
	if(i==1){
		out	=	coefs_i;
	}else{
		out	=	cbind(out,coefs_i);
	}
}
colnames(out)	=	classesID;
out	=	data.frame(out);
coef	=	rownames(out);
coef	=	data.frame(coef);
out2	=	cbind(coef,out);

write.table(out2,file=outputF,quote=F,row.names=F,col.names=T,sep="\t");



