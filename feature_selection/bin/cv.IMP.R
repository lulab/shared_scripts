Args <-commandArgs(TRUE);
inputF1= Args[1];#input train matrix; first column is bin, second is label, seperated by tab, with header;
inputF2= Args[2];#input the cv.idx, no header;
inputF3= Args[3];#input cross-validation fold;should be consistent with the cv.idx
outputF2=Args[4];#output the IMP
library(randomForest);
cv.fold=as.numeric(inputF3);
Matrix1=read.table(inputF1,sep="\t",head=T,check.name=F);
#first column is bin, remove it when learning;
Matrix1=Matrix1[,-1];
trainx=as.matrix(Matrix1[,-1]);
trainy=as.factor(as.matrix(Matrix1[,1]));
rm("Matrix1");
idx=as.vector(as.matrix(read.table(inputF2,sep="\t",head=F)));
my_fuc<-function(trainx,trainy,idx,cv.fold){
	cv.pred <- trainy;
	p=ncol(trainx);
	MTRY=max(1,floor(sqrt(p)));
        for (i in 1:cv.fold) {
	    all.rf <- randomForest(trainx[idx != i, , drop = FALSE], trainy[idx != i], trainx[idx == i, , drop = FALSE], trainy[idx == i],mtry=MTRY,importance=T,ntree=1000,proximity=F);
	    cv.pred[idx == i] <- all.rf$test$predicted;
	    if(i==1){
		IMP=all.rf$importance;
	    }else{
		IMP=IMP+all.rf$importance;
	    }
        }
	acc=mean(cv.pred==trainy);	
	out=list(acc=acc,IMP=IMP);
}

all.acc=my_fuc(trainx,trainy,idx,cv.fold);
IMP=all.acc$IMP;
IMP2=IMP[order(IMP[,"MeanDecreaseAccuracy"], decreasing = F),];
write.table(IMP2,file=outputF2,sep="\t",quote=F,row.name=T,col.name=T);

rm(list=ls());


