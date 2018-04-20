 inputF1="/home/hulong/module/feature_selection/input/example.train.mx";
 inputF2="/home/hulong/module/feature_selection/tmp/idx/cv.idx";
 inputF3="5";
 inputF4="/home/hulong/module/feature_selection/tmp/IMP/rank/rank";
#Args <-commandArgs(TRUE);
#inputF1= Args[1];#input TR.b.m ; first column is bin,second is label, seperated by tab, with header;
#inputF2= Args[2];#input the cv.idx, no header;
#inputF3= Args[3];#input CV fold;
#inputF4= Args[4];#the rank file; the most important ones are on the top. two columns. the first is the features' names, the second is the rank of features. features have the same will be deleted together in one time.


my_qsub<-function(inputF1,inputF2,inputF3,inputF4,outputF,qsubF,logF){
str=paste("#$ -S /bin/bash\n#$ -cwd\n#$ -j y\n#$ -q q1.* \n#$ -N DEL_rank_c\nRscript","/home/hulong/module/feature_selection/bin/cv.test.R",inputF1,inputF2,inputF3,inputF4,outputF)
write(str,file=qsubF);
system(paste("rm",outputF));
system(paste("rm",logF));
system(paste("qsub -V -o",logF,qsubF));
}
my_check<-function(file_path,FileList){
        while(1==1){
                filelist_all=list.files(path=file_path,full.names=T);
		tmp=is.element(FileList,filelist_all);
                if(all(tmp)){break;}
		Sys.sleep(30);
        }
}

RANK		=	read.table(inputF4,head=F,sep="\t");
RANK_groups	=	RANK[,2];
RANK_group	=	as.vector(unique(RANK_groups));
Feat		=	as.vector(RANK[,1]);

FileList	=	c();
for (i in sort(RANK_group,decreasing=T)){
	ID1	=	which(RANK_groups<=i);
	Feat_i	=	Feat[ID1];	
	tmp	=	max(RANK_group)-i;
	featF	=	paste("./feat/feat",tmp,sep=".");
	write.table(Feat_i,file=featF,sep="\t",col.name=F,row.name=F,quote=F);
	qsubF	=	paste("./qsub/qsub_del",tmp,sep=".");
	logF	=	paste("./log/log_del",tmp,sep=".");
	perfF	=	paste("./perf/perf_del",tmp,sep=".");
	my_qsub(inputF1,inputF2,inputF3,featF,perfF,qsubF,logF);
	FileList	=	c(FileList,perfF);
}
file_path="./perf"
my_check(file_path,FileList);
Sys.sleep(2);
Perf_summary=matrix(0,nrow=0,ncol=2);
for (i in sort(RANK_group,decreasing=T)){
	tmp	=	max(RANK_group)-i;
	perfF	=	paste("./perf/perf_del",tmp,sep=".");
	Perf	=	as.vector(as.matrix(read.table(perfF,head=F,sep="\t")));
	Perf_summary	=	rbind(Perf_summary,Perf)
}
colnames(Perf_summary)<-c("acc","nvar");
write.table(Perf_summary,file=paste("perf_del_sum","txt",sep="."),sep="\t",col.name=T,row.name=F,quote=F);
pdf(paste("perf_del_sum","pdf",sep="."))
plot(Perf_summary[,"nvar"],Perf_summary[,"acc"],type="o",lwd=2);
dev.off()

rm(list=ls());



