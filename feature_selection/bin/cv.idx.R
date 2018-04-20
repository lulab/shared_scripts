Args <-commandArgs(TRUE);
inputF1= Args[1];#input label column, with header;
inputF2= Args[2];#input CV fold
outputF= Args[3];#output index

trainy=as.factor(as.matrix(read.table(inputF1,sep="\t",head=T)));
cv.fold=as.numeric(inputF2);
    n <- length(trainy);
    nlvl <- table(trainy);
    idx <- numeric(n);
    for (i in 1:length(nlvl)) {
        idx[which(trainy == levels(trainy)[i])] <- rep(1:cv.fold,each=floor(nlvl[i]/cv.fold),length.out = nlvl[i]);
    }
write.table(idx,file=outputF,sep="\t",quote=F,col.name=F,row.name=F);
rm(list=ls());

