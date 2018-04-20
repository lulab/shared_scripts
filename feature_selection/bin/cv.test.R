Args <-commandArgs(TRUE);
inputF1= Args[1];#input TR.b.m ; first column is bin second is label, seperated by tab, with header;
inputF2= Args[2];#input the cv.idx, no header;
inputF3= Args[3];#input CV fold;
inputF4= Args[4];#input features, with no header;
outputF= Args[5];#output the performance and how many features used in this round.

library(randomForest);
cv.fold=as.numeric(inputF3);
Matrix1=read.table(inputF1,sep="\t",head=T,check.name=F);
#first column is bin, remove it when learning;
Matrix1=Matrix1[,-1];
trainx=as.matrix(Matrix1[,-1]);
trainy=as.factor(as.matrix(Matrix1[,1]));
rm("Matrix1");
idx=as.vector(as.matrix(read.table(inputF2,sep="\t",head=F)));
FI=as.vector(as.matrix(read.table(inputF4,head=F,sep="\t")));
FN=colnames(trainx);
ID=which(is.element(FN,FI));
trainx=trainx[,ID];
    my_fuc<-function(trainx,trainy,idx,cv.fold){
	trainx=as.matrix(trainx);
	cv.pred <- trainy;
	p=ncol(trainx);
	MTRY=max(1,floor(sqrt(p)));
        for (i in 1:cv.fold) {
            all.rf <- randomForest(trainx[idx != i, , drop = FALSE], trainy[idx != i], trainx[idx == i, , drop = FALSE], trainy[idx == i],mtry=MTRY,importance=F,ntree=1000,proximity=F);
            cv.pred[idx == i] <- all.rf$test$predicted;
        }
        acc=mean(cv.pred==trainy);      
   	acc;
    }

all.acc=my_fuc(trainx,trainy,idx,cv.fold);
out=c(all.acc,length(FI));
write.table(out,file=outputF,sep="\t",quote=F,row.name=F,col.name=F);

rm(list=ls());


